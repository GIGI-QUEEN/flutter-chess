import 'package:client/components/app_bar.dart';
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
        return MainScaffold(
          mainContainerWidh: double.infinity,
          appBar: CustomAppBar(title: '${userModel.user!.username} (guest)'),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 40),
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      lobbyModel.updateLobbyGuest(userModel.user!);
                    },
                    child: const Text('join'))
              ],
            ),
          ),
        );
      },
    );
  }
}
