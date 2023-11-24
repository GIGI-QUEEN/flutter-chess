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
  String fen = ''; //'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
  ShortMove? lastMove;
  String currentMove = 'white';

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
        /// print("EVENT: ${event.snapshot.value}");
        final fenJSON =
            Map<String, dynamic>.from(event.snapshot.value as dynamic);
        fen = fenJSON['fen'];
        // currentMove = fenJSON['current_move'];
        // print("CURRENT MOVE: $currentMove");
        // chess.turn = currentMove == 'white' ? Color.WHITE : Color.BLACK;
        chess.load(fen);

        notifyListeners();
        //print("FENJSON $fenJSON");
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

  @override
  void dispose() {
    _lobbyStreamSubscription.cancel();
    _gameStartSubscription.cancel();
    _gameSubscription.cancel();
    /*  _dataBaseService.deleteGuestFromLobby(
        currentLobby); */ // remove guest from lobby when he leaves the screen
    hasJoined = false;
    super.dispose();
  }
}






/* class LobbyProvider extends ChangeNotifier {
  Lobby currentLobby;
  bool hasJoined = false;
  List<User> _availableUsers = [];
  List<User> get availableUsers => _availableUsers;

  final DataBaseService _dataBaseService = DataBaseService();
  final _database = FirebaseDatabase.instance.ref();
  ChessBoardController controller = ChessBoardController();
  bool isWhiteTurn = true;

  late StreamSubscription _lobbyStreamSubscription;
  late StreamSubscription _gameStartSubscription;
  late StreamSubscription _gameSubscription;
  late StreamSubscription _currentMoveSubscription;

  LobbyProvider({required this.currentLobby}) {
    _listenToLobbyChanges();
    listenToGameStart();
    _listenToBoardChanges();
    _listenToCurrentMove();
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
        /// print("EVENT: ${event.snapshot.value}");
        final fenJSON =
            Map<String, dynamic>.from(event.snapshot.value as dynamic);
        final fen = fenJSON['fen'];
        controller.loadFen(fen);
        notifyListeners();
        //print("FENJSON $fenJSON");
      }
    });
  }

  void _listenToCurrentMove() {
    _currentMoveSubscription = _database
        .child("lobbies/${currentLobby.lobbyId}/game/current_move")
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        currentLobby.game?.currentMove = event.snapshot.value as String;
      }
    });
  }

  void makeMove(String fen) {}

  void sendMoveToDB(String fen, String currentMove) {
    _dataBaseService.addMoveToDB(currentLobby, fen, currentMove);
  }

  /*  void createtGame() {
    final player1 = currentLobby.owner;
    final player2 = currentLobby.guest;
    player1.color = assignRandomColor();
    player2?.color = player1.color == PlayerColor.black
        ? PlayerColor.white
        : PlayerColor.black;

    final Map<String, User> players = {
      "player1": player1,
      "player2": player2!,
    };
    // print("guest: ${currentLobby.guest!}");
    final newGame = Game(players: players);
    newGame.isStarted = true;
    currentLobby.game = newGame;
  } */

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

  @override
  void dispose() {
    _lobbyStreamSubscription.cancel();
    _gameStartSubscription.cancel();
    _gameSubscription.cancel();
    _dataBaseService.deleteGuestFromLobby(
        currentLobby); // remove guest from lobby when he leaves the screen
    hasJoined = false;
    super.dispose();
  }
} */
