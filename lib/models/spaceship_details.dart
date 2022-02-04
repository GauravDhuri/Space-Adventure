import 'package:hive/hive.dart';

part 'spaceship_details.g.dart';

class Spaceship {
  final String name;
  final int cost;
  final double speed;
  final int spriteId;
  final String assetPath;
  final int level;

  const Spaceship({
    required this.name, 
    required this.cost, 
    required this.speed, 
    required this.spriteId, 
    required this.assetPath, 
    required this.level
  });

  static Spaceship getSpaceshipByType(SpaceshipType spaceshipType) {
    return spaceships[spaceshipType] ?? spaceships.entries.first.value;
  }

  static const Map<SpaceshipType, Spaceship> spaceships = {
    SpaceshipType.blurryFace: Spaceship(
      name: 'Blurry Face',
      cost: 0,
      speed: 250,
      spriteId: 4,
      assetPath: 'assets/images/Space_ship_1.png',
      level: 1
    ),
    SpaceshipType.squanceInPeace: Spaceship(
      name: 'Squanch In Peace',
      cost: 500,
      speed: 300,
      spriteId: 5,
      assetPath: 'assets/images/Space_ship_2.png',
      level: 2
    ),
    SpaceshipType.anigma: Spaceship(
      name: 'Enigma',
      cost: 1000,
      speed: 450,
      spriteId: 2,
      assetPath: 'assets/images/Space_ship_3.png',
      level: 4
    ),
  };
}

@HiveType(typeId: 1)
enum SpaceshipType {

  @HiveField(0)
  blurryFace,

  @HiveField(1)
  squanceInPeace,

  @HiveField(2)
  anigma
}