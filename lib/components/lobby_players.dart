import 'package:client/models/user.dart';
import 'package:flutter/material.dart';

class LobbyPlayers extends StatelessWidget {
  final User? guest;
  final User owner;
  const LobbyPlayers({super.key, required this.owner, this.guest});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: Column(
        children: [
          Card(
            child: ListTile(
              title: Text("${owner.username} (owner)"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Card(
            child: ListTile(
              title: guest != null
                  ? Text("${guest?.username} (guest)")
                  : Text(
                      "TBA",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
