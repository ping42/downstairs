import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:downstairs/game/game.dart';
import 'package:downstairs/game/sprites/player.dart';
import 'package:downstairs/l10n/l10n.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

class Downstairs extends FlameGame
    with HasKeyboardHandlerComponents, TapCallbacks, HasCollisionDetection {
  Downstairs({
    required this.l10n,
    required this.effectPlayer,
  }) {
    images.prefix = '';
  }

  final AppLocalizations l10n;
  final AudioPlayer effectPlayer;
  final WorldComponent _worldComponent = WorldComponent();
  GameplayComponent gameplayComponent = GameplayComponent();
  LevelComponent levelComponent = LevelComponent();
  ObjectComponent objectComponent = ObjectComponent();
  final int screenBufferSpace = 30;

  late Player player;

  double cameraY = 0;
  double worldBoundsTop = 0;

  @override
  Future<void> onLoad() async {
    await addAll([
      _worldComponent,
      gameplayComponent,
      levelComponent,
    ]);

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
      checkLevelUp();

      // move camera and worldBounds down over time
      cameraY += dt * levelComponent.cameraSpeed;
      worldBoundsTop = cameraY;
      final worldBounds = Rect.fromLTRB(
        0,
        worldBoundsTop,
        camera.gameSize.x,
        cameraY + _worldComponent.size.y + screenBufferSpace,
      );
      camera.worldBounds = worldBounds;

      if (player.position.y >
              cameraY +
                  _worldComponent.size.y +
                  player.size.y +
                  screenBufferSpace ||
          player.isPlayerDead) {
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

    levelComponent.reset();

    player.reset();

    // 1. reset camera downwards movement
    // 2. set initial world bonuds
    cameraY = 0;
    worldBoundsTop = 0;
    camera
      ..resetMovement()
      ..worldBounds = Rect.fromLTRB(
        0,
        -_worldComponent.size.y,
        camera.gameSize.x,
        _worldComponent.size.y + screenBufferSpace,
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
      minVerticalDistanceToNextPlatform: levelComponent.minDistance,
      maxVerticalDistanceToNextPlatform: levelComponent.maxDistance,
      minPlatformSpeed: levelComponent.platformSpeed,
    );

    add(objectComponent);
  }

  void startGame() {
    initializeGameStart();
    gameplayComponent.state = GameState.playing;
    overlays.remove('mainMenuOverlay');
  }

  void startGameAgain() {
    initializeGameStart();
    gameplayComponent.state = GameState.playing;
    overlays.remove('gameOverOverlay');
  }

  void backToMainMenu() {
    overlays.remove('gameOverOverlay');
    gameplayComponent.state = GameState.intro;
    overlays.add('mainMenuOverlay');
  }

  void resetGame() {
    player.removeFromParent();
    startGame();
  }

  void onLose() {
    gameplayComponent.state = GameState.gameOver;
    player.removeFromParent();
    overlays.add('gameOverOverlay');
  }

  void togglePauseState() {
    if (paused) {
      resumeEngine();
    } else {
      pauseEngine();
    }
  }

  void checkLevelUp() {
    if (levelComponent.shouldLevelUp(gameplayComponent.score.value)) {
      levelComponent.levelUp();

      objectComponent.configure(
        levelComponent.level.value,
        levelComponent.difficulty,
      );
    }
  }
}
