// ignore_for_file: unnecessary_this

import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:space_adventure/game/audio_player_component.dart';
import 'package:space_adventure/game/bullet.dart';
import 'package:space_adventure/game/command.dart';
import 'package:space_adventure/game/enemy.dart';
import 'package:space_adventure/game/game.dart';
import 'package:space_adventure/models/player_data.dart';
import 'package:space_adventure/models/spaceship_details.dart';

class Player extends SpriteComponent with HasGameRef<SpaceAdventure>, Hitbox, Collidable, JoystickListener {
  
  Vector2 _moveDirection = Vector2.zero();

  int get score => _playerData.currentScore;
  int _health = 100;
  int get health => _health;

  Spaceship _spaceship;
  SpaceshipType spaceshipType;

  late PlayerData _playerData;

  bool _shootMultipleBullets = false;
  late Timer _powerUpTimer;

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
      super(sprite: sprite, position: position, size: size){
        _powerUpTimer = Timer(4, callback: () => _shootMultipleBullets = false);
      }

  @override
  void onMount() {
    super.onMount();

    final shape = HitboxCircle(definition: 0.5);
    addShape(shape);

    _playerData = Provider.of<PlayerData>(gameRef.buildContext!, listen: false);
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

    _powerUpTimer.update(dt);

    position += _moveDirection.normalized() * _spaceship.speed * dt;
    position.clamp(Vector2.zero() + size/2 ,gameRef.size - size/2);

  final particleComponent = ParticleComponent(
      particle: Particle.generate(
        count: 2,
        lifespan: 0.1,
        generator: (i) => AcceleratedParticle(
          acceleration: getRandomVector(),
          speed: getRandomVector(),
          position: (this.position.clone() + Vector2(0, this.size.y / 4)),
          child: CircleParticle(
            radius: 1,
            paint: Paint()..color = Colors.yellow,
          ),
        ),
      ),
    );

    gameRef.add(particleComponent);
  }

  void setMoveDirection(Vector2 newMoveDirection) {
    _moveDirection = newMoveDirection;
  }

  @override
  void joystickAction(JoystickActionEvent event) {
    if (event.id == 0 && event.event == ActionEvent.down) {
      Bullet bullet = Bullet(
        sprite: gameRef.spriteSheet.getSpriteById(8),
        size: Vector2(64, 64),
        position: this.position.clone(),
        level: _spaceship.level
      );

      bullet.anchor = Anchor.center;
      gameRef.add(bullet);

      gameRef.addCommand(
        Command<AudioPlayerComponent>(
          action: (audioPlayer){
            audioPlayer.playSfx('laserSmall_001.ogg');
          }
        )
      );

      if (_shootMultipleBullets) {
        for (int i = -1; i < 2; i += 2) {
          Bullet bullet = Bullet(
            sprite: gameRef.spriteSheet.getSpriteById(8),
            size: Vector2(64, 64),
            position: this.position.clone(),
            level: _spaceship.level
          );

          bullet.anchor = Anchor.center;
          bullet.direction.rotate(i * pi / 6);
          gameRef.add(bullet);
        }
      }
    }
  }

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    switch (event.directional) {
      case JoystickMoveDirectional.moveUp:
        this.setMoveDirection(Vector2(0, -1));
        break;
      case JoystickMoveDirectional.moveUpLeft:
        this.setMoveDirection(Vector2(-1, -1));
        break;
      case JoystickMoveDirectional.moveUpRight:
        this.setMoveDirection(Vector2(1, -1));
        break;
      case JoystickMoveDirectional.moveRight:
        this.setMoveDirection(Vector2(1, 0));
        break;
      case JoystickMoveDirectional.moveDown:
        this.setMoveDirection(Vector2(0, 1));
        break;
      case JoystickMoveDirectional.moveDownRight:
        this.setMoveDirection(Vector2(1, 1));
        break;
      case JoystickMoveDirectional.moveDownLeft:
        this.setMoveDirection(Vector2(-1, 1));
        break;
      case JoystickMoveDirectional.moveLeft:
        this.setMoveDirection(Vector2(-1, 0));
        break;
      case JoystickMoveDirectional.idle:
        this.setMoveDirection(Vector2.zero());
        break;
    }
  }

  void addToScore(int points){
    _playerData.money += points;
    _playerData.currentScore += points;
    _playerData.save();
  }

  void increaseHealthBy(int points) {
    _health += points;
    if (_health > 100 ) {
      _health = 100;
    }
  }

  void reset() {
    _playerData.currentScore = 0;
    _health = 100;
    position = gameRef.canvasSize / 2;
  }

  void setSpaceshipType(SpaceshipType spaceshipType) {
    this.spaceshipType = spaceshipType;
    _spaceship = Spaceship.getSpaceshipByType(spaceshipType);
    sprite = gameRef.spriteSheet.getSpriteById(_spaceship.spriteId);
  }

  void shootMultipleBullets(){
    _shootMultipleBullets = true;
    _powerUpTimer.stop();
    _powerUpTimer.start();
  }
}