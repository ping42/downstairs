import 'package:downstairs/game/game.dart';
import 'package:downstairs/game/widgets/level_display.dart';
import 'package:downstairs/game/widgets/score_display.dart';
import 'package:downstairs/l10n/l10n.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay(this.game, {super.key});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final game = this.game as Downstairs;
    final l10n = context.l10n;
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.titleButtonGameOver,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 30),
            LevelDisplay(game),
            ScoreDisplay(game),
            const SizedBox(height: 30),
            SizedBox(
              width: 250,
              height: 64,
              child: ElevatedButton(
                onPressed: game.startGameAgain,
                child: Center(
                  child: Text(
                    l10n.titleButtonStartAgain,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 250,
              height: 64,
              child: ElevatedButton(
                onPressed: game.backToMainMenu,
                child: Center(
                  child: Text(
                    l10n.titleButtonBackToMainMenu,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
