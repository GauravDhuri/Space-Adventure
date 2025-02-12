import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:space_adventure/models/settings.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({ super.key });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
              child: Text(
                'Settings',
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
            Selector<Settings, bool>(
              selector: (context, settings) => settings.soundEffects,
              builder: (context, value, child) {
                return SwitchListTile(
                  title: const Text('Sound Effects'),
                  value: value,
                  onChanged: (newValue) {
                    Provider.of<Settings>(context, listen: false).soundEffects = newValue;
                  }
                );
              }
            ),
            Selector<Settings, bool>(
              selector: (context, settings) => settings.backgroundMusic,
              builder: (context, value, child) {
                return SwitchListTile(
                  title: const Text('Background Music'),
                  value: value,
                  onChanged: (newValue) {
                    Provider.of<Settings>(context, listen: false).backgroundMusic = newValue;
                  }
                );
              }
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(Icons.arrow_back_ios_new_rounded)),
            ),
          ],
        ),
      ),
    );
  }
}