import 'package:client/helperes/helpers.dart';
import 'package:client/providers/lobby_provider.dart';
import 'package:client/providers/user_provider.dart';
import 'package:client/views/game_view.dart';
import 'package:client/views/lobby_guest_view.dart';
import 'package:client/views/lobby_owner_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LobbyView extends StatelessWidget {
  const LobbyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, LobbyProvider>(
      builder: (context, userModel, lobbyModel, child) {
        final isOwner = isUserOwner(lobbyModel.currentLobby, userModel.user!);

        final isStarted = lobbyModel.currentLobby.game?.status == "in_progress"
            ? true
            : false;

        return isStarted
            ? const GameView()
            : isOwner
                ? const LobbyOwnerView()
                : LobbyGuestView();
      },
    );
  }
}
