// ignore_for_file: constant_identifier_names

import 'package:client/models/lobby.dart';
import 'package:client/models/user.dart';
import 'package:firebase_database/firebase_database.dart';

class DataBaseService {
  final DatabaseReference database = FirebaseDatabase.instance.ref();

  static const USERS_PATH = 'users';
  static const LOBBIES_PATH = 'lobbies';

/*   Future<void> addUserToDB(User user) async {
    final usersRef = database.child(USERS_PATH);
    try {
      await usersRef
          .push()
          .set({"username": user.username, "uuid": user.userUuid});
    } catch (e) {
      //print("ERROR IN addUser $e");
      throw Exception(e);
    }
  } */

  Future<String?> addUserToDB(User user) async {
    final usersRef = database.child(USERS_PATH);
    try {
      final newRef = usersRef.push();
      final userKey = newRef.key;
      await newRef.set({"username": user.username, "uuid": user.userUuid});
      return userKey; // Return the generated key
    } catch (e) {
      // Handle the error or throw an exception if needed
      throw Exception(e);
    }
  }

  Future<void> addLobbyToDB(Lobby lobby) async {
    final lobbiesRef = database.child(LOBBIES_PATH);
    print("IDDD: ${lobby.lobbyId}");
    try {
      await lobbiesRef.push().set({
        'lobby_id': lobby.lobbyId,
        'is_private': lobby.isPrivate,
        'lobby_name': lobby.lobbyName,
        'owner': {
          "username": lobby.owner.username,
          "uuid": lobby.owner.userUuid,
        },
        'guest': {
          "username": lobby.guest?.username ?? '',
          "uuid": lobby.guest?.userUuid ?? '',
        }
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateLobbyGuestInDB(Lobby lobby, User guest) async {
    final lobbiesRef = database.child(LOBBIES_PATH);
    Query query = lobbiesRef.orderByChild('lobby_id').equalTo(lobby.lobbyId);

    query.get().then((snapshot) {
      if (snapshot.value != null) {
        print("snapshot: ${snapshot.value}");
      }
    });
  }

  Future<void> removeUserFromDB(User user) async {
    final usersRef = database.child(USERS_PATH);
    try {
      await usersRef.child(user.userKey!).remove();
    } catch (e) {
      throw Exception(e);
    }
  }
}
