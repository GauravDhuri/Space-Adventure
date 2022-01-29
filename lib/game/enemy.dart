import 'dart:math';

import 'package:flame/components.dart';

class Enemy extends SpriteComponent with HasGameRef{
  
  final double _speed = 250; 

  Enemy({
    Sprite? sprite,
    Vector2? position,
    Vector2? size, 
  }): super(sprite: sprite, position: position, size: size);

  @override
  void update(double dt) {
    super.update(dt);

    position += Vector2(0,1) * _speed * dt;

    if(position.y > gameRef.size.y) {
      removeFromParent();
    }
  }
}