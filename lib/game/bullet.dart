import 'package:flame/components.dart';

class Bullet extends SpriteComponent {
  final double _speed = 450;

  Bullet({
    Sprite? sprite,
    Vector2? position,
    Vector2? size
  }) : super (sprite: sprite, position: position, size: size);

  @override
  void update(double dt) {
    super.update(dt);

    position += Vector2(0,-1) * _speed * dt;

    if(position.y < 0) {
      removeFromParent();
    }
  } 
}