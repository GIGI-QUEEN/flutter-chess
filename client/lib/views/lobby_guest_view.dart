import 'package:client/components/app_bar.dart';
import 'package:client/components/main_scaffold.dart';
import 'package:client/models/lobby.dart';
import 'package:client/models/user.dart';
import 'package:client/services/data_base_service.dart';
import 'package:flutter/material.dart';

class LobbyGuestView extends StatelessWidget {
  final Lobby currentLobby;
  final User user;
  LobbyGuestView({super.key, required this.currentLobby, required this.user});
  final DataBaseService dataBaseService = DataBaseService();

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      mainContainerWidh: double.infinity,
      appBar: CustomAppBar(title: '${user.username} (guest)'),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 40),
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  try {
                    dataBaseService.updateLobbyGuestInDB(currentLobby, user);
                  } catch (e) {
                    throw Exception(e);
                  }
                },
                child: const Text('join'))
          ],
        ),
      ),
    );
  }
}
