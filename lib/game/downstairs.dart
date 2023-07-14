import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:downstairs/game/game.dart';
import 'package:downstairs/game/sprites/player.dart';
import 'package:downstairs/l10n/l10n.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

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
  ObjectComponent objectComponent = ObjectComponent();
  final int screenBufferSpace = 30;

  late Player player;

  double cameraY = 0;
  double worldBoundsTop = 0;

  @override
  Future<void> onLoad() async {
    await add(_world);

    await add(gameplayComponent);

    overlays.add('gameOverlay');
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
      // Move camera and worldBounds down over time
      cameraY += dt * 50;
      worldBoundsTop = cameraY;
      final worldBounds = Rect.fromLTRB(
        0,
        worldBoundsTop,
        camera.gameSize.x,
        cameraY + _world.size.y + screenBufferSpace,
      );
      camera.worldBounds = worldBounds;

      if (player.position.y >
          cameraY + _world.size.y + player.size.y + screenBufferSpace) {
        onLose();
      }
    }
  }

  void initializeGameStart() {
    setPlayer();

    gameplayComponent.reset();

    if (children.contains(objectComponent)) {
      objectComponent.removeFromParent();
    }

    player.reset();

    // 1. reset camera downwards movement
    // 2. set initial world bonuds
    cameraY = 0;
    worldBoundsTop = 0;
    camera
      ..resetMovement()
      ..worldBounds = Rect.fromLTRB(
        0,
        -_world.size.y,
        camera.gameSize.x,
        _world.size.y + screenBufferSpace,
      );

    player.resetPosition();

    setPlatformsGenerator();
  }

  void setPlayer() {
    player = Player(
      character: gameplayComponent.character,
      jumpSpeed: 300,
    );
    add(player);
  }

  void setPlatformsGenerator() {
    objectComponent = ObjectComponent(
      minVerticalDistanceToNextPlatform: 200,
      maxVerticalDistanceToNextPlatform: 300,
    );

    add(objectComponent);
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
