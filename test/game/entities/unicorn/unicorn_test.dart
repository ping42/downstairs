// ignore_for_file: cascade_invocations

import 'package:audioplayers/audioplayers.dart';
import 'package:downstairs/game/entities/unicorn/behaviors/behaviors.dart';
import 'package:downstairs/game/game.dart';
import 'package:downstairs/l10n/l10n.dart';
import 'package:flame/extensions.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAppLocalizations extends Mock implements AppLocalizations {}

class _MockAudioPlayer extends Mock implements AudioPlayer {}

class _VeryGoodFlameGame extends Downstairs {
  _VeryGoodFlameGame({required super.l10n, required super.effectPlayer});

  @override
  Future<void> onLoad() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final l10n = _MockAppLocalizations();
  _VeryGoodFlameGame createFlameGame() {
    return _VeryGoodFlameGame(l10n: l10n, effectPlayer: _MockAudioPlayer());
  }

  group('Unicorn', () {
    setUp(() {
      when(() => l10n.counterText(any())).thenReturn('counterText');
    });

    testWithGame(
      'has all behaviors',
      createFlameGame,
      (game) async {
        final unicorn = Unicorn(position: Vector2.all(1));
        await game.ensureAdd(unicorn);

        expect(unicorn.findBehavior<TappingBehavior>(), isNotNull);
      },
    );

    testWithGame(
      'loads correctly',
      createFlameGame,
      (game) async {
        final unicorn = Unicorn(position: Vector2.all(1));
        await game.ensureAdd(unicorn);

        expect(unicorn.isAnimationPlaying(), equals(false));
      },
    );

    group('animation', () {
      testWithGame(
        'plays animation',
        createFlameGame,
        (game) async {
          final unicorn = Unicorn.test(position: Vector2.all(1));
          await game.ensureAdd(unicorn);

          unicorn.playAnimation();
          expect(unicorn.animation.currentIndex, equals(0));

          game.update(0.1);

          expect(unicorn.animation.currentIndex, equals(1));
          expect(unicorn.isAnimationPlaying(), equals(true));
        },
      );

      testWithGame(
        'reset animation back to frame one and stops it',
        createFlameGame,
        (game) async {
          final unicorn = Unicorn.test(position: Vector2.all(1));
          await game.ensureAdd(unicorn);

          unicorn.playAnimation();
          game.update(0.1);
          expect(unicorn.animation.currentIndex, equals(1));
          expect(unicorn.isAnimationPlaying(), equals(true));

          unicorn.resetAnimation();
          expect(unicorn.isAnimationPlaying(), equals(false));
          expect(unicorn.animation.currentIndex, equals(0));

          game.update(0.1);
          expect(unicorn.animation.currentIndex, equals(0));
          expect(unicorn.isAnimationPlaying(), equals(false));
        },
      );
    });
  });
}
