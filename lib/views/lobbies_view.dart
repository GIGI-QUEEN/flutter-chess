import 'package:client/components/app_bar.dart';
import 'package:client/components/lobby_card.dart';
import 'package:client/providers/lobbies_provider.dart';
import 'package:client/providers/user_provider.dart';
import 'package:client/values/main_gradient_bg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LobbiesView extends StatelessWidget {
  const LobbiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, LobbiesProvider>(
      builder: (context, userModel, lobbiesModel, child) {
        final list =
            lobbiesModel.lobbies.where((lobby) => lobby.game?.status == null);

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: CustomAppBar(title: userModel.user!.username),
          body: Container(
            decoration: mainContainerDecoration,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: lobbiesModel.lobbies.isNotEmpty
                          ? ListView(
                              padding: const EdgeInsets.all(0),
                              children: [
                                ...list.map((lobby) {
                                  final isInvited =
                                      userModel.isUserInvitedToLobby(lobby);
                                  return LobbyCard(
                                      lobby: lobby,
                                      isInvited: isInvited,
                                      user: userModel.user!);
                                })
                              ],
                            )
                          : const Center(
                              child: Text('No active lobbies'),
                            ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
