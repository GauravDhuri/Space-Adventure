

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:provider/provider.dart';
import 'package:space_adventure/models/settings.dart';

class AudioPlayerComponent extends Component with HasGameRef {
  @override
  Future<void>? onLoad() async {
    FlameAudio.bgm.initialize();

    await FlameAudio.audioCache.loadAll([
      'laser1.ogg',
      'powerUp6.ogg',
      'laserSmall_001.ogg',
      'SpaceAdventureBGM.ogg'
    ]);

    return super.onLoad();
  }

  void playBgm(String filename) {
    if(gameRef.buildContext != null) {
      if (Provider.of<Settings>(gameRef.buildContext!, listen: false).backgroundMusic) {
        FlameAudio.bgm.play(filename);
      }
    }
  }

  void playSfx(String filename) {
     if(gameRef.buildContext != null) {
      if (Provider.of<Settings>(gameRef.buildContext!, listen: false).soundEffects) {
        FlameAudio.play(filename);
      }
    }
  }

  void stopBgm() {
    FlameAudio.bgm.stop();
  }
}