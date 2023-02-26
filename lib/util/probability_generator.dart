import 'dart:math';

class ProbabilityGenerator {
  ProbabilityGenerator();

  final Random _rand = Random();

  bool generateWithProbability(double percent) {
    final randomInt =
        _rand.nextInt(100) + 1; // generate a number 1-100 inclusive

    if (randomInt <= percent) {
      return true;
    }

    return false;
  }
}
