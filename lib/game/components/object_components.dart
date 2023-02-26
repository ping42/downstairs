import 'dart:math';

import 'package:downstairs/game/game.dart';
import 'package:downstairs/game/sprites/platform.dart';
import 'package:downstairs/util/num_utils.dart';
import 'package:downstairs/util/probability_generator.dart';
import 'package:flame/components.dart';

final Random _rand = Random();

class ObjectComponents extends Component with HasGameRef<Downstairs> {
  ObjectComponents({
    this.minVerticalDistanceToNextPlatform = 200,
    this.maxVerticalDistanceToNextPlatform = 300,
  });

  double minVerticalDistanceToNextPlatform;
  double maxVerticalDistanceToNextPlatform;
  final probGen = ProbabilityGenerator();
  final double _tallestPlatformHeight = 50;
  final List<Platform> _platforms = [];

  @override
  void onMount() {
    super.onMount();

    var currentX = gameRef.size.x.floor() / 2 - 30;

    var currentY = gameRef.size.y.floor() / 3;

    for (var i = 0; i < 9; i++) {
      if (i != 0) {
        currentX = _generateNextX(100);
        currentY = _generateNextY();
      }
      _platforms.add(
        _semiRandomPlatform(
          Vector2(
            currentX,
            currentY,
          ),
          i == 0,
        ),
      );

      add(_platforms[i]);
    }
  }

  @override
  void update(double dt) {
    final topOfLowestPlatform =
        _platforms.first.position.y + _tallestPlatformHeight;

    final screenBottom = gameRef.player.position.y +
        (gameRef.size.x / 2) +
        gameRef.screenBufferSpace;

    if (topOfLowestPlatform > screenBottom) {
      var newPlatY = _generateNextY();
      var newPlatX = _generateNextX(100);
      final nextPlat = _semiRandomPlatform(Vector2(newPlatX, newPlatY), false);
      add(nextPlat);

      _platforms.add(nextPlat);

      gameRef.gameplayComponent.increaseScore();

      _cleanupPlatforms();
    }

    super.update(dt);
  }

  void _cleanupPlatforms() {
    // remove the highest platform
    _platforms.removeAt(_platforms.length).removeFromParent();
  }

  double _generateNextX(int platformWidth) {
    final previousPlatformXRange = Range(
      _platforms.last.position.x,
      _platforms.last.position.x + platformWidth,
    );

    double nextPlatformAnchorX;

    do {
      nextPlatformAnchorX =
          _rand.nextInt(gameRef.size.x.floor() - platformWidth).toDouble();
    } while (previousPlatformXRange.overlaps(
        Range(nextPlatformAnchorX, nextPlatformAnchorX + platformWidth)));

    return nextPlatformAnchorX;
  }

  double _generateNextY() {
    final currentLowestPlatformY = _platforms.last.center.y;

    final distanceToNextY = minVerticalDistanceToNextPlatform.toInt() +
        _rand
            .nextInt(
              (maxVerticalDistanceToNextPlatform -
                      minVerticalDistanceToNextPlatform)
                  .floor(),
            )
            .toDouble();

    return currentLowestPlatformY + distanceToNextY;
  }

  Platform _semiRandomPlatform(Vector2 position, bool isFirstPlatform) {
    if (probGen.generateWithProbability(70)) {
      return LongNormalPlatform(
        position: position,
        isFirstPlatform: isFirstPlatform,
      );
    }
    return ShortNormalPlatform(
      position: position,
      isFirstPlatform: isFirstPlatform,
    );
  }
}
