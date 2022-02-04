import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:space_adventure/game/command.dart';
import 'package:space_adventure/game/enemy.dart';
import 'package:space_adventure/game/game.dart';
import 'package:space_adventure/game/player.dart';
import 'package:space_adventure/game/power_up_manager.dart';

abstract class PowerUp extends SpriteComponent with HasGameRef<SpaceAdventure>, Hitbox, Collidable {
  late Timer _timer;

  Sprite getSprite();
  void onActivated();

  PowerUp({
    Vector2? position,
    Vector2? size,
    Sprite? sprite,
  }) : super(position: position, size: size, sprite: sprite) {
    _timer = Timer(3, callback: () => remove());
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    super.update(dt);
  }

  @override
  void onMount() {
    final shape = HitboxCircle(definition: 0.5);
    addShape(shape);

    sprite = getSprite();

    _timer.start();
    super.onMount();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if(other is Player) {
      onActivated();
      remove();
    }
    super.onCollision(intersectionPoints, other);
  }
}

class Nuke extends PowerUp {
  Nuke({
    Vector2? position,
    Vector2? size
  }) : super(position:  position, size: size);

  @override
  Sprite getSprite() {
    return PowerUpManager.nukeSprite;
  }

  @override
  void onActivated() {
    final command = Command<Enemy>(action: (enemy) {
      enemy.destroy();
    });
    gameRef.addCommand(command);
  }
}

class Health extends PowerUp {
  Health({
    Vector2? position,
    Vector2? size
  }) : super(position:  position, size: size);

  @override
  Sprite getSprite() {
    return PowerUpManager.healthSprite;
  }

  @override
  void onActivated() {
    final command = Command<Player>(action: (player) {
      player.increaseHealthBy(10);
    });
    gameRef.addCommand(command);
  }
}

// class MultiFire extends PowerUp {
//   MultiFire({
//     Vector2? position,
//     Vector2? size
//   }) : super(position:  position, size: size);

//   @override
//   Sprite getSprite() {
//     return Sprite(gameRef.images.fromCache('Shield.png'));
//   }

//   @override
//   void onActivated() {
//     final command = Command<Player>(action: (player) {
//       player.shootMultipleBulletsfn();
//     });
//     gameRef.addCommand(command);
//  }
//}