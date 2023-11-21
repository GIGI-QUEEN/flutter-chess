// ignore_for_file: constant_identifier_names

import 'package:client/models/database_invite.dart';
import 'package:client/models/lobby.dart';
import 'package:client/models/user.dart';
import 'package:firebase_database/firebase_database.dart';

class DataBaseService {
  final DatabaseReference database = FirebaseDatabase.instance.ref();

  static const USERS_PATH = 'users';
  static const LOBBIES_PATH = 'lobbies';

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
}
