// ignore_for_file: avoid_print

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
    //ChessBoardController controller = ChessBoardController();

    return Consumer2<UserProvider, LobbyProvider>(
      builder: (context, userModel, lobbyModel, child) {
        final myColor = userModel.user?.color == "white" ? 'white' : 'black';

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
}

/* class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    ChessBoardController controller = ChessBoardController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess game'),
        elevation: 0,
        backgroundColor: const Color.fromRGBO(84, 74, 125, 1),
      ),
      body: Container(
        decoration: mainContainerDecoration,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
          child: Column(
            children: [
              Center(
                child: ChessBoard(
                  controller: controller,
                  boardColor: BoardColor.darkBrown,

                  /*   enableUserMoves: currentMove == myColor, */
                  boardOrientation: PlayerColor.white,
                  onMove: () {},
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    controller.makeMove(from: "e2", to: "e4");
                  },
                  child: const Text('move')),
              ElevatedButton(
                  onPressed: () {
                    controller.undoMove();
                  },
                  child: const Text('undo'))
            ],
          ),
        ),
      ),
    );
  }
} */

/* class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    //ChessBoardController controller = ChessBoardController();

    return Consumer2<UserProvider, LobbyProvider>(
      builder: (context, userModel, lobbyModel, child) {
        final myColor =
            userModel.user?.color == PlayerColor.white ? 'white' : 'black';
        final currentMove = lobbyModel.currentLobby.game?.currentMove == 'white'
            ? 'black'
            : 'white';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Chess game'),
            elevation: 0,
            backgroundColor: const Color.fromRGBO(84, 74, 125, 1),
          ),
          body: Container(
            decoration: mainContainerDecoration,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
              child: Column(
                children: [
                  Center(
                    child: ChessBoard(
                      controller: lobbyModel.controller,
                      boardColor: BoardColor.darkBrown,

                      /*   enableUserMoves: currentMove == myColor, */
                      boardOrientation:
                          userModel.user?.color == PlayerColor.white
                              ? PlayerColor.white
                              : PlayerColor.black,
                      onMove: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
 */