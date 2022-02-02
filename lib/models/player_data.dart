import 'package:flutter/material.dart';
import 'package:space_adventure/models/spaceship_details.dart';

class PlayerData extends ChangeNotifier {
  final SpaceshipType spaceshipType;
  final List<SpaceshipType> ownedSpaceships;
  final int highScore;
  final int money;

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
}