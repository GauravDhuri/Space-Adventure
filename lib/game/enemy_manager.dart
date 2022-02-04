import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:provider/provider.dart';
import 'package:space_adventure/game/enemy.dart';
import 'package:space_adventure/game/game.dart';
import 'package:space_adventure/models/enemy_data.dart';
import 'package:space_adventure/models/player_data.dart';

class EnemyManger extends Component with HasGameRef<SpaceAdventure> {
  late Timer _timer;
  late Timer _freezeTimer;
  SpriteSheet spriteSheet;
  Random random = Random();

  EnemyManger({required this.spriteSheet}) : super() {
    _timer = Timer(
      1,
      callback: () => _spawnEnemy(),
      repeat: true,
    );
    _freezeTimer = Timer(
      2,
      callback: () => _timer.start(),
    );
  }

  void _spawnEnemy() {
    Vector2 initialSize = Vector2(64,64);
    Vector2 position = Vector2(random.nextDouble() * gameRef.size.x, 0);

    position.clamp(
      Vector2.zero() + initialSize/2,
      gameRef.canvasSize - initialSize /2 
    );

    if(gameRef.buildContext != null) {
      int currentScore = Provider.of<PlayerData>(gameRef.buildContext!, listen: false).currentScore;
      int maxLevel = mapScoreToMaxEnemyLevel(currentScore);

      final enemyData = _enemyDataList.elementAt(random.nextInt(maxLevel + 1));

      Enemy enemy = Enemy(
        sprite: spriteSheet.getSpriteById(enemyData.spriteId),
        size: initialSize,
        position: position,
        enemyData: enemyData,
      );
        enemy.anchor = Anchor.center;
        gameRef.add(enemy);
    }   
  }

  int mapScoreToMaxEnemyLevel(int score) {
    int level = 0;
    if(score> 200) {
      level = 4;
    } else if(score > 150) {
      level = 3;
    } else if (score > 100) {
      level = 2;
    } else if (score > 50) {
      level = 1;
    }

    return level;
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
    _freezeTimer.update(dt);
  }

  void reset() {
    _timer.stop();
    _timer.start();
  }

  void freeze() {
    _timer.stop();
    _freezeTimer.stop();
    _freezeTimer.start();
  }

  static const List<EnemyData> _enemyDataList = [
    EnemyData(
      killPoint: 1,
      speed: 200,
      spriteId: 3,
      level: 1,
      hMove: false,
    ),
    EnemyData(
      killPoint: 6,
      speed: 250,
      spriteId: 7,
      level: 2,
      hMove: false,
    ),
    EnemyData(
      killPoint: 10,
      speed: 350,
      spriteId: 11,
      level: 3,
      hMove: false,
    ),
    EnemyData(
      killPoint: 10,
      speed: 400,
      spriteId: 0,
      level: 4,
      hMove: true,
    ),
    EnemyData(
      killPoint: 50,
      speed: 250,
      spriteId: 12,
      level: 4,
      hMove: true,
    )
  ];
}