import 'package:downstairs/game/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class LevelDisplay extends StatelessWidget {
  const LevelDisplay(this.game, {super.key});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final game = this.game as Downstairs;
    return ValueListenableBuilder(
      valueListenable: game.levelComponent.level,
      builder: (context, value, child) {
        return Text(
          'Level: $value',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        );
      },
    );
  }
}
