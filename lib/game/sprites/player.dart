import 'package:downstairs/game/game.dart';
import 'package:downstairs/gen/assets.gen.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum PlayerState {
  left,
  right,
  center,
}

class Player extends SpriteGroupComponent<PlayerState>
    with HasGameRef<Downstairs>, KeyboardHandler, CollisionCallbacks {
  Player({
    super.position,
    this.jumpSpeed = 300,
  }) : super(
          size: Vector2(49, 67),
          anchor: Anchor.center,
          priority: 1,
        );

  int _hAxisInput = 0;
  final int movingLeftInput = -1;
  final int movingRightInput = 1;
  Vector2 _velocity = Vector2.zero();
  bool get isMovingDown => _velocity.y > 0;
  double jumpSpeed;
  final double _gravity = 9;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(CircleHitbox());

    // await _loadCharacterSprites();
    current = PlayerState.center;
  }

  @override
  void update(double dt) {
    if (gameRef.gameplayComponent.isIntro ||
        gameRef.gameplayComponent.isGameOver) {
      return;
    }

    _velocity.x = _hAxisInput * jumpSpeed;

    // allow player to go from right egde to left edge, vice versea
    final dashHorizontalCenter = size.x / 2;
    if (position.x < dashHorizontalCenter) {
      position.x = gameRef.size.x - dashHorizontalCenter;
    }
    if (position.x > gameRef.size.x - dashHorizontalCenter) {
      position.x = dashHorizontalCenter;
    }

    // _velocity.y += _gravity;

    position += _velocity * dt;

    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      moveLeft();
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      moveRight();
    }

    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);
  }

  void moveLeft() {
    _hAxisInput = 0;

    current = PlayerState.left;

    _hAxisInput += movingLeftInput;
  }

  void moveRight() {
    _hAxisInput = 0;

    current = PlayerState.right;

    _hAxisInput += movingRightInput;
  }

  void resetDirection() {
    _hAxisInput = 0;
  }

  void reset() {
    _velocity = Vector2.zero();
    current = PlayerState.center;
  }

  void resetPosition() {
    position = Vector2(
      gameRef.size.x / 2,
      gameRef.size.y / 4,
    );
  }

  // Future<void> _loadCharacterSprites() async {
  //   final left = await gameRef.loadSprite(Assets.images.dashLeft.path);
  //   final right = await gameRef.loadSprite(Assets.images.dashRight.path);
  //   final center = await gameRef.loadSprite(Assets.images.dashCenter.path);

  //   sprites = <PlayerState, Sprite>{
  //     PlayerState.left: left,
  //     PlayerState.right: right,
  //     PlayerState.center: center,
  //   };
  // }
}
