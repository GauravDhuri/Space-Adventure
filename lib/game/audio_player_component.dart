import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:provider/provider.dart';

import 'game.dart';

import '../models/settings.dart';

class AudioPlayerComponent extends Component
    with HasGameReference<SpacescapeGame> {
  @override
  Future<void>? onLoad() async {
    FlameAudio.bgm.initialize();

    await FlameAudio.audioCache.loadAll([
      'laser1.ogg',
      'powerUp6.ogg',
      'laserSmall_001.ogg',
      'SpaceAdventureBGM.ogg'
    ]);

    try {
      await FlameAudio.audioCache.load(
        'SpaceAdventureBGM.ogg',
      );
    } catch (_) {
      // ignore: avoid_print
    }

    return super.onLoad();
  }

  void playBgm(String filename) {
    if (!FlameAudio.audioCache.loadedFiles.containsKey(filename)) return;

    if (game.buildContext != null) {
      if (Provider.of<Settings>(game.buildContext!, listen: false)
          .backgroundMusic) {
        FlameAudio.bgm.play(filename);
      }
    }
  }

  void playSfx(String filename) {
    if (game.buildContext != null) {
      if (Provider.of<Settings>(game.buildContext!, listen: false)
          .soundEffects) {
        FlameAudio.play(filename);
      }
    }
  }

  void stopBgm() {
    FlameAudio.bgm.stop();
  }
}