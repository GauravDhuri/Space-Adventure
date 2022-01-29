import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:space_adventure/game/enemy_manager.dart';
import 'package:space_adventure/game/player.dart';

class SpaceAdventure extends FlameGame with PanDetector {

  late Player player;
  Offset? _pointerStartPosition;
  Offset? _pointerCurrentPosition;
  final double _deadZoneRadius = 10;
 
  @override
  Future<void> onLoad() async {
    await images.load('spaceShooter.png');

    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: images.fromCache('spaceShooter.png'),
      columns: 2,
      rows: 2);
      
      player = Player(
        sprite: spriteSheet.getSpriteById(3),
        size: Vector2(64,64),
        position: canvasSize /2
      );

      player.anchor = Anchor.center;
      add(player);

      EnemyManger enemyManger = EnemyManger(spriteSheet: spriteSheet);
      add(enemyManger);
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
}