import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:downstairs/game/game.dart';
import 'package:downstairs/game/sprites/monkey.dart';
import 'package:downstairs/l10n/l10n.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/widgets.dart';

class Downstairs extends FlameGame
    with HasKeyboardHandlerComponents, HasTappables, HasCollisionDetection {
  Downstairs({
    required this.l10n,
    required this.effectPlayer,
  }) {
    images.prefix = '';
  }

  final AppLocalizations l10n;
  final AudioPlayer effectPlayer;
  final WorldComponent _world = WorldComponent();
  GameplayComponent gameplayComponent = GameplayComponent();
  ObjectComponents objectComponents = ObjectComponents();
  int screenBufferSpace = 30;

  late Monkey player;

  @override
  Future<void> onLoad() async {
    await add(_world);

    await add(gameplayComponent);

    overlays.add('gameOverlay');

    // await add(CounterComponent(position: (size / 2)..sub(Vector2(0, 16))));

    // await add(Unicorn(position: size / 2));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameplayComponent.isGameOver) {
      return;
    }

    if (gameplayComponent.isIntro) {
      overlays.add('mainMenuOverlay');
      return;
    }

    if (gameplayComponent.isPlaying) {
      final worldBounds = Rect.fromLTRB(
        0,
        camera.position.y - screenBufferSpace,
        camera.gameSize.x,
        camera.position.y + _world.size.y,
      );
      camera.worldBounds = worldBounds;

      if (player.position.y >
          camera.position.y +
              _world.size.y +
              player.size.y +
              screenBufferSpace) {
        onLose();
      }
    }
  }

  void initializeGameStart() {
    setPlayer();

    gameplayComponent.reset();

    if (children.contains(objectComponents)) {
      objectComponents.removeFromParent();
    }

    player.reset();

    // 1. reset camera downwards movement
    // 2. set initial world bonuds
    camera
      ..resetMovement()
      ..worldBounds = Rect.fromLTRB(
        0,
        -_world.size.y, // top of screen is 0, so negative is already off screen
        camera.gameSize.x,
        _world.size.y +
            screenBufferSpace, // makes sure bottom bound of game is below bottom of screen
      );

    player.resetPosition();

    setPlatformsGenerator();
  }

  void setPlayer() {
    player = Monkey(jumpSpeed: 300);
    add(player);
  }

  void setPlatformsGenerator() {
    objectComponents = ObjectComponents(
      minVerticalDistanceToNextPlatform: 200,
      maxVerticalDistanceToNextPlatform: 300,
    );

    add(objectComponents);
  }

  void startGame() {
    initializeGameStart();
    gameplayComponent.state = GameState.playing;
    overlays.remove('mainMenuOverlay');
  }

  void resetGame() {
    player.removeFromParent();
    startGame();
  }

  void onLose() {
    gameplayComponent.state = GameState.gameOver;
    player.removeFromParent();
    overlays.add('mainMenuOverlay');
  }

  void togglePauseState() {
    if (paused) {
      resumeEngine();
    } else {
      pauseEngine();
    }
  }
}
