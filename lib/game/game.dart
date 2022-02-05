import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:space_adventure/game/audio_player_component.dart';
import 'package:space_adventure/game/bullet.dart';
import 'package:space_adventure/game/command.dart';
import 'package:space_adventure/game/enemy_manager.dart';
import 'package:space_adventure/game/player.dart';
import 'package:space_adventure/game/power_up_manager.dart';
import 'package:space_adventure/game/power_ups.dart';
import 'package:space_adventure/models/player_data.dart';
import 'package:space_adventure/models/spaceship_details.dart';
import 'package:space_adventure/screens/overlays/game_over_menu.dart';
import 'package:space_adventure/screens/overlays/pause_button.dart';
import 'package:space_adventure/screens/overlays/pause_menu.dart';

import 'enemy.dart';

class SpaceAdventure extends BaseGame with HasCollidables, HasDraggableComponents {

  late Player _player;
  late SpriteSheet spriteSheet;
  late EnemyManger _enemyManger;
  late PowerUpManager _powerUpManager;

  late TextComponent _playerScore;
  late TextComponent _playerHealth;

  late AudioPlayerComponent _audioPlayerComponent;

  final _commandList = List<Command>.empty(growable: true);
  final _addLaterCommandList = List<Command>.empty(growable: true);

  bool _isAlreadyLoaded = false;

  // Offset? _pointerStartPosition;
  // Offset? _pointerCurrentPosition;
  // final double _deadZoneRadius = 10;
 
  @override
  Future<void> onLoad() async {
    if(!_isAlreadyLoaded){
      await images.loadAll([
        'Space_Adventure.png',
        'Health.png',
        'Double_Fire.png',
        'Thunder_strike.png',
        'Freeze.png',
        'Double_Fire.png'
      ]);

      _audioPlayerComponent = AudioPlayerComponent();
      add(_audioPlayerComponent);

      spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: images.fromCache('Space_Adventure.png'),
      columns: 4,
      rows: 4);

      const spaceType = SpaceshipType.blurryFace;
      final spaceShip = Spaceship.getSpaceshipByType(spaceType);
      
      _player = Player(
        spaceshipType: spaceType,
        sprite: spriteSheet.getSpriteById(spaceShip.spriteId),
        size: Vector2(64,64),
        position: canvasSize /2
      );
      
      _player.anchor = Anchor.center;
      add(_player);
      
      _enemyManger = EnemyManger(spriteSheet: spriteSheet);
      add(_enemyManger);

      _powerUpManager = PowerUpManager();
      add(_powerUpManager);

       final joystick = JoystickComponent(
        gameRef: this,
        directional: JoystickDirectional(
          size: 100,
        ),
        actions: [
          JoystickAction(
            actionId: 0,
            size: 80,
            margin: const EdgeInsets.all(
              60,
            ),
          ),
        ],
      );

      // Make sure to add player as an observer of this joystick.
      joystick.addObserver(_player);
      add(joystick);

    _playerScore = TextComponent(
        'Score: 0',
        position: Vector2(10, 10),
        textRenderer: TextPaint(
          config: const TextPaintConfig(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'BungeeInline',
          ),
        ),
      );
      _playerScore.isHud = true;
      add(_playerScore);
      
     _playerHealth = TextComponent(
        'Health: 100%',
        position: Vector2(size.x - 10, 10),
        textRenderer: TextPaint(
          config: const TextPaintConfig(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'BungeeInline',
          ),
        ),
      );
      _playerHealth.isHud = true;
      _playerHealth.anchor = Anchor.topRight;
      add(_playerHealth);

      camera.defaultShakeIntensity = 20;
    }
    _isAlreadyLoaded = true;
  }

  @override
  void onAttach() {
    if(buildContext != null){
      final playerData = Provider.of<PlayerData>(buildContext!,listen: false);
      _player.setSpaceshipType(playerData.spaceshipType);
    }
    _audioPlayerComponent.playBgm('SpaceAdventureBGM.ogg');
    super.onAttach();
  }

  @override
  void onDetach() {
    _audioPlayerComponent.stopBgm();
    super.onDetach();
  }

  @override
    void render(Canvas canvas){

      // if(_pointerStartPosition !=null){
      //   canvas.drawCircle(
      //     _pointerStartPosition!,
      //     60,
      //     Paint()..color = Colors.grey.withAlpha(100));
      // }

      // if(_pointerCurrentPosition !=null) {
      //   var delta = _pointerCurrentPosition! - _pointerStartPosition!;
      //   if(delta.distance > 60){
      //     delta = _pointerStartPosition! + (Vector2(delta.dx,delta.dy).normalized() * 60).toOffset();
      //   } else {
      //     delta = _pointerCurrentPosition!;
      //   }

      //   canvas.drawCircle(
      //     delta,
      //     20,
      //     Paint()..color = Colors.white.withAlpha(100));
      // }

      canvas.drawRect(
        Rect.fromLTWH(
          size.x - 110, 10, _player.health.toDouble(),
          20
        ),
        Paint()..color = Colors.green,
      );
      super.render(canvas);
    }

    void addCommand(Command command){
      _addLaterCommandList.add(command);
    }

    void reset() {
      _player.reset();
      _enemyManger.reset();
      _powerUpManager.reset();

     components.whereType<Enemy>().forEach((enemy) {
      enemy.remove();
    });

    components.whereType<Bullet>().forEach((bullet) {
      bullet.remove();
    });

    components.whereType<PowerUp>().forEach((powerUp) {
      powerUp.remove();
    });
    }

  @override
  void update(double dt) {
    super.update(dt);

    _commandList.forEach((commad) {
      components.forEach((element) {
        commad.run(element);
      });
    });

    _commandList.clear();
    _commandList.addAll(_addLaterCommandList);
    _addLaterCommandList.clear();

    _playerScore.text = 'Score: ${_player.score}';
    _playerHealth.text = 'Health: ${_player.health} %';

    if(_player.health <= 0 && (!camera.shaking)){
      pauseEngine();
      overlays.remove(PauseButton.id);
      overlays.add(GameOverMenu.id);
    }
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {

    switch(state){
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if(_player.health > 0 ){
          pauseEngine();
          overlays.remove(PauseButton.id);
          overlays.add(PauseMenu.id);
        }
        break;
    }
    super.lifecycleStateChange(state);
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

  // Navtive Tap Controls 
  // @override
  // void onPanStart(DragStartInfo info) {
  //   _pointerStartPosition = info.eventPosition.global.toOffset();
  //   _pointerCurrentPosition = info.eventPosition.global.toOffset();
  // }

  // @override
  // void onPanUpdate(DragUpdateInfo info) {
  //   _pointerCurrentPosition = info.eventPosition.global.toOffset();

  //   var delta = _pointerCurrentPosition! - _pointerStartPosition!;
  //   if(delta.distance > _deadZoneRadius) {
  //     _player.setMoveDreciton(Vector2(delta.dx,delta.dy));
  //   } else {
  //     _player.setMoveDreciton(Vector2.zero());
  //   }
  // }

  // @override
  // void onPanEnd(DragEndInfo info) {
  //   _pointerStartPosition = null;
  //   _pointerCurrentPosition = null;
  //   _player.setMoveDreciton(Vector2.zero());
  // }

  // @override
  // void onPanCancel() {
  //   _pointerStartPosition = null;
  //   _pointerCurrentPosition = null;
  //   _player.setMoveDreciton(Vector2.zero());
  // }

  // @override
  // void onTapDown(TapDownInfo info) {
  //   super.onTapDown(info);
  //   Bullet bullet = Bullet(
  //      sprite: spriteSheet.getSpriteById(8),
  //       size: Vector2(64,64),
  //       position: _player.position.clone()
  //   );

  //   bullet.anchor = Anchor.center;
  //   add(bullet);
  // }
}