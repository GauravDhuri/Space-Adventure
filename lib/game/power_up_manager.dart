import 'dart:math';
import 'package:flame/components.dart';
import 'package:space_adventure/game/game.dart';
import 'package:space_adventure/game/power_ups.dart';

enum PowerUpTypes {health, nuke, freeze, multifire}

class PowerUpManager extends Component with HasGameRef<SpaceAdventure> {
  late Timer _spawnTimer;
  late Timer _freezeTimer;
  
  Random random = Random();

  static late Sprite healthSprite;
  static late Sprite nukeSprite;
  static late Sprite freezeSprite;
  static late Sprite multifire;

  static final Map<PowerUpTypes, PowerUp Function(Vector2 position, Vector2 size)>
  _powerUpMap = {
  PowerUpTypes.health : (position, size) => Health(
    position:  position,
    size: size,
  ),
  PowerUpTypes.nuke : (position, size) => Nuke(
    position:  position,
    size: size,
  ),
  PowerUpTypes.freeze : (position, size) => Freeze(
    position:  position,
    size: size,
  ),
  PowerUpTypes.multifire : (position, size) => MultiFire(
    position:  position,
    size: size,
  ),
};

  PowerUpManager() : super() {
    _spawnTimer = Timer(
      8,
      callback: () => _spwanPowerUp(),
      repeat: true,
    );
    _freezeTimer = Timer(
      2,
      callback: () => _spawnTimer.start(),
    ); 
  }

  void _spwanPowerUp() {
    Vector2 initialSize = Vector2(84,84);
    Vector2 position = Vector2(
      random.nextDouble() * gameRef.size.x,
      random.nextDouble() * gameRef.size.y
    );

    position.clamp(
      Vector2.zero() + initialSize/2,
      gameRef.canvasSize - initialSize /2 
    );

    int randomIndex = random.nextInt(PowerUpTypes.values.length);
    final fn = _powerUpMap[PowerUpTypes.values.elementAt(randomIndex)];

    var powerUp = fn?.call(position, initialSize);

    powerUp?.anchor = Anchor.center;

    if(powerUp != null){
      gameRef.add(powerUp);
    }
  }

  @override
  void onMount() {
    super.onMount();
    _spawnTimer.start();

    nukeSprite = Sprite(gameRef.images.fromCache('Thunder_strike.png'));
    healthSprite = Sprite(gameRef.images.fromCache('Health.png'));
    freezeSprite = Sprite(gameRef.images.fromCache('Freeze.png'));
    multifire = Sprite(gameRef.images.fromCache('Double_Fire.png'));
  } 

  @override
  void onRemove() {
    super.onRemove();
    _spawnTimer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _spawnTimer.update(dt);
    _freezeTimer.update(dt);
  }

  void reset() {
    _spawnTimer.stop();
    _spawnTimer.start();
  }

  void freeze() {
     _spawnTimer.stop();
    _freezeTimer.stop();
    _freezeTimer.start();
  }
}