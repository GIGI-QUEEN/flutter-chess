// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:client/models/lobby.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LobbiesProvider extends ChangeNotifier {
  List<Lobby> _lobbies = [];
  final _db = FirebaseDatabase.instance.ref();

  static const LOBBIES_PATH = 'lobbies';

  late StreamSubscription _lobbiesStream;

  List<Lobby> get lobbies => _lobbies;

  LobbiesProvider() {
    //print("LOBBIES INIT");
    _listenToLobbies();
  }

  void _listenToLobbies() {
    _lobbiesStream = _db.child(LOBBIES_PATH).onValue.listen((event) {
      if (event.snapshot.value != null) {
        final allLobbies =
            Map<String, dynamic>.from(event.snapshot.value as dynamic);

        _lobbies = allLobbies.values
            .map((lobbyAsJSON) => Lobby.fromRTDB(Map<String, dynamic>.from(
                Map<String, dynamic>.from(lobbyAsJSON))))
            .toList();
        notifyListeners();
      } else {
        _lobbies = [];
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _lobbiesStream.cancel();
    super.dispose();
  }
}
