import 'package:downstairs/game/game.dart';
import 'package:downstairs/gen/assets.gen.dart';
import 'package:downstairs/l10n/l10n.dart';
import 'package:flame/game.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

class MainMenuOverlay extends StatefulWidget {
  const MainMenuOverlay(this.game, {super.key});

  final Game game;

  @override
  State<MainMenuOverlay> createState() => MainMenuOverlayState();
}

class MainMenuOverlayState extends State<MainMenuOverlay> {
  Character character = Character.chef;

  @override
  Widget build(BuildContext context) {
    final game = widget.game as Downstairs;
    final l10n = context.l10n;
    return LayoutBuilder(builder: (context, constraints) {
      final characterWidth = constraints.maxWidth / 5;

      // 760 is the smallest height the browser can have until the
      // layout is too large to fit.
      final screenHeightIsSmall = constraints.maxHeight < 760;
      return Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (!screenHeightIsSmall) const SizedBox(height: 30),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CharacterButton(
                      character: Character.chef,
                      selected: character == Character.chef,
                      onSelectChar: () {
                        setState(() {
                          character = Character.chef;
                        });
                      },
                      characterWidth: characterWidth,
                    ),
                    CharacterButton(
                      character: Character.monkey,
                      selected: character == Character.monkey,
                      onSelectChar: () {
                        setState(() {
                          character = Character.monkey;
                        });
                      },
                      characterWidth: characterWidth,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 250,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: () {
                      game.gameplayComponent.character = character;
                      game.startGame();
                    },
                    child: Center(
                        child: Text(
                      l10n.titleButtonStart,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class CharacterButton extends StatelessWidget {
  const CharacterButton({
    required this.character,
    required this.onSelectChar,
    required this.characterWidth,
    super.key,
    this.selected = false,
  });

  final Character character;
  final void Function() onSelectChar;
  final double characterWidth;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onSelectChar,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: character == Character.chef
            ? SizedBox(
                width: 96,
                height: 96,
                child: selected
                    ? SpriteAnimationWidget.asset(
                        path: Assets.images.chefRun.path,
                        data: SpriteAnimationData.sequenced(
                          amount: 6,
                          stepTime: 0.1,
                          textureSize: Vector2.all(32),
                        ),
                        anchor: Anchor.center,
                        playing: selected,
                      )
                    : SpriteAnimationWidget.asset(
                        path: Assets.images.chefIdle.path,
                        data: SpriteAnimationData.sequenced(
                          amount: 12,
                          stepTime: 0.1,
                          textureSize: Vector2(33, 32),
                        ),
                        anchor: Anchor.center,
                        playing: selected,
                      ),
              )
            : SizedBox(
                width: 96,
                height: 96,
                child: selected
                    ? SpriteAnimationWidget.asset(
                        path: Assets.images.monkeyRun.path,
                        data: SpriteAnimationData.sequenced(
                          amount: 8,
                          stepTime: 0.1,
                          textureSize: Vector2.all(32),
                        ),
                        anchor: Anchor.center,
                        playing: selected,
                      )
                    : SpriteAnimationWidget.asset(
                        path: Assets.images.monkeyIdle.path,
                        data: SpriteAnimationData.sequenced(
                          amount: 18,
                          stepTime: 0.1,
                          textureSize: Vector2.all(32),
                        ),
                        anchor: Anchor.center,
                        playing: selected,
                      ),
              ),
      ),
    );
  }
}
