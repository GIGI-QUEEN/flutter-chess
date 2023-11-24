import 'package:client/components/app_bar.dart';
import 'package:client/components/lobby_players.dart';
import 'package:client/components/main_scaffold.dart';
import 'package:client/providers/lobby_provider.dart';
import 'package:client/providers/user_provider.dart';
import 'package:client/services/data_base_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LobbyGuestView extends StatelessWidget {
  LobbyGuestView({super.key});
  final DataBaseService dataBaseService = DataBaseService();

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, LobbyProvider>(
      builder: (context, userModel, lobbyModel, child) {
        final lobby = lobbyModel.currentLobby;
        final me = userModel.user;
        final hasGuest = lobby.guest != null;
        final isGuestMe = lobby.guest?.userUuid == me?.userUuid;
        return MainScaffold(
          mainContainerWidh: double.infinity,
          appBar: CustomAppBar(
            title: lobby.lobbyName,
            automaticallyImplyLeading: !isGuestMe,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 40),
            child: Column(
              children: [
                LobbyPlayers(
                  owner: lobby.owner,
                  guest: lobby.guest,
                ),
                //this button contains different checks for different lobby viewer perspective
                ElevatedButton(
                    onPressed: hasGuest
                        ? isGuestMe
                            ? () {
                                lobbyModel.unjoin();
                              }
                            : null
                        : () {
                            lobbyModel.updateLobbyGuest(userModel.user!);
                          },
                    child: hasGuest
                        ? isGuestMe
                            ? const Text('leave')
                            : const Text('join')
                        : const Text('join'))
              ],
            ),
          ),
        );
      },
    );
  }
}
