import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

class SpaceAdventure extends FlameGame {
  @override
  Future<void> onLoad() async {
    await images.load('spaceShooter.png');

    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: images.fromCache('spaceShooter.png'),
      columns: 2,
      rows: 2);
      
      SpriteComponent player = SpriteComponent(
        sprite: spriteSheet.getSpriteById(3),
        size: Vector2(64,64),
        position: canvasSize /2
      );
      player.anchor = Anchor.center;
      add(player);
  }
}