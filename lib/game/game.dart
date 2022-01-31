import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:space_adventure/game/bullet.dart';
import 'package:space_adventure/game/command.dart';
import 'package:space_adventure/game/enemy_manager.dart';
import 'package:space_adventure/game/player.dart';

import 'enemy.dart';

class SpaceAdventure extends FlameGame with  PanDetector, TapDetector, HasCollidables {

  late Player _player;
  late SpriteSheet _spriteSheet;
  late EnemyManger _enemyManger;

  late TextComponent _playerScore;
  late TextComponent _playerHealth;

  final _commandList = List<Command>.empty(growable: true);
  final _addLaterCommandList = List<Command>.empty(growable: true);

  bool _isAlreadyLoaded = false;

  Offset? _pointerStartPosition;
  Offset? _pointerCurrentPosition;
  final double _deadZoneRadius = 10;
 
  @override
  Future<void> onLoad() async {
    if(!_isAlreadyLoaded){
      await images.load('spaceShooter.png');

    _spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: images.fromCache('spaceShooter.png'),
      columns: 5,
      rows: 1);
      
      _player = Player(
        sprite: _spriteSheet.getSpriteById(3),
        size: Vector2(64,64),
        position: canvasSize /2
      );

      _player.anchor = Anchor.center;
      add(_player);
      
      _enemyManger = EnemyManger(spriteSheet: _spriteSheet);
      add(_enemyManger);

      _playerScore = TextComponent(
        text: 'Score: 0',
        position: Vector2(10,10),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16
          )
        )
      );

      add(_playerScore);
      
      _playerHealth = TextComponent(
        text: 'Healthe: 100%',
        position: Vector2(size.x-10,10),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16
          )
        )
      );

      _playerHealth.anchor = Anchor.topRight;
      add(_playerHealth);

      camera.defaultShakeIntensity = 20;
    }
    _isAlreadyLoaded = true;
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

      if(_pointerCurrentPosition !=null) {
        var delta = _pointerCurrentPosition! - _pointerStartPosition!;
        if(delta.distance > 60){
          delta = _pointerStartPosition! + (Vector2(delta.dx,delta.dy).normalized() * 60).toOffset();
        } else {
          delta = _pointerCurrentPosition!;
        }

        canvas.drawCircle(
          delta,
          20,
          Paint()..color = Colors.white.withAlpha(100));
      }

      canvas.drawRect(
        Rect.fromLTWH(
          size.x - 110, 10, _player.health.toDouble(),
          20
        ),
        Paint()..color = Colors.blue,
      );
    }

    void addCommand(Command command){
      _addLaterCommandList.add(command);
    }

    void reset() {
      _player.reset();
      _enemyManger.reset();

      children.whereType<Enemy>().forEach((enemy) {
        enemy.removeFromParent();
      });

      children.whereType<Bullet>().forEach((bullet) {
        bullet.removeFromParent();
      });
    }

  @override
  void update(double dt) {
    super.update(dt);

    _commandList.forEach((commad) {
      children.forEach((element) {
        commad.run(element);
      });
    });

    _commandList.clear();
    _commandList.addAll(_addLaterCommandList);
    _addLaterCommandList.clear();

    _playerScore.text = 'Score: ${_player.score}';
    _playerHealth.text = 'Health: ${_player.health}';
  }

  // old code better to use Hitbox and Colliable mixins provided in latest flame engine
  // @override
  // void update(double dt) {
  //   super.update(dt);

  //   final bullets = children.whereType<Bullet>();

  //   for(final enemy in _enemyManger.children.whereType<Enemy>()){
  //     if(enemy.shouldRemove){
  //       continue;
  //     }
  //     for(final bullet in bullets){
  //       if(bullet.shouldRemove){
  //         continue;
  //       }
  //       if(enemy.containsPoint(bullet.absoluteCenter)) {
  //         enemy.removeFromParent();
  //         bullet.removeFromParent();
  //         break;
  //       }
  //     }

  //     if(player.containsPoint(enemy.absoluteCenter)) {
  //       print("Enemy hit the player");
  //     }
  //   }
  // }

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
      _player.setMoveDreciton(Vector2(delta.dx,delta.dy));
    } else {
      _player.setMoveDreciton(Vector2.zero());
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    _pointerStartPosition = null;
    _pointerCurrentPosition = null;
    _player.setMoveDreciton(Vector2.zero());
  }

  @override
  void onPanCancel() {
    _pointerStartPosition = null;
    _pointerCurrentPosition = null;
    _player.setMoveDreciton(Vector2.zero());
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
        position: _player.position
    );

    bullet.anchor = Anchor.center;
    add(bullet);
  }
}