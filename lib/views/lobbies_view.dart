import 'package:client/components/app_bar.dart';
import 'package:client/providers/lobbies_provider.dart';
import 'package:client/providers/lobby_provider.dart';
import 'package:client/providers/user_provider.dart';
import 'package:client/values/main_gradient_bg.dart';
import 'package:client/views/lobby_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LobbiesView extends StatelessWidget {
  const LobbiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, LobbiesProvider>(
      builder: (context, userModel, lobbiesModel, child) {
        /*     lobbiesModel.lobbies
            .forEach((lobby) => {print('ID: ${lobby.lobbyId}')}); */
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
                                ...lobbiesModel.lobbies.map((lobby) {
                                  final lock = lobby.isPrivate
                                      ? const Icon(Icons.lock)
                                      : const Icon(Icons.lock_open);
                                  return Card(
                                    child: ListTile(
                                      onTap: () {
                                        // lobbyModel.setLobby(lobby);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChangeNotifierProvider<
                                                      LobbyProvider>(
                                                create: (_) => LobbyProvider(
                                                    currentLobby: lobby),
                                                child: const LobbyView(),
                                              ),
                                            ));
                                      },
                                      leading: lock,
                                      title: Text(lobby.lobbyName),
                                      subtitle: Text(lobby.owner.username),
                                    ),
                                  );
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
