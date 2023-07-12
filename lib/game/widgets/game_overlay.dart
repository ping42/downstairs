import 'dart:io' show Platform;

import 'package:downstairs/game/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameOverlay extends StatefulWidget {
  const GameOverlay(this.game, {super.key});

  final Game game;

  @override
  State<GameOverlay> createState() => GameOverlayState();
}

class GameOverlayState extends State<GameOverlay> {
  final bool isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  bool isPaused = false;

  @override
  Widget build(BuildContext context) {
    final game = widget.game as Downstairs;
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            top: 10,
            right: 10,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      onPressed: game.resetGame,
                    ),
                    BlocBuilder<AudioCubit, AudioState>(
                      builder: (context, state) {
                        return IconButton(
                          icon: Icon(
                            state.volume == 0
                                ? Icons.volume_off
                                : Icons.volume_up,
                            color: Colors.white,
                          ),
                          onPressed: () =>
                              context.read<AudioCubit>().toggleVolume(),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        isPaused ? Icons.play_arrow : Icons.pause,
                        color: Colors.white,
                      ),
                      onPressed: togglePause,
                    ),
                  ],
                ),
                ScoreDisplay(widget.game),
              ],
            ),
          ),
          // if (isMobile)
          //   Positioned(
          //     bottom: MediaQuery.of(context).size.height / 4,
          //     child: SizedBox(
          //       width: MediaQuery.of(context).size.width,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.only(left: 24),
          //             child: GestureDetector(
          //               onTapDown: (details) {
          //                 // game.player.moveLeft();
          //               },
          //               onTapUp: (details) {
          //                 // game.player.resetDirection();
          //               },
          //               child: Material(
          //                 color: Colors.transparent,
          //                 elevation: 3,
          //                 shadowColor: Theme.of(context).colorScheme.background,
          //                 child: const Icon(Icons.arrow_left, size: 64),
          //               ),
          //             ),
          //           ),
          //           Padding(
          //             padding: const EdgeInsets.only(right: 24),
          //             child: GestureDetector(
          //               onTapDown: (details) {
          //                 // game.player.moveRight();
          //               },
          //               onTapUp: (details) {
          //                 // game.player.resetDirection();
          //               },
          //               child: Material(
          //                 color: Colors.transparent,
          //                 elevation: 3,
          //                 shadowColor: Theme.of(context).colorScheme.background,
          //                 child: const Icon(Icons.arrow_right, size: 64),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          if (isPaused)
            Center(
              child: IconButton(
                icon: const Icon(
                  Icons.pause_circle,
                  size: 144,
                  color: Colors.white,
                ),
                onPressed: togglePause,
              ),
            ),
        ],
      ),
    );
  }

  void togglePause() {
    (widget.game as Downstairs).togglePauseState();
    setState(() {
      isPaused = !isPaused;
    });
  }
}

class ScoreDisplay extends StatelessWidget {
  const ScoreDisplay(this.game, {super.key});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final game = this.game as Downstairs;
    return ValueListenableBuilder(
      valueListenable: game.gameplayComponent.score,
      builder: (context, value, child) {
        return Text(
          value.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        );
      },
    );
  }
}
