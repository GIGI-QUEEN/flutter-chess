import 'dart:async';

import 'package:client/models/database_invite.dart';
import 'package:flutter/material.dart';

class InvitesProvider extends ChangeNotifier {
  List<DatabaseInvite> _invites = [];

  late StreamSubscription _invitesSubscription;

  InvitesProvider() {}

  void _listenToInvites() {}
}
