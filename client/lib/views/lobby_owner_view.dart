import 'package:client/components/app_bar.dart';
import 'package:client/components/custom_text_field.dart';
import 'package:client/components/main_scaffold.dart';
import 'package:client/models/lobby_provider.dart';
import 'package:client/models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LobbyOwnerView extends StatelessWidget {
  const LobbyOwnerView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, LobbyProvider>(
      builder: (context, userModel, lobbyModel, child) {
        return MainScaffold(
          mainContainerWidh: double.infinity,
          appBar: CustomAppBar(title: '${userModel.user!.username} (owner)'),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 40),
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: lobbyModel.hasJoined ? () {} : null,
                    child: const Text('start game')),
                CustomTextField(
                    onChanged: (text) {
                      lobbyModel.completeSearch(text);
                    },
                    hintText: 'Find user to invite'),
                Expanded(
                    child: ListView.builder(
                  itemCount: lobbyModel.availableUsers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(lobbyModel.availableUsers[index].username),
                      trailing: ElevatedButton(
                        onPressed: () {},
                        child: const Text('invite'),
                      ),
                    );
                  },
                ))
              ],
            ),
          ),
        );
      },
    );
  }
}
