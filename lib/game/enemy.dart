import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:space_adventure/game/bullet.dart';
import 'package:space_adventure/game/command.dart';
import 'package:space_adventure/game/game.dart';
import 'package:space_adventure/game/player.dart';

class Enemy extends SpriteComponent with HasGameRef<SpaceAdventure>, Hitbox, Collidable{
  
  double _speed = 250; 

  late Timer _freezeTimer;

  final Random _random = Random();
  Vector2 getRandomVector() {
    return (Vector2.random(_random)- Vector2.random(_random)) * 300;
  }

  Enemy({
    Sprite? sprite,
    Vector2? position,
    Vector2? size, 
  }): super(sprite: sprite, position: position, size: size){
    _freezeTimer = Timer(2, callback: () {
      _speed = 250;
    });
  }

  @override
  void onMount() {
    super.onMount();

    final shape = HitboxCircle(definition: 0.6);
    addShape(shape);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    if(other is Bullet || other is Player) {
      destroy();
    }
  }

  void destroy() {
      remove();
    
    final command = Command<Player>(action: (player){
      player.addToScore(1);
    });
    gameRef.addCommand(command);
    
    final particleComponent = ParticleComponent(
      particle: Particle.generate(
        count: 10,
        lifespan: 0.1,
        generator: (i) => AcceleratedParticle(
          acceleration: getRandomVector(),
          speed: getRandomVector(),
          position: position.clone(),
          child: CircleParticle(
            radius: 1,
            paint: Paint()..color = Colors.orange,
          ),
        ),
      ),
    );
    
    gameRef.add(particleComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);

    _freezeTimer.update(dt);

    position += Vector2(0,1) * _speed * dt;

    if(position.y > gameRef.size.y) {
      remove();
    }
  }

  void freeze() {
    _speed = 0;
    _freezeTimer.stop();
    _freezeTimer.start();
  }
}