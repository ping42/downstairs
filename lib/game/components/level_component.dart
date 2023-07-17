import 'package:downstairs/game/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class LevelComponent extends Component with HasGameRef<Downstairs> {
  LevelComponent({
    this.selectedLevel = 1,
  });

  int selectedLevel;
  ValueNotifier<int> level = ValueNotifier(1);

  final Map<int, Difficulty> levelsConfig = {
    1: const Difficulty(
      minDistance: 100,
      maxDistance: 200,
      platformSpeed: 35,
      score: 0,
    ),
    2: const Difficulty(
      minDistance: 200,
      maxDistance: 300,
      platformSpeed: 45,
      score: 10,
    ),
    3: const Difficulty(
      minDistance: 200,
      maxDistance: 400,
      platformSpeed: 55,
      score: 20,
    ),
    4: const Difficulty(
      minDistance: 200,
      maxDistance: 500,
      platformSpeed: 65,
      score: 30,
    ),
    5: const Difficulty(
      minDistance: 200,
      maxDistance: 600,
      platformSpeed: 75,
      score: 40,
    ),
  };

  double get minDistance => levelsConfig[level.value]!.minDistance;

  double get maxDistance => levelsConfig[level.value]!.maxDistance;

  double get platformSpeed => levelsConfig[level.value]!.platformSpeed;

  Difficulty get difficulty => levelsConfig[level.value]!;

  bool shouldLevelUp(int score) {
    final nextLevel = level.value + 1;
    if (levelsConfig.containsKey(nextLevel)) {
      return levelsConfig[nextLevel]!.score == score;
    }
    return false;
  }

  void levelUp() {
    if (level.value < levelsConfig.keys.length) {
      level.value++;
    }
  }

  void setLevel(int newLevel) {
    if (levelsConfig.containsKey(newLevel)) {
      level.value = newLevel;
    }
  }

  void selectLevel(int newSelectedLevel) {
    if (levelsConfig.containsKey(newSelectedLevel)) {
      selectedLevel = newSelectedLevel;
    }
  }

  void reset() {
    level.value = selectedLevel;
  }
}

class Difficulty {
  const Difficulty({
    required this.minDistance,
    required this.maxDistance,
    required this.platformSpeed,
    required this.score,
  });

  final double minDistance;
  final double maxDistance;
  final double platformSpeed;
  final int score;
}
