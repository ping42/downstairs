import 'package:flame/events.dart';
import 'package:flame/game.dart';

class TestGame extends FlameGame with TapCallbacks {
  TestGame() {
    images.prefix = '';
  }
}
