import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:space_adventure/models/spaceship_details.dart';

part 'player_data.g.dart';

@HiveType(typeId: 0)
class PlayerData extends ChangeNotifier with HiveObjectMixin {

  static const String playerDataBox = 'PlayerDataBox';
  static const String playerDataKey = 'PlayerData';

  @HiveField(0)
  SpaceshipType spaceshipType;

  @HiveField(1)
  final List<SpaceshipType> ownedSpaceships;

  @HiveField(2)
  final int highScore;
  
  @HiveField(3)
  int money;

  int currentScore = 0;

  PlayerData({
    required this.spaceshipType,
    required this.ownedSpaceships,
    required this.highScore, 
    required this.money
  });

  PlayerData.fromMap(Map<String, dynamic> map): spaceshipType = map['currentSpaceshipType'],ownedSpaceships = map['ownedspaceshipTypes'].map((e) => e as SpaceshipType).cast<SpaceshipType>().toList(),
  highScore = map['highScore'],
  money = map['money'];

  static Map<String, dynamic> defaultData = {
    'currentSpaceshipType' : SpaceshipType.blurryFace,
    'ownedspaceshipTypes': [],
    'highScore': 0,
    'money': 0,
  };

  bool isOwned(SpaceshipType spaceshipType) {
    return ownedSpaceships.contains(spaceshipType);
  }

  bool canBuy(SpaceshipType spaceshipType) {
    return money >= Spaceship.getSpaceshipByType(spaceshipType).cost;
  }

  bool isEquipped(SpaceshipType spaceshipType) {
    return (this.spaceshipType == spaceshipType);
  }

  void buy(SpaceshipType spaceshipType) {
    if(canBuy(spaceshipType) && (!isOwned(spaceshipType))){
      money -= Spaceship.getSpaceshipByType(spaceshipType).cost;
      ownedSpaceships.add(spaceshipType);
      notifyListeners();
      save();
    }
  }

  void equip(SpaceshipType spaceshipType) {
    this.spaceshipType = spaceshipType;
    notifyListeners();
    save();
  }
}