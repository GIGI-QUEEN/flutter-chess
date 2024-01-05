// ignore_for_file: constant_identifier_names

import 'package:client/models/database_invite.dart';
import 'package:client/models/game.dart';
import 'package:client/models/lobby.dart';
import 'package:client/models/user.dart';
import 'package:firebase_database/firebase_database.dart';

class DataBaseService {
  final DatabaseReference database = FirebaseDatabase.instance.ref();

  static const USERS_PATH = 'users';
  static const LOBBIES_PATH = 'lobbies';
  static const GAMES_PATH = 'games';

  Future<void> addUserToDB(User user) async {
    final usersRef = database.child(USERS_PATH);
    try {
      await usersRef
          .child(user.userUuid)
          .set({"username": user.username, "uuid": user.userUuid});
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addLobbyToDB(Lobby lobby) async {
    final lobbiesRef = database.child(LOBBIES_PATH);
    try {
      lobbiesRef.child(lobby.lobbyId).set({
        'lobby_id': lobby.lobbyId,
        'is_private': lobby.isPrivate,
        'lobby_name': lobby.lobbyName,
        'owner': {
          "username": lobby.owner.username,
          "uuid": lobby.owner.userUuid,
        },
        'guest': {
          "username": null,
          "uuid": null,
        }
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateLobbyGuestInDB(Lobby lobby, User guest) async {
    final lobbiesRef = database.child(LOBBIES_PATH);
    try {
      await lobbiesRef.child("${lobby.lobbyId}/guest").update({
        'username': guest.username,
        'uuid': guest.userUuid,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteGuestFromLobby(Lobby lobby) async {
    final guestRef = database.child("$LOBBIES_PATH/${lobby.lobbyId}/guest");
    guestRef.update({
      'username': null,
      'uuid': null,
    });
  }

  Future<void> removeUserFromDB(User user) async {
    final usersRef = database.child(USERS_PATH);
    try {
      await usersRef.child(user.userUuid).remove();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<User>> getAllUsers() async {
    final usersRef = database.child(USERS_PATH);
    List<User> users = [];
    try {
      await usersRef.get().then((value) {
        final usersMap = Map<String, dynamic>.from(value.value as dynamic);
        for (var element in usersMap.entries) {
          final User user =
              User.fromRTBD(Map<String, dynamic>.from(element.value));
          users.add(user);
        }
      });
    } catch (e) {
      throw Exception(e);
    }
    return users;
  }

  Future<List<User>> findUsers(String username) async {
    final usersRef = database.child(USERS_PATH);
    List<User> foundUsers = [];

    try {
      final snapshot = await usersRef
          .orderByChild('username')
          .startAt(username.toLowerCase())
          .endAt("${username.toLowerCase()}\uf8ff")
          .get();

      if (username.length >= 2 && snapshot.value != null) {
        Map<dynamic, dynamic> users = snapshot.value as dynamic;
        users.forEach((key, userData) {
          final user = User.fromRTBD(Map<String, dynamic>.from(userData));
          foundUsers.add(user);
        });
      } else {
        foundUsers = [];
      }
    } catch (e) {
      throw Exception(e);
    }

    return foundUsers;
  }

  Future<void> addInviteToDB(
      User invitedUser, User owner, Lobby lobby, DatabaseInvite invite) async {
    final usersRef = database.child(USERS_PATH);

    try {
      await usersRef
          .child("${invitedUser.userUuid}/invites/${invite.inviteId}")
          .set({
        "lobby_name": lobby.lobbyName,
        "lobby_id": lobby.lobbyId,
        "lobby_owner_name": owner.username,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> removeInviteFromDB(User currentUser, Lobby lobby) async {
    final usersRef = database.child(USERS_PATH);
    try {
      final data = await usersRef
          .child("${currentUser.userUuid}/invites/")
          .orderByChild('lobby_id')
          .equalTo(lobby.lobbyId)
          .get();
      Map<dynamic, dynamic> inviteQueryData = data.value as dynamic;
      final inviteId = inviteQueryData.keys.first;
      await usersRef
          .child("${currentUser.userUuid}/invites/$inviteId")
          .remove();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addGameToDB(Lobby lobby, Game game) async {
    final gamesRef = database.child(LOBBIES_PATH);
    // game.players.
    final player1 = game.players['player1'];
    final player2 = game.players['player2'];

    try {
      await gamesRef.child('${lobby.lobbyId}/game').set({
        "status": 'in_progress',
        "board_state": {
          "fen": "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
          "current_move": 'white',
        },
        "players": {
          "player1": {
            "username": player1?.username,
            "uuid": player1?.userUuid,
            "color": player1?.color == 'white' ? 'white' : 'black',
          },
          "player2": {
            "username": player2?.username,
            "uuid": player2?.userUuid,
            "color": player2?.color == 'white' ? 'white' : 'black',
          }
        },
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addMoveToDB(Lobby lobby, String fen, String currentMove) async {
    /* final lobbiesRef =  */
    try {
      await database
          .child('$LOBBIES_PATH/${lobby.lobbyId}/game/board_state')
          .update({
        "fen": fen,
        "current_move": currentMove,
      });

      /*  await database.child("$LOBBIES_PATH/${lobby.lobbyId}/game/").update({
        "current_move": currentMove,
      }); */
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> removeLobbyFromDB(Lobby lobby) async {
    try {
      await database.child("$LOBBIES_PATH/${lobby.lobbyId}").remove();
    } catch (e) {
      throw Exception(e);
    }
  }
}
