import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:space_adventure/game/enemy.dart';
import 'package:space_adventure/game/enemy_manager.dart';
import 'package:space_adventure/game/player.dart';

import 'bullet.dart';

class SpaceAdventure extends FlameGame with PanDetector, TapDetector {

  late Player player;
  late SpriteSheet _spriteSheet;
  late EnemyManger _enemyManger;
  Offset? _pointerStartPosition;
  Offset? _pointerCurrentPosition;
  final double _deadZoneRadius = 10;
 
  @override
  Future<void> onLoad() async {
    await images.load('spaceShooter.png');

    _spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: images.fromCache('spaceShooter.png'),
      columns: 5,
      rows: 1);
      
      player = Player(
        sprite: _spriteSheet.getSpriteById(3),
        size: Vector2(64,64),
        position: canvasSize /2
      );

      player.anchor = Anchor.center;
      add(player);

      _enemyManger = EnemyManger(spriteSheet: _spriteSheet);
      add(_enemyManger);
  }

  @override
    void render(Canvas canvas){
      super.render(canvas);

      if(_pointerStartPosition !=null){
        canvas.drawCircle(
          _pointerStartPosition!,
          60,
          Paint()..color = Colors.grey.withAlpha(100));
      }

      if(_pointerCurrentPosition !=null){
        var delta = _pointerCurrentPosition! - _pointerStartPosition!;
        if(delta.distance > 60){
          delta = _pointerStartPosition! 
          + (Vector2(delta.dx,delta.dy).normalized() * 60).toOffset();
        } else {
          delta = _pointerCurrentPosition!;
        }

        canvas.drawCircle(
          _pointerCurrentPosition!,
          20,
          Paint()..color = Colors.white.withAlpha(100));
      }
    }

  @override
  void update(double dt) {
    super.update(dt);

    final bullets = children.whereType<Bullet>();

    for(final enemy in _enemyManger.children.whereType<Enemy>()){
      if(enemy.shouldRemove){
        continue;
      }
      for(final bullet in bullets){
        if(bullet.shouldRemove){
          continue;
        }
        if(enemy.containsPoint(bullet.absoluteCenter)) {
          enemy.removeFromParent();
          bullet.removeFromParent();
          break;
        }
      }
    }
  }

  @override
  void onPanStart(DragStartInfo info) {
    _pointerStartPosition = info.eventPosition.global.toOffset();
    _pointerCurrentPosition = info.eventPosition.global.toOffset();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _pointerCurrentPosition = info.eventPosition.global.toOffset();

    var delta = _pointerCurrentPosition! - _pointerStartPosition!;
    if(delta.distance > _deadZoneRadius) {
      player.setMoveDreciton(Vector2(delta.dx,delta.dy));
    } else {
      player.setMoveDreciton(Vector2.zero());
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    _pointerStartPosition = null;
    _pointerCurrentPosition = null;
    player.setMoveDreciton(Vector2.zero());
  }

  @override
  void onPanCancel() {
    _pointerStartPosition = null;
    _pointerCurrentPosition = null;
    player.setMoveDreciton(Vector2.zero());
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);

    Bullet bullet = Bullet(
       sprite: _spriteSheet.getSpriteById(0),
        size: Vector2(64,64),
        position: player.position
    );

    bullet.anchor = Anchor.center;
    add(bullet);
  }
}