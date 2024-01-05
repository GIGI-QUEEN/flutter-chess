// ignore_for_file: avoid_print

import 'dart:async';

import 'package:client/models/game.dart';
import 'package:client/models/lobby.dart';
import 'package:client/models/user.dart';
import 'package:client/services/data_base_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:chess/chess.dart' as chesslib;
import 'package:simple_chess_board/simple_chess_board.dart';

class LobbyProvider extends ChangeNotifier {
  Lobby currentLobby;
  bool hasJoined = false;
  List<User> _availableUsers = [];
  List<User> get availableUsers => _availableUsers;

  final DataBaseService _dataBaseService = DataBaseService();
  final _database = FirebaseDatabase.instance.ref();
  final chess = chesslib.Chess.fromFEN(chesslib.Chess.DEFAULT_POSITION);
  String currentTurn = '';
  String fen = ''; //'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
  bool isCheck = false;
  bool isCheckmate = false;
  bool isGameOver = false;
  User? winner;
  ShortMove? lastMove;
  String _gameEndReason = '';
  String get gameEndReason => _gameEndReason;
  //String currentMove = 'white';

  late StreamSubscription _lobbyStreamSubscription;
  late StreamSubscription _gameStartSubscription;
  late StreamSubscription _gameSubscription;
  // late StreamSubscription _currentMoveSubscription;

  LobbyProvider({required this.currentLobby}) {
    _listenToLobbyChanges();
    listenToGameStart();
    _listenToBoardChanges();
    // _listenToCurrentMove();
    _dataBaseService.getAllUsers();
  }

  void _listenToLobbyChanges() async {
    //checking if somebody connects and disconnects from lobby
    _lobbyStreamSubscription = _database
        .child('lobbies/${currentLobby.lobbyId}/guest')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        //print('value: ${event.snapshot.value}');
        final User guest = User.fromRTBD(
            Map<String, dynamic>.from(event.snapshot.value as dynamic));
        currentLobby.guest = guest;
        //print("guest!: ${guest.username}");
        hasJoined = true;
        notifyListeners();
      } else {
        hasJoined = false;
        currentLobby.guest = null;
        notifyListeners();
      }
    });
  }

  void listenToGameStart() {
    _gameStartSubscription = _database
        .child('lobbies/${currentLobby.lobbyId}/game/status')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        _database
            .child("lobbies/${currentLobby.lobbyId}/game")
            .get()
            .then((value) {
          print("value: ${value.value}");
          final game =
              Game.fromRTDB(Map<String, dynamic>.from(value.value as dynamic));

          currentLobby.game = game;

          notifyListeners();
        });
      }
    });
  }

  void _listenToBoardChanges() {
    _gameSubscription = _database
        .child("lobbies/${currentLobby.lobbyId}/game/board_state")
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        final fenJSON =
            Map<String, dynamic>.from(event.snapshot.value as dynamic);
        fen = fenJSON['fen'];

        chess.load(fen);

        if (chess.in_check) {
          isCheck = true;
        } else {
          isCheck = false;
        }
        if (chess.in_draw) {
          _gameEndReason = 'Draw';
          isGameOver = true;
        }
        if (chess.in_stalemate) {
          _gameEndReason = 'Stalemate';
          isGameOver = true;
        }
        if (chess.in_checkmate) {
          isCheckmate = true;
          isGameOver = true;
          _gameEndReason = 'Check mate';

          switch (chess.turn.name.toLowerCase()) {
            case 'black':
              getWinner('white');
              break;
            case 'white':
              getWinner('black');
              break;
          }
        }

        if (chess.game_over) {
          _dataBaseService.removeLobbyFromDB(currentLobby);
          _dataBaseService.removeInviteFromDB(
              currentLobby.guest!, currentLobby);
        }

        notifyListeners();
      }
    });
  }

  void tryMakingMove({required ShortMove move}) {
    final success = chess.move(<String, String?>{
      'from': move.from,
      'to': move.to,
      'promotion': move.promotion.match(
        (piece) => piece.name,
        () => null,
      ),
    });

    notifyListeners();
    if (success) {
      final nextMove = chess.turn == Color.BLACK ? 'black' : 'white';

      sendMoveToDB(chess.fen, nextMove);
    }
  }

  void sendMoveToDB(String fen, String currentMove) {
    _dataBaseService.addMoveToDB(currentLobby, fen, currentMove);
  }

  void listenToGameChanges() {
    _gameSubscription = _database.child('').onValue.listen((event) {});
  }

  void completeSearch(String text) async {
    _availableUsers = await _dataBaseService.findUsers(text);
    notifyListeners();
  }

  void updateLobbyGuest(User guest) async {
    await _dataBaseService.updateLobbyGuestInDB(currentLobby, guest);
  }

  void unjoin() {
    _dataBaseService.deleteGuestFromLobby(currentLobby);
  }

  String getCurrentTurn(User me) {
    final currentTurn = currentLobby.game?.players.values
        .firstWhere((user) => user.color == chess.turn.name.toLowerCase())
        .username;
    return "Current turn: $currentTurn ${currentTurn == me.username ? "(you)" : ""}";
  }

  void getWinner(String winnerColor) {
    winner = currentLobby.game?.players.values
        .firstWhere((user) => user.color == winnerColor);
  }

  @override
  void dispose() {
    _lobbyStreamSubscription.cancel();
    _gameStartSubscription.cancel();
    _gameSubscription.cancel();

    hasJoined = false;
    super.dispose();
  }
}
