import 'package:downstairs/game/game.dart';
import 'package:downstairs/gen/assets.gen.dart';
import 'package:downstairs/l10n/l10n.dart';
import 'package:downstairs/util/flavor_config.dart';
import 'package:flame/game.dart';
import 'package:flame/widgets.dart';
import 'package:flame_audio/bgm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainMenuOverlay extends StatefulWidget {
  const MainMenuOverlay(this.game, {super.key});

  final Game game;

  @override
  State<MainMenuOverlay> createState() => MainMenuOverlayState();
}

class MainMenuOverlayState extends State<MainMenuOverlay> {
  late final Bgm bgm;

  Character character = Character.chef;
  int level = 1;

  @override
  void initState() {
    super.initState();
    bgm = context.read<AudioCubit>().bgm;
  }

  @override
  void dispose() {
    bgm.pause();
    super.dispose();
  }

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
                      onSelectCharacter: () {
                        setState(() {
                          character = Character.chef;
                        });
                      },
                      characterWidth: characterWidth,
                    ),
                    CharacterButton(
                      character: Character.monkey,
                      selected: character == Character.monkey,
                      onSelectCharacter: () {
                        setState(() {
                          character = Character.monkey;
                        });
                      },
                      characterWidth: characterWidth,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                LevelSelection(
                  onSelectLevel: (selecdtedLevel) {
                    setState(() {
                      game.levelComponent.selectedLevel = selecdtedLevel;
                    });
                  },
                  level: game.levelComponent.selectedLevel,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 250,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<AudioCubit>().playBgm();
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
    required this.onSelectCharacter,
    required this.characterWidth,
    super.key,
    this.selected = false,
  });

  final Character character;
  final void Function() onSelectCharacter;
  final double characterWidth;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onSelectCharacter,
      style: OutlinedButton.styleFrom(
        backgroundColor: selected ? Colors.lightBlue : Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: character == Character.chef
            ? SizedBox(
                width: 96,
                height: 96,
                child: CharacterChef(selected: selected),
              )
            : SizedBox(
                width: 96,
                height: 96,
                child: CharacterMonkey(selected: selected),
              ),
      ),
    );
  }
}

class CharacterChef extends StatelessWidget {
  const CharacterChef({
    required this.selected,
    super.key,
  });

  final bool selected;

  @override
  Widget build(BuildContext context) {
    if (selected) {
      return SpriteAnimationWidget.asset(
        path: Assets.images.chefRun.path,
        data: SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2.all(32),
        ),
        anchor: Anchor.center,
        playing: selected,
      );
    }
    return SpriteAnimationWidget.asset(
      path: Assets.images.chefIdle.path,
      data: SpriteAnimationData.sequenced(
        amount: 12,
        stepTime: 0.1,
        textureSize: Vector2(33, 32),
      ),
      anchor: Anchor.center,
      playing: selected,
    );
  }
}

class CharacterMonkey extends StatelessWidget {
  const CharacterMonkey({
    required this.selected,
    super.key,
  });

  final bool selected;

  @override
  Widget build(BuildContext context) {
    if (selected) {
      return SpriteAnimationWidget.asset(
        path: Assets.images.monkeyRun.path,
        data: SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2.all(32),
        ),
        anchor: Anchor.center,
        playing: selected,
      );
    }
    return SpriteAnimationWidget.asset(
      path: Assets.images.monkeyIdle.path,
      data: SpriteAnimationData.sequenced(
        amount: 18,
        stepTime: 0.1,
        textureSize: Vector2.all(32),
      ),
      anchor: Anchor.center,
      playing: selected,
    );
  }
}

class LevelSelection extends StatelessWidget {
  const LevelSelection({
    required this.onSelectLevel,
    required this.level,
    super.key,
  });

  final void Function(int level) onSelectLevel;
  final int level;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton(
            onPressed: () => onSelectLevel(1),
            style: OutlinedButton.styleFrom(
              backgroundColor: level == 1 ? Colors.lightBlue : Colors.white,
            ),
            child: Text(
              'Level 1',
              style: TextStyle(
                color: level == 1 ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton(
            onPressed: () => onSelectLevel(2),
            style: OutlinedButton.styleFrom(
              backgroundColor: level == 2 ? Colors.lightBlue : Colors.white,
            ),
            child: Text(
              'Level 2',
              style: TextStyle(
                color: level == 2 ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton(
            onPressed: () => onSelectLevel(3),
            style: OutlinedButton.styleFrom(
              backgroundColor: level == 3 ? Colors.lightBlue : Colors.white,
            ),
            child: Text(
              'Level 3',
              style: TextStyle(
                color: level == 3 ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton(
            onPressed: () => onSelectLevel(4),
            style: OutlinedButton.styleFrom(
              backgroundColor: level == 4 ? Colors.lightBlue : Colors.white,
            ),
            child: Text(
              'Level 4',
              style: TextStyle(
                color: level == 4 ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton(
            onPressed: () => onSelectLevel(5),
            style: OutlinedButton.styleFrom(
              backgroundColor: level == 5 ? Colors.lightBlue : Colors.white,
            ),
            child: Text(
              'Level 5',
              style: TextStyle(
                color: level == 5 ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
