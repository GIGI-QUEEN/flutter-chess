import 'package:client/models/lobby.dart';
import 'package:flutter/material.dart';

class LobbyProvider extends ChangeNotifier {
  Lobby? _currentLobby;

  Lobby? get currentLobby => _currentLobby;

  void setLobby(Lobby lobby) {
    _currentLobby = lobby;
    notifyListeners();
  }
}
