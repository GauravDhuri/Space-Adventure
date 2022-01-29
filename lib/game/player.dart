import 'package:flame/components.dart';

class Player extends SpriteComponent with HasGameRef {
  
  Vector2 _moveDirection = Vector2.zero();

  final double _speed = 300;

  Player({
    Sprite? sprite,
    Vector2? position,
    Vector2? size, 
  }): super(sprite: sprite, position: position, size: size);

  @override
  void update(double dt) {
    super.update(dt);
    position += _moveDirection.normalized() * _speed * dt;
    position.clamp(Vector2.zero() + size/2 ,gameRef.size - size/2);
  }

  void setMoveDreciton(Vector2 newMoveDirection) {
    _moveDirection = newMoveDirection;
  }
}