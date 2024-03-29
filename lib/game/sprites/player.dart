import 'package:downstairs/game/game.dart';
import 'package:downstairs/game/sprites/platform.dart';
import 'package:downstairs/gen/assets.gen.dart';
import 'package:downstairs/util/flavor_config.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum PlayerState {
  idle,
  jump,
  run,
}

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<Downstairs>, KeyboardHandler, CollisionCallbacks {
  Player({
    required this.character,
    super.position,
    this.jumpSpeed = 300,
  }) : super(
          size: Vector2.all(32)..scale(2),
          anchor: Anchor.center,
          priority: 1,
        );

  int _hAxisInput = 0;
  final int movingLeftInput = -1;
  final int movingRightInput = 1;
  Vector2 _velocity = Vector2.zero();
  bool get isMovingDown => _velocity.y > 0;
  Character character;
  double jumpSpeed;
  ValueNotifier<double> hp = ValueNotifier(100);
  final double _gravity = 9;
  final double collisionOffset = 5;
  final List<Platform> _steppedPlatforms = [];

  @override
  Future<void> onLoad() async {
    debugMode = FlavorConfig.instance.isDev || FlavorConfig.instance.isStaging;

    await super.onLoad();

    await _loadSpriteAnimations(character);

    await add(CircleHitbox());

    current = PlayerState.idle;
  }

  @override
  void update(double dt) {
    if (gameRef.gameplayComponent.isIntro ||
        gameRef.gameplayComponent.isGameOver) {
      return;
    }

    var isFalling = true;

    _velocity.x = _hAxisInput * jumpSpeed;

    // allow player to go from right egde to left edge, vice versea
    final dashHorizontalCenter = size.x / 2;
    if (position.x < dashHorizontalCenter) {
      position.x = gameRef.size.x - dashHorizontalCenter;
    }
    if (position.x > gameRef.size.x - dashHorizontalCenter) {
      position.x = dashHorizontalCenter;
    }

    for (final platform in gameRef.objectComponent.platforms) {
      final isCollidingTop = playerBottomY < platform.y;
      if (collidingWith(platform) && isCollidingTop) {
        isFalling = false;

        // set vertical velocity to zero if monkey is on top of a platform
        if (_velocity.y > 0 && position.y > platform.position.y) {
          _velocity.y = 0;
          position.y =
              platform.position.y - (size.y / 2) - (platform.size.y / 2);
          break;
        }

        if (platform.isMoving) {
          final platformVelocity = Vector2.zero()
            ..x = platform.direction * platform.speed;
          position += platformVelocity * dt;
        }

        // add player score if they have touched a new platform
        if (isOnNewPlatform(platform)) {
          gameRef.gameplayComponent.increaseScore();
          _steppedPlatforms.add(platform);
        }
      }
    }

    if (isFalling) {
      current = PlayerState.jump;
      _velocity.y += _gravity;
    }

    position += _velocity * dt;

    // flip when player facing opposite direction
    if (_hAxisInput < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (_hAxisInput > 0 && scale.x < 0) {
      flipHorizontally();
    }

    if (!isFalling) {
      if (_hAxisInput == 0) {
        current = PlayerState.idle;
      } else {
        current = PlayerState.run;
      }
    }

    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;

    if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      moveLeft();
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      moveRight();
    }

    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    final isCollidingTop = position.y < other.y;
    if (isMovingDown && isCollidingTop) {
      if (other is LongNormalPlatform ||
          other is ShortNormalPlatform ||
          other is SpikesPlatform) {
        // set player to be on top of platform and falling velocity as zero
        _velocity = Vector2.zero();
        position.y = other.y - size.y / 2;
        current = PlayerState.idle;
        if (other is SpikesPlatform && isOnNewPlatform(other)) {
          hp.value -= 20;
        }
        return;
      }
    }
  }

  void jump({double? specialJumpSpeed}) {
    _velocity.y = specialJumpSpeed != null ? -specialJumpSpeed : -jumpSpeed;
  }

  void setJumpSpeed(double newJumpSpeed) {
    jumpSpeed = newJumpSpeed;
  }

  void moveLeft() {
    _hAxisInput = 0;

    current = PlayerState.run;

    _hAxisInput += movingLeftInput;
  }

  void moveRight() {
    _hAxisInput = 0;

    current = PlayerState.run;

    _hAxisInput += movingRightInput;
  }

  void resetDirection() {
    _hAxisInput = 0;
  }

  void resetVelocity() {
    _velocity = Vector2.zero();
  }

  void resetPosition() {
    position = Vector2(
      gameRef.size.x / 2,
      gameRef.size.y / 4,
    );
  }

  void resetHp() {
    hp = ValueNotifier(100);
  }

  void reset() {
    resetVelocity();
    resetHp();
    current = PlayerState.idle;
  }

  double get playerBottomY => position.y + size.y / 2 - collisionOffset;

  bool get isPlayerDead => hp.value <= 0;

  bool isOnNewPlatform(Platform<dynamic> platform) {
    return !_steppedPlatforms.contains(platform);
  }

  Future<void> _loadSpriteAnimations(Character character) async {
    if (character == Character.chef) {
      await _loadChefSpriteAnimations();
    } else {
      await _loadMonkeySpriteAnimations();
    }
  }

  Future<void> _loadMonkeySpriteAnimations() async {
    final dead = await gameRef.loadSpriteAnimation(
      Assets.images.monkeyDead.path,
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: 0.1,
        textureSize: Vector2.all(32),
        loop: false,
      ),
    );
    final hit = await gameRef.loadSpriteAnimation(
      Assets.images.monkeyHit.path,
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: 0.1,
        textureSize: Vector2.all(32),
        loop: false,
      ),
    );
    final idle = await gameRef.loadSpriteAnimation(
      Assets.images.monkeyIdle.path,
      SpriteAnimationData.sequenced(
        amount: 18,
        stepTime: 0.1,
        textureSize: Vector2.all(32),
      ),
    );
    final jump = await gameRef.loadSpriteAnimation(
      Assets.images.monkeyJump.path,
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1,
        textureSize: Vector2.all(32),
        loop: false,
      ),
    );
    final run = await gameRef.loadSpriteAnimation(
      Assets.images.monkeyRun.path,
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: 0.1,
        textureSize: Vector2.all(32),
      ),
    );

    animations = <PlayerState, SpriteAnimation>{
      PlayerState.idle: idle,
      PlayerState.jump: jump,
      PlayerState.run: run,
    };
  }

  Future<void> _loadChefSpriteAnimations() async {
    final idle = await gameRef.loadSpriteAnimation(
      Assets.images.chefIdle.path,
      SpriteAnimationData.sequenced(
        amount: 12,
        stepTime: 0.1,
        textureSize: Vector2(33, 32),
      ),
    );
    final jump = await gameRef.loadSpriteAnimation(
      Assets.images.chefJump.path,
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: 0.1,
        textureSize: Vector2.all(32),
      ),
    );
    final run = await gameRef.loadSpriteAnimation(
      Assets.images.chefRun.path,
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.1,
        textureSize: Vector2.all(32),
      ),
    );

    animations = <PlayerState, SpriteAnimation>{
      PlayerState.idle: idle,
      PlayerState.jump: jump,
      PlayerState.run: run,
    };
  }
}
