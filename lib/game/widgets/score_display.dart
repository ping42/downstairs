import 'package:downstairs/game/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

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
          'Score: $value',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        );
      },
    );
  }
}
