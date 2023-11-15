// ignore_for_file: avoid_print

import 'package:client/services/data_base_service.dart';
import 'package:uuid/uuid.dart';

class User {
  final String username;
  String userUuid = const Uuid().v1();
  // String? userKey;

  final DataBaseService _dataBaseService = DataBaseService();
  User({required this.username});

  Future<void> createUser() async {
    await _dataBaseService.addUserToDB(this);
  }

  factory User.fromRTBD(Map<String, dynamic> data) {
    User user = User(username: data['username']);
    user.userUuid = data['uuid'];
    return user;
  }
}
