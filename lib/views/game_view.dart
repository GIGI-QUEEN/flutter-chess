// ignore_for_file: avoid_print

import 'package:client/components/app_bar.dart';
import 'package:client/components/main_scaffold.dart';
import 'package:client/providers/lobby_provider.dart';
import 'package:client/providers/user_provider.dart';
import 'package:client/values/main_gradient_bg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_chess_board/simple_chess_board.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, LobbyProvider>(
      builder: (context, userModel, lobbyModel, child) {
        final me = lobbyModel.currentLobby.game?.players.values
            .firstWhere((user) => user.userUuid == userModel.user?.userUuid);
        final opponent = lobbyModel.currentLobby.game?.players.values
            .firstWhere((user) => user.userUuid != userModel.user?.userUuid);

        final myColor = me?.color;

        final currentTurn = lobbyModel.currentLobby.game?.players.values
            .firstWhere((user) =>
                user.color == lobbyModel.chess.turn.name.toLowerCase())
            .username;
        return MainScaffold(
          appBar: CustomAppBar(title: 'chess game'),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(lobbyModel.getCurrentTurn(me!)),
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    SimpleChessBoard(
                      fen: lobbyModel.fen,
                      orientation: myColor == 'white'
                          ? BoardColor.white
                          : BoardColor.black,
                      whitePlayerType: myColor == 'white'
                          ? PlayerType.human
                          : PlayerType.computer,
                      blackPlayerType: myColor == 'black'
                          ? PlayerType.human
                          : PlayerType.computer,
                      showCoordinatesZone: false,
                      onMove: lobbyModel.tryMakingMove,
                      onPromote: () async {},
                    ),
                    GameResultPanel(
                      isCheckmate: lobbyModel.isCheckmate,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class GameResultPanel extends StatelessWidget {
  const GameResultPanel({super.key, required this.isCheckmate});
  final bool isCheckmate;
  //TODO:
  //1: show winner
  //2: add quit button
  //3: delete lobby after quit button is hit

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: isCheckmate,
        child: Container(
          width: 300,
          height: 300,
          color: Colors.red,
        ));
  }
}

/* class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, LobbyProvider>(
      builder: (context, userModel, lobbyModel, child) {
        final me = lobbyModel.currentLobby.game?.players.values
            .firstWhere((user) => user.userUuid == userModel.user?.userUuid);

        final myColor = me?.color;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Chess game'),
            elevation: 0,
            backgroundColor: const Color.fromRGBO(84, 74, 125, 1),
          ),
          body: Container(
            decoration: mainContainerDecoration,
            child: Center(
              child: SimpleChessBoard(
                fen: lobbyModel.fen,
                orientation:
                    myColor == 'white' ? BoardColor.white : BoardColor.black,
                whitePlayerType:
                    myColor == 'white' ? PlayerType.human : PlayerType.computer,
                blackPlayerType:
                    myColor == 'black' ? PlayerType.human : PlayerType.computer,
                showCoordinatesZone: false,
                onMove: lobbyModel.tryMakingMove,
                onPromote: () async {},
              ),
            ),
          ),
        );
      },
    );
  }
} */

