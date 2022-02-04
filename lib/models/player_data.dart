import 'package:flutter/material.dart';
import 'package:space_adventure/models/spaceship_details.dart';

class PlayerData extends ChangeNotifier {
  SpaceshipType spaceshipType;
  final List<SpaceshipType> ownedSpaceships;
  final int highScore;
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
    'currentSpaceshipType' : SpaceshipType.eureka,
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
    }
  }

  void equip(SpaceshipType spaceshipType) {
    this.spaceshipType = spaceshipType;
    notifyListeners();
  }
}