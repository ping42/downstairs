import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:downstairs/gen/assets.gen.dart';
import 'package:downstairs/loading/loading.dart';
import 'package:flame/cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockImages extends Mock implements Images {}

class _MockAudioCache extends Mock implements AudioCache {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PreloadCubit', () {
    group('loadSequentially', () {
      late Images images;
      late AudioCache audio;

      blocTest<PreloadCubit, PreloadState>(
        'loads assets',
        setUp: () {
          audio = _MockAudioCache();
          when(
            () => audio.loadAll([
              Assets.audio.background,
              Assets.audio.effect,
            ]),
          ).thenAnswer(
            (invocation) async => [
              Uri.parse(Assets.audio.background),
              Uri.parse(Assets.audio.effect)
            ],
          );

          images = _MockImages();
          when(
            () => images.loadAll([
              Assets.images.chefIdle.path,
              Assets.images.chefJump.path,
              Assets.images.chefRun.path,
              Assets.images.monkeyDead.path,
              Assets.images.monkeyHit.path,
              Assets.images.monkeyIdle.path,
              Assets.images.monkeyJump.path,
              Assets.images.monkeyRun.path,
              Assets.images.downstairsLogo.path,
              Assets.images.platformNormalLong.path,
              Assets.images.platformNormalShort.path,
            ]),
          ).thenAnswer((invocation) => Future.value(<Image>[]));
        },
        build: () => PreloadCubit(images, audio),
        act: (bloc) => bloc.loadSequentially(),
        expect: () => [
          isA<PreloadState>()
              .having((s) => s.currentLabel, 'currentLabel', equals(''))
              .having((s) => s.totalCount, 'totalCount', equals(2)),
          isA<PreloadState>()
              .having((s) => s.currentLabel, 'currentLabel', equals('audio'))
              .having((s) => s.isComplete, 'isComplete', isFalse)
              .having((s) => s.loadedCount, 'loadedCount', equals(0)),
          isA<PreloadState>()
              .having((s) => s.currentLabel, 'currentLabel', equals('audio'))
              .having((s) => s.isComplete, 'isComplete', isFalse)
              .having((s) => s.loadedCount, 'loadedCount', equals(1)),
          isA<PreloadState>()
              .having((s) => s.currentLabel, 'currentLabel', equals('images'))
              .having((s) => s.isComplete, 'isComplete', isFalse)
              .having((s) => s.loadedCount, 'loadedCount', equals(1)),
          isA<PreloadState>()
              .having((s) => s.currentLabel, 'currentLabel', equals('images'))
              .having((s) => s.isComplete, 'isComplete', isTrue)
              .having((s) => s.loadedCount, 'loadedCount', equals(2)),
        ],
        verify: (bloc) {
          verify(
            () => audio.loadAll([
              Assets.audio.background,
              Assets.audio.effect,
            ]),
          ).called(1);
          verify(
            () => images.loadAll([
              Assets.images.chefIdle.path,
              Assets.images.chefJump.path,
              Assets.images.chefRun.path,
              Assets.images.monkeyDead.path,
              Assets.images.monkeyHit.path,
              Assets.images.monkeyIdle.path,
              Assets.images.monkeyJump.path,
              Assets.images.monkeyRun.path,
              Assets.images.downstairsLogo.path,
              Assets.images.platformNormalLong.path,
              Assets.images.platformNormalShort.path,
              Assets.images.platformSpikes.path,
            ]),
          ).called(1);
        },
      );
    });
  });
}
