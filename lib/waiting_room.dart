import 'package:client/play_room.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WaitingRoom extends StatefulWidget {
  const WaitingRoom({super.key});

  @override
  State<WaitingRoom> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom> {
  final channel =
      WebSocketChannel.connect(Uri.parse("ws://172.1.1.107:8080/rooms"));
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: channel.stream,
        builder: (context, snapshot) {
          print(snapshot.data);
          return Scaffold(
            appBar: AppBar(title: Text('waiting room')),
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PlayRoom(
                            id: snapshot.data,
                          )));
                },
                child: Text(snapshot.hasData
                    ? '${snapshot.data}'
                    : 'waiting for opponent'),
              ),
            ),
          );
        });
  }
}
