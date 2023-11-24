import 'package:client/models/game.dart';
import 'package:client/models/user.dart';
import 'package:client/services/data_base_service.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:uuid/uuid.dart';

class Lobby {
  final User owner;
  final bool isPrivate;
  final String lobbyName;
  String lobbyId = '';
  User? guest;
  Game? game;
  final DataBaseService _dataBaseService = DataBaseService();

  Lobby({
    required this.owner,
    required this.isPrivate,
    required this.lobbyName,
    this.guest,
    required this.lobbyId,
  });

  Future<void> initializeLobby() async {
    lobbyId = const Uuid().v1();
    await _dataBaseService.addLobbyToDB(this);
  }

  Future<void> initializeGame(Game game) async {
    await _dataBaseService.addGameToDB(this, game);
  }

  factory Lobby.fromRTDB(Map<String, dynamic> data) {
    User user = User(username: data['owner']['username'], color: 'white');
    user.userUuid = data['owner']['uuid'];
    return Lobby(
      owner: user,
      isPrivate: data['is_private'],
      lobbyName: data['lobby_name'],
      lobbyId: data['lobby_id'],
    );
  }
}
