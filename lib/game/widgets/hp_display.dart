import 'package:downstairs/game/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class HpDisplay extends StatelessWidget {
  const HpDisplay(this.game, {super.key});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final game = this.game as Downstairs;
    return ValueListenableBuilder(
      valueListenable: game.player.hp,
      builder: (context, value, child) {
        return Text(
          'HP: $value',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        );
      },
    );
  }
}
