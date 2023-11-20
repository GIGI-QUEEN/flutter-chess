import 'package:client/helperes/helpers.dart';
import 'package:client/models/lobby_provider.dart';
import 'package:client/models/user_provider.dart';
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

        return isOwner
            ? LobbyOwnerView(
                lobby: lobbyModel.currentLobby,
                user: userModel.user!,
                hasJoined: lobbyModel.hasJoined,
              )
            : LobbyGuestView(
                currentLobby: lobbyModel.currentLobby,
                user: userModel.user!,
              );
      },
    );
  }
}
