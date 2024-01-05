// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:ui';

import 'package:client/components/app_bar.dart';
import 'package:client/components/main_scaffold.dart';
import 'package:client/models/user.dart';
import 'package:client/providers/lobby_provider.dart';
import 'package:client/providers/user_provider.dart';
import 'package:client/views/main_menu_view.dart';
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

        final myColor = me?.color;

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
                      isGameOver: lobbyModel.isGameOver,
                      winner: lobbyModel.winner,
                      gameEndReason: lobbyModel.gameEndReason,
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
  const GameResultPanel({
    super.key,
    required this.isCheckmate,
    required this.isGameOver,
    this.winner,
    required this.gameEndReason,
  });
  final bool isCheckmate;
  final bool isGameOver;
  final User? winner;
  final String gameEndReason;

  @override
  Widget build(BuildContext context) {
    log('reason: $gameEndReason');
    return Visibility(
        visible: isGameOver,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 2,
            sigmaY: 2,
          ),
          child: Container(
            width: 300,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black87,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  gameEndReason,
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Winner: ${winner?.username}',
                  style: const TextStyle(color: Colors.white),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainMenuView()));
                    },
                    child: const Text('main menu'))
              ],
            ),
          ),
        ));
  }
}
