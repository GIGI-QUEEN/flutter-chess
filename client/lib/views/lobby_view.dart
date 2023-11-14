import 'package:client/components/app_bar.dart';
import 'package:client/models/lobby_provider.dart';
import 'package:client/models/user_provider.dart';
import 'package:client/services/data_base_service.dart';
import 'package:client/values/main_gradient_bg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LobbyView extends StatelessWidget {
  const LobbyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, LobbyProvider>(
      builder: (context, userModel, lobbyModel, child) {
        DataBaseService _dataBaseService = DataBaseService();

        print('lobby ${lobbyModel.currentLobby!.lobbyName}');
        final bool isOwner =
            lobbyModel.currentLobby!.owner.userUuid == userModel.user!.userUuid
                ? true
                : false;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: CustomAppBar(title: lobbyModel.currentLobby!.lobbyName),
          body: Container(
            width: double.infinity,
            decoration: mainContainerDecoration,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 40),
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        print('id: ${lobbyModel.currentLobby!.lobbyId}');
                        try {
                          _dataBaseService.updateLobbyGuestInDB(
                              lobbyModel.currentLobby!, userModel.user!);
                        } catch (e) {
                          throw Exception(e);
                        }
                      },
                      child: const Text('join'))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
