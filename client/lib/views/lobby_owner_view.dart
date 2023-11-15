import 'package:client/components/app_bar.dart';
import 'package:client/components/main_scaffold.dart';
import 'package:client/models/lobby.dart';
import 'package:client/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LobbyOwnerView extends StatelessWidget {
  final Lobby lobby;
  final User user;
  final bool hasJoined;
  const LobbyOwnerView(
      {super.key,
      required this.lobby,
      required this.user,
      required this.hasJoined});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      mainContainerWidh: double.infinity,
      appBar: CustomAppBar(title: '${user.username} (owner)'),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 40),
        child: Column(
          children: [
            ElevatedButton(
                onPressed: hasJoined ? () {} : null,
                child: const Text('start game'))
          ],
        ),
      ),
    );
  }
}
