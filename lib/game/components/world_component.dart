import 'package:downstairs/game/game.dart';
import 'package:downstairs/gen/assets.gen.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

class WorldComponent extends ParallaxComponent<Downstairs> {
  @override
  Future<void> onLoad() async {
    parallax = await gameRef.loadParallax(
      [
        ParallaxImageData(Assets.images.background06.path),
        ParallaxImageData(Assets.images.background05.path),
        ParallaxImageData(Assets.images.background04.path),
        ParallaxImageData(Assets.images.background03.path),
        ParallaxImageData(Assets.images.background02.path),
        ParallaxImageData(Assets.images.background01.path),
      ],
      fill: LayerFill.width,
      repeat: ImageRepeat.repeat,
      baseVelocity: Vector2(0, -5),
      velocityMultiplierDelta: Vector2(0, 1.2),
    );
  }
}
