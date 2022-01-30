import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:space_adventure/game/bullet.dart';

class Enemy extends SpriteComponent with HasGameRef, HasHitboxes, Collidable{
  
  final double _speed = 250; 

  final Random _random = Random();
  Vector2 getRandomVector() {
    return (Vector2.random(_random)- Vector2.random(_random)) * 300;
  }

  Enemy({
    Sprite? sprite,
    Vector2? position,
    Vector2? size, 
  }): super(sprite: sprite, position: position, size: size);

  @override
  void onMount() {
    super.onMount();

    final shape = HitboxCircle(normalizedRadius: 0.6);
    addHitbox(shape);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    if(other is Bullet) {
      removeFromParent();

      final particleComponent = ParticleComponent(
      Particle.generate(
        count: 20,
        lifespan: 0.1,
        generator: (i) => AcceleratedParticle(
          acceleration: getRandomVector(),
          speed: getRandomVector(),
          position: position.clone(),
          child: CircleParticle(
            radius: 1,
            paint: Paint()..color = Colors.orange
          )
        )
      )
    );

    gameRef.add(particleComponent);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += Vector2(0,1) * _speed * dt;

    if(position.y > gameRef.size.y) {
      removeFromParent();
    }
  }
}