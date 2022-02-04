import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:space_adventure/game/bullet.dart';
import 'package:space_adventure/game/command.dart';
import 'package:space_adventure/game/game.dart';
import 'package:space_adventure/game/player.dart';
import 'package:space_adventure/models/enemy_data.dart';

class Enemy extends SpriteComponent with HasGameRef<SpaceAdventure>, Hitbox, Collidable{
  
  double _speed = 250; 

  Vector2 moveDirection = Vector2(0,1);

  late Timer _freezeTimer;

  final EnemyData enemyData;

  int _hitPoints = 10;
  final TextComponent _hpText = TextComponent('10 HP',
  textRenderer: TextPaint(
      config: const TextPaintConfig(
        color: Colors.white,
        fontSize: 12,
        fontFamily: 'BungeeInline',
      ),
    ),);

  final Random _random = Random();
  Vector2 getRandomVector() {
    return (Vector2.random(_random)- Vector2.random(_random)) * 300;
  }

  Vector2 getRandomDirection(){
    return (Vector2.random(_random) - Vector2(0.5,-1)).normalized();
  }

  Enemy({
    required Sprite? sprite,
    required this.enemyData,
    required Vector2? position,
    required Vector2? size, 
  }): super(sprite: sprite, position: position, size: size){

    _speed = enemyData.speed;
    _hitPoints = enemyData.level * 10;
    _hpText.text = '$_hitPoints HP';

    _freezeTimer = Timer(2, callback: () {
      _speed = enemyData.speed;
    });

    if(enemyData.hMove){
      moveDirection = getRandomDirection();
    }
  }

  @override
  void onMount() {
    super.onMount();

    final shape = HitboxCircle(definition: 0.6);
    addShape(shape);

   _hpText.position = Vector2(15,-10);
    addChild(_hpText);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    if(other is Bullet) {
      _hitPoints -= other.level * 10;
    } else if(other is Player) {
      _hitPoints = 0;
    }
  }

  void destroy() {
      remove();
    
    final command = Command<Player>(action: (player){
      player.addToScore(enemyData.killPoint);
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
    _hpText.text = '$_hitPoints HP';
    if(_hitPoints <= 0){
      destroy();
    }

    _freezeTimer.update(dt);

    position += moveDirection * _speed * dt;

    if(position.y > gameRef.size.y) {
      remove();
    } else if((position.x < size.x /2) || position.x > (gameRef.canvasSize.x - size.x /2)){
      moveDirection.x *= -1;
    }
  }

  void freeze() {
    _speed = 0;
    _freezeTimer.stop();
    _freezeTimer.start();
  }
}