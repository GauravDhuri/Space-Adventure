import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:space_adventure/game/game.dart';

SpaceAdventure _spaceAdventure = SpaceAdventure();

class GamePlay extends StatelessWidget {
  const GamePlay({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GameWidget(
        game: _spaceAdventure
      ),
    );
  }
}