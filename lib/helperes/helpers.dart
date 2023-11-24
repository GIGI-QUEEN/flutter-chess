import 'dart:math';

import 'package:client/models/lobby.dart';
import 'package:client/models/user.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

bool isUserOwner(Lobby lobby, User user) {
  return lobby.owner.userUuid == user.userUuid;
}

Lobby pickLobby(List<Lobby> lobbies, String neededLobbyId) {
  return lobbies.where((lobby) => lobby.lobbyId == neededLobbyId).toList()[0];
}

/* PlayerColor assignRandomColor() {
  final random = Random();
  return random.nextBool() ? PlayerColor.black : PlayerColor.white;
} */

String assignRandomColor() {
  final random = Random();
  return random.nextBool() ? "black" : "white";
}

/* void assignColors(User player1, User player2) {
  List<String> colors = ['black', 'white'];
  colors.
} */