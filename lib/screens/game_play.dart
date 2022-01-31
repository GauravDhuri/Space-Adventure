import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:space_adventure/game/game.dart';
import 'package:space_adventure/screens/overlays/pause_button.dart';
import 'package:space_adventure/screens/overlays/pause_menu.dart';

SpaceAdventure _spaceAdventure = SpaceAdventure();

class GamePlay extends StatelessWidget {
  const GamePlay({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: GameWidget(
          game: _spaceAdventure,
          initialActiveOverlays: const [PauseButton.id],
          overlayBuilderMap: {
            PauseButton.id : (
              BuildContext context, SpaceAdventure gameRef
            ) => PauseButton(
              gameRef: gameRef,
            ),
            PauseMenu.id : (
              BuildContext context, SpaceAdventure gameRef
            ) => PauseMenu(
              gameRef: gameRef,
            ),
          },
        ),
      ),
    );
  }
}