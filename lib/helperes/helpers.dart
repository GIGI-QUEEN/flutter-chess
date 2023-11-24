import 'dart:math';

import 'package:client/models/lobby.dart';
import 'package:client/models/user.dart';

bool isUserOwner(Lobby lobby, User user) {
  return lobby.owner.userUuid == user.userUuid;
}

Lobby pickLobby(List<Lobby> lobbies, String neededLobbyId) {
  return lobbies.where((lobby) => lobby.lobbyId == neededLobbyId).toList()[0];
}

String assignRandomColor() {
  final random = Random();
  return random.nextBool() ? "black" : "white";
}
