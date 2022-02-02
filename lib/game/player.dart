import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:space_adventure/game/enemy.dart';
import 'package:space_adventure/game/game.dart';
import 'package:space_adventure/models/spaceship_details.dart';

class Player extends SpriteComponent with HasGameRef<SpaceAdventure>, HasHitboxes, Collidable {
  
  Vector2 _moveDirection = Vector2.zero();

  int _score = 0;
  int get score => _score;
  int _health = 100;
  int get health => _health;

  Spaceship _spaceship;
  SpaceshipType spaceshipType;

  final Random _random = Random();
  Vector2 getRandomVector() {
    return (Vector2.random(_random)- Vector2(0.5,-0.4)) * 150;
  }

  Player({
    required this.spaceshipType,
    Sprite? sprite,
    Vector2? position,
    Vector2? size, 
  }): _spaceship = Spaceship.getSpaceshipByType(spaceshipType), 
      super(sprite: sprite, position: position, size: size);

  @override
  void onMount() {
    super.onMount();

    final shape = HitboxCircle(normalizedRadius: 0.5);
    addHitbox(shape);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    if(other is Enemy) {
      gameRef.camera.shake();

      _health -= 10;
      if(health <= 0){
        _health = 0;
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += _moveDirection.normalized() * _spaceship.speed * dt;
    position.clamp(Vector2.zero() + size/2 ,gameRef.size - size/2);

    final particleComponent = ParticleComponent(
      Particle.generate(
        count: 5,
        lifespan: 0.1,
        generator: (i) => AcceleratedParticle(
          acceleration: getRandomVector(),
          speed: getRandomVector(),
          position: position.clone() + Vector2(0, size.y /4),
          child: CircleParticle(
            radius: 0.6,
            paint: Paint()..color =Colors.yellow
          )
        )
      )
    );

    gameRef.add(particleComponent);
  }

  void setMoveDreciton(Vector2 newMoveDirection) {
    _moveDirection = newMoveDirection;
  }

  void addToScore(int points){
    _score += points;
  }

  void reset() {
    _score = 0;
    _health = 100;
    position = gameRef.canvasSize / 2;
  }

  void setSpaceshipType(SpaceshipType spaceshipType) {
    this.spaceshipType = spaceshipType;
    _spaceship = Spaceship.getSpaceshipByType(spaceshipType);
    sprite = gameRef.spriteSheet.getSpriteById(_spaceship.spriteId);
  }
}