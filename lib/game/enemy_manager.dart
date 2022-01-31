import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:space_adventure/game/enemy.dart';

class EnemyManger extends Component with HasGameRef {
  late Timer _timer;
  SpriteSheet spriteSheet;
  Random random = Random();

  EnemyManger({required this.spriteSheet}) : super() {
    _timer = Timer(
      1,
      onTick: () => _spawnEnemy(),
      repeat: true,
      autoStart: true
    );
  }

  void _spawnEnemy() {
    Vector2 initialSize = Vector2(64,64);
    Vector2 position = Vector2(random.nextDouble() * gameRef.size.x, 0);

    position.clamp(
      Vector2.zero() + initialSize/2,
      gameRef.canvasSize - initialSize /2 
    );

    Enemy enemy = Enemy(
      sprite: spriteSheet.getSpriteById(1),
      size: initialSize,
      position: position
    );
    enemy.anchor = Anchor.center;
    gameRef.add(enemy);
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  } 

  @override
  void onRemove() {
    super.onRemove();
    _timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
  }

  void reset() {
    _timer.stop();
    _timer.start();
  }
}