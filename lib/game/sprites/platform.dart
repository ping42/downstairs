import 'dart:async';
import 'dart:math';

import 'package:downstairs/game/game.dart';
import 'package:downstairs/gen/assets.gen.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

abstract class Platform<T> extends SpriteGroupComponent<T>
    with HasGameRef<Downstairs>, CollisionCallbacks {
  Platform({
    super.position,
    this.isFirstPlatform = false,
  }) : super(
          size: Vector2.all(100),
          priority: 2,
        );
  final hitbox = RectangleHitbox();
  bool isMoving = false;
  bool isFirstPlatform = false;

  double direction = 1;
  final Vector2 _velocity = Vector2.zero();
  double speed = 35;

  @override
  FutureOr<void> onLoad() async {
    debugMode = true;

    await super.onLoad();

    await add(hitbox);

    final rand = Random().nextInt(100);
    if (isFirstPlatform) {
      isMoving = false;
    } else if (rand > 60) {
      isMoving = true;
    }
  }

  void _move(double dt) {
    if (!isMoving) return;

    final gameWidth = gameRef.size.x;

    if (position.x <= 0) {
      direction = 1;
    } else if (position.x >= gameWidth - size.x) {
      direction = -1;
    }

    _velocity.x = direction * speed;

    position += _velocity * dt;
  }

  @override
  void update(double dt) {
    _move(dt);
    super.update(dt);
  }

  bool get goingRight => direction == 1;

  bool get goingLeft => direction == -1;
}

enum LongNormalPlatformState { only }

class LongNormalPlatform extends Platform<LongNormalPlatformState> {
  LongNormalPlatform({super.position, super.isFirstPlatform});

  final Map<String, Vector2> spriteOptions = {
    'platform_normal_long': Vector2(48, 16)..scale(2),
  };

  @override
  Future<void>? onLoad() async {
    final randSpriteIndex = Random().nextInt(spriteOptions.length);

    final randSprite = spriteOptions.keys.elementAt(randSpriteIndex);

    sprites = {
      LongNormalPlatformState.only:
          await gameRef.loadSprite(Assets.images.platformNormalLong.path),
    };

    current = LongNormalPlatformState.only;

    size = spriteOptions[randSprite]!;
    await super.onLoad();
  }
}

enum ShortNormalPlatformState { only }

class ShortNormalPlatform extends Platform<ShortNormalPlatformState> {
  ShortNormalPlatform({super.position, super.isFirstPlatform});

  final Map<String, Vector2> spriteOptions = {
    'platform_normal_short': Vector2(32, 16)..scale(2),
  };

  @override
  Future<void>? onLoad() async {
    final randSpriteIndex = Random().nextInt(spriteOptions.length);

    final randSprite = spriteOptions.keys.elementAt(randSpriteIndex);

    sprites = {
      ShortNormalPlatformState.only:
          await gameRef.loadSprite(Assets.images.platformNormalShort.path),
    };

    current = ShortNormalPlatformState.only;

    size = spriteOptions[randSprite]!;
    await super.onLoad();
  }
}
