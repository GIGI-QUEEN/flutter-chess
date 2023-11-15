import 'dart:async';

import 'package:client/models/lobby.dart';
import 'package:client/services/data_base_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LobbyProvider extends ChangeNotifier {
  Lobby currentLobby;
  bool hasJoined = false;
  // Lobby? get currentLobby => _currentLobby;

  final DataBaseService _dataBaseService = DataBaseService();
  final _database = FirebaseDatabase.instance.ref();

  late StreamSubscription _lobbyStreamSubscription;

/*   void setLobby(Lobby lobby) {
    _currentLobby = lobby;
    notifyListeners();
  } */

  LobbyProvider({required this.currentLobby}) {
    _listenToLobbyChanges();
  }

  void _listenToLobbyChanges() async {
    //checking if somebody connects and disconnects from lobby
    _lobbyStreamSubscription = _database
        .child('lobbies/${currentLobby.lobbyId}/guest')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        hasJoined = true;
        notifyListeners();
      } else {
        hasJoined = false;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _lobbyStreamSubscription.cancel();
    _dataBaseService.deleteGuestFromLobby(
        currentLobby); // remove guest from lobby when he leaves the screen
    hasJoined = false;
    super.dispose();
  }
}
