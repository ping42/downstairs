import 'package:downstairs/game/game.dart';
import 'package:downstairs/game/widgets/game_overlay.dart';
import 'package:downstairs/game/widgets/main_menu_overlay.dart';
import 'package:downstairs/l10n/l10n.dart';
import 'package:downstairs/loading/cubit/cubit.dart';
import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const GamePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return AudioCubit(audioCache: context.read<PreloadCubit>().audio);
      },
      child: const Scaffold(
        body: SafeArea(
          child: Center(
            child: GameView(),
          ),
        ),
      ),
    );
  }
}

class GameView extends StatefulWidget {
  const GameView({super.key, this.game});

  final FlameGame? game;
  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  FlameGame? _game;

  @override
  Widget build(BuildContext context) {
    _game ??= widget.game ??
        Downstairs(
          l10n: context.l10n,
          effectPlayer: context.read<AudioCubit>().effectPlayer,
        );
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 800,
        minWidth: 550,
      ),
      child: GameWidget(
        game: _game!,
        overlayBuilderMap: <String, Widget Function(BuildContext, Game)>{
          'gameOverlay': (context, game) => GameOverlay(game),
          'mainMenuOverlay': (context, game) => MainMenuOverlay(game),
          // 'gameOverOverlay': (context, game) => GameOverOverlay(game),
        },
      ),
    );
  }
}
