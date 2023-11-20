import 'package:client/components/app_bar.dart';
import 'package:client/components/custom_text_field.dart';
import 'package:client/components/main_scaffold.dart';
import 'package:client/models/lobby.dart';
import 'package:client/models/user.dart';
import 'package:client/services/data_base_service.dart';
import 'package:flutter/material.dart';

class LobbyOwnerView extends StatefulWidget {
  final Lobby lobby;
  final User user;
  final bool hasJoined;
  const LobbyOwnerView(
      {super.key,
      required this.lobby,
      required this.user,
      required this.hasJoined});

  @override
  State<LobbyOwnerView> createState() => _LobbyOwnerViewState();
}

class _LobbyOwnerViewState extends State<LobbyOwnerView> {
  List<User> users = [];
  @override
  Widget build(BuildContext context) {
    final DataBaseService _dataBaseService = DataBaseService();

    void completeSearch(String text) async {
      final foundUsers = await _dataBaseService.findUsers(text);
      setState(() {
        users = foundUsers;
      });
    }

    return MainScaffold(
      mainContainerWidh: double.infinity,
      appBar: CustomAppBar(title: '${widget.user.username} (owner)'),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 40),
        child: Column(
          children: [
            ElevatedButton(
                onPressed: widget.hasJoined ? () {} : null,
                child: const Text('start game')),
            CustomTextField(
                onChanged: (text) {
                  completeSearch(text);
                },
                hintText: 'Find user to invite'),
            Expanded(
                child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(users[index].username),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: Text('invite'),
                  ),
                  /*   onTap: () {
                    print(users[index].userUuid);
                  }, */
                );
              },
            ))
            /*   Expanded(
                child: ListView(
              children: [
                //found users should display here
              ],
            )) */
          ],
        ),
      ),
    );
  }
}
