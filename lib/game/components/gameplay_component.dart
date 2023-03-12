import 'package:downstairs/game/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum Character { chef, monkey }

class GameplayComponent extends Component with HasGameRef<Downstairs> {
  GameplayComponent();

  Character selectedCharacter = Character.chef;
  ValueNotifier<int> score = ValueNotifier(0);
  GameState state = GameState.intro;

  bool get isPlaying => state == GameState.playing;
  bool get isGameOver => state == GameState.gameOver;
  bool get isIntro => state == GameState.intro;

  void reset() {
    score.value = 0;
    state = GameState.intro;
  }

  void increaseScore() {
    score.value++;
  }

  set character(Character character) {
    selectedCharacter = character;
  }

  Character get character => selectedCharacter;
}

enum GameState { intro, playing, gameOver }
