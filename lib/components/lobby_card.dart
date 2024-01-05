import 'package:client/models/lobby.dart';
import 'package:client/models/user.dart';
import 'package:client/providers/lobby_provider.dart';
import 'package:client/views/lobby_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LobbyCard extends StatelessWidget {
  const LobbyCard({
    super.key,
    required this.lobby,
    required this.isInvited,
    required this.user,
  });
  final Lobby lobby;
  final bool isInvited;
  final User user;
  @override
  Widget build(BuildContext context) {
    final lock =
        lobby.isPrivate ? const Icon(Icons.lock) : const Icon(Icons.lock_open);
    return Card(
      child: ListTile(
        onTap: () {
          if (lobby.isPrivate && isInvited ||
              lobby.owner.userUuid == user.userUuid) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider<LobbyProvider>(
                    create: (_) => LobbyProvider(currentLobby: lobby),
                    child: const LobbyView(),
                  ),
                ));
          }

          if (!lobby.isPrivate) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider<LobbyProvider>(
                    create: (_) => LobbyProvider(currentLobby: lobby),
                    child: const LobbyView(),
                  ),
                ));
          }
        },
        leading: lock,
        title: Text(lobby.lobbyName),
        subtitle: Text(lobby.owner.username),
      ),
    );
  }
}
