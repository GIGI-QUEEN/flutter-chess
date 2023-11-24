// ignore_for_file: avoid_print

import 'package:client/services/data_base_service.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:uuid/uuid.dart';

class User {
  final String username;
  String userUuid = const Uuid().v1();
  //PlayerColor? color;
  String? color;

  final DataBaseService _dataBaseService = DataBaseService();
  User({required this.username, this.color});

  Future<void> createUser() async {
    await _dataBaseService.addUserToDB(this);
  }

  factory User.fromRTBD(Map<String, dynamic> data) {
    User user = User(username: data['username'], color: data['color']);
    user.userUuid = data['uuid'];
    return user;
  }
}
