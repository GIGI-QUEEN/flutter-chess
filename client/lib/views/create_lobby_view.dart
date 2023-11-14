import 'package:client/components/app_bar.dart';
import 'package:client/components/custom_text_field.dart';
import 'package:client/models/lobby.dart';
import 'package:client/models/lobby_provider.dart';
import 'package:client/models/user_provider.dart';
import 'package:client/values/main_gradient_bg.dart';
import 'package:client/views/lobby_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateLobbyView extends StatefulWidget {
  const CreateLobbyView({super.key});

  @override
  State<CreateLobbyView> createState() => _CreateLobbyViewState();
}

class _CreateLobbyViewState extends State<CreateLobbyView> {
  final TextEditingController _textEditingController = TextEditingController();
  bool isPrivate = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(title: 'Create lobby'),
      body: Container(
        decoration: mainContainerDecoration,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Consumer2<UserProvider, LobbyProvider>(
              builder: (context, userModel, lobbyModel, child) {
                final lock = isPrivate
                    ? const Icon(Icons.lock)
                    : const Icon(Icons.lock_open);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextField(
                      textEditingController: _textEditingController,
                      hintText: 'Enter lobby name',
                      suffixIcon: lock,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Switch(
                        value: isPrivate,
                        onChanged: (bool value) {
                          setState(() {
                            isPrivate = value;
                          });
                        }),
                    const SizedBox(
                      height: 30,
                    ),
                    //ToggleButtons(children: children, isSelected: isSelected),
                    ElevatedButton(
                        onPressed: () async {
                          final Lobby lobby = Lobby(
                              owner: userModel.user!,
                              isPrivate: isPrivate,
                              lobbyName: _textEditingController.text);
                          await lobby.initializeLobby();
                          lobbyModel.setLobby(lobby);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LobbyView(),
                              ));
                        },
                        child: const Text('Create lobby')),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
