import 'dart:async';

import 'package:client/models/invite.dart';
import 'package:client/models/lobby.dart';
import 'package:client/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  List<Invite> _invites = [];

  User? get user => _user;
  List<Invite> get invites => _invites;

  late StreamSubscription _invitesSubscription;

  //final DataBaseService _dataBaseService = DataBaseService();
  final _database = FirebaseDatabase.instance.ref();

  void setUser(User user) {
    _user = user;
    _listenToInvites();

    notifyListeners();
  }

  UserProvider() {
    //  _listenToInvites();
  }

  void _listenToInvites() async {
    //listening to invites for current user
    _invitesSubscription = _database
        .child("users/${user?.userUuid}/invites")
        .onValue
        .listen((event) {
      //print("EVENT: ${event.snapshot.value}");
      if (event.snapshot.value != null) {
        final allInvites =
            Map<String, dynamic>.from(event.snapshot.value as dynamic);
        _invites = allInvites.values
            .map((inviteAsJSON) => Invite.fromRTBD(Map<String, dynamic>.from(
                Map<String, dynamic>.from(inviteAsJSON))))
            .toList();
        notifyListeners();
      } else {
        _invites = [];
        notifyListeners();
      }
      // notifyListeners();
    });
  }

  bool isUserInvitedToLobby(Lobby lobby) {
    bool isInvited = false;
    for (final invite in invites) {
      if (invite.lobbyId == lobby.lobbyId) {
        isInvited = true;
      }
    }
    return isInvited;
  }

  @override
  void dispose() {
    _invitesSubscription.cancel();
    super.dispose();
  }
}
