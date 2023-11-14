import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PlayRoom extends StatefulWidget {
  const PlayRoom({super.key, this.id});
  final String? id;
  @override
  State<PlayRoom> createState() => _PlayRoomState();
}

class _PlayRoomState extends State<PlayRoom> {
  @override
  Widget build(BuildContext context) {
    String? roomId = widget.id;
    final channel = WebSocketChannel.connect(
        Uri.parse("ws://172.1.1.107:8080/rooms/$roomId"));
    return StreamBuilder(
      stream: channel.stream,
      builder: (context, snapshot) {
        print(snapshot.data);
        return Scaffold(
          appBar: AppBar(
            title: Text(
                snapshot.hasData ? 'Color: ${snapshot.data}' : 'Color: TBA'),
          ),
        );
      },
    );
  }
}
