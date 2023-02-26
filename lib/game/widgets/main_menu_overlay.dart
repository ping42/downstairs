import 'package:downstairs/game/game.dart';
import 'package:downstairs/l10n/l10n.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MainMenuOverlay extends StatefulWidget {
  const MainMenuOverlay(this.game, {super.key});

  final Game game;

  @override
  State<MainMenuOverlay> createState() => MainMenuOverlayState();
}

class MainMenuOverlayState extends State<MainMenuOverlay> {
  @override
  Widget build(BuildContext context) {
    final Downstairs game = widget.game as Downstairs;
    final l10n = context.l10n;
    return LayoutBuilder(builder: (context, constraints) {
      // 760 is the smallest height the browser can have until the
      // layout is too large to fit.
      final bool screenHeightIsSmall = constraints.maxHeight < 760;
      return Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: SizedBox(
            width: 250,
            height: 64,
            child: ElevatedButton(
              onPressed: () {
                game.startGame();
              },
              child: Center(child: Text(l10n.titleButtonStart)),
            ),
          ),
        ),
      );
    });
  }
}
