import 'package:client/models/user.dart';

class Game {
  Map<String, User> players;
  String status;
  String currentMove;

  Game(
      {required this.players, required this.status, required this.currentMove});

  factory Game.fromRTDB(Map<String, dynamic> data) {
    Map<String, User> players = {};

    data['players'].forEach((key, value) {
      print("key $key, value: ${value['color']}");
      players[key] = User.fromRTBD({
        'username': value['username'],
        'color': value['color'],
        'uuid': value['uuid'],
      });
    });

    return Game(
        players: players,
        status: data['status'],
        currentMove: data['board_state']['current_move']);
  }
}
