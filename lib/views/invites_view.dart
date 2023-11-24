import 'package:client/components/app_bar.dart';
import 'package:client/components/main_scaffold.dart';
import 'package:client/helperes/helpers.dart';
import 'package:client/providers/lobbies_provider.dart';
import 'package:client/providers/lobby_provider.dart';
import 'package:client/providers/user_provider.dart';
import 'package:client/views/lobby_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvitesView extends StatelessWidget {
  const InvitesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, LobbiesProvider>(
      builder: (context, userModel, lobbiesModel, child) {
        return MainScaffold(
          mainContainerWidh: double.infinity,
          appBar: CustomAppBar(title: 'Invites'),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 50),
            child: Column(
              children: [
                Expanded(
                    child: userModel.invites.isNotEmpty
                        ? ListView.builder(
                            itemCount: userModel.invites.length,
                            itemBuilder: (context, index) => Card(
                                  child: ListTile(
                                    leading: const Icon(Icons.mail),
                                    title: Text(userModel
                                        .invites[index].lobbyIOwnerName),
                                    subtitle: Text(
                                        "invites you to ${userModel.invites[index].lobbyName}"),
                                    onTap: () {
                                      final lobby = pickLobby(
                                          lobbiesModel.lobbies,
                                          userModel.invites[index].lobbyId);
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
                                  ),
                                ))
                        : const Center(
                            child: Text('No ivites yet :('),
                          ))
              ],
            ),
          ),
        );
      },
    );
  }
}
