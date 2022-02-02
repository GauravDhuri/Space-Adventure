import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:space_adventure/models/player_data.dart';
import 'package:space_adventure/screens/main_menu.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  runApp(ChangeNotifierProvider(
    create: (context) => PlayerData.fromMap(PlayerData.defaultData),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'BungeeInline',
          scaffoldBackgroundColor: Colors.black),
      home: const MainMenu(),
    ),
  ));
}
