import 'package:flutter/material.dart';
import 'package:space_adventure/game/game.dart';
import 'package:space_adventure/screens/main_menu.dart';
import 'package:space_adventure/screens/overlays/pause_button.dart';

class PauseMenu extends StatelessWidget {
  static const String id = 'PauseMenu';
  final SpaceAdventure gameRef;

  const PauseMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
              child: Text(
                'Paused',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50.0,
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      blurRadius: 20.0,
                      color: Colors.white,
                      offset: Offset(0,0),
                    ),
                  ]
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {
                  gameRef.resumeEngine();
                  gameRef.overlays.remove(PauseMenu.id);
                  gameRef.overlays.add(PauseButton.id);
                },
                child: const Text('Resume')
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {
                  gameRef.overlays.remove(PauseMenu.id);
                  gameRef.overlays.add(PauseButton.id);
                  gameRef.reset();
                  gameRef.resumeEngine();
                },
                child: const Text('Restart')
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {
                  gameRef.overlays.remove(PauseMenu.id);
                  gameRef.reset();

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder:
                        (context) => const MainMenu()
                    )
                  );
                },
                child: const Text('Exit')
              ),
            ),
          ],
      ),
    );
  }
}