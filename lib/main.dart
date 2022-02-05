import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:space_adventure/models/player_data.dart';
import 'package:space_adventure/models/settings.dart';
import 'package:space_adventure/models/spaceship_details.dart';
import 'package:space_adventure/screens/main_menu.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();

  await initHive();

  runApp(
    MultiProvider(
      providers: [
        FutureProvider<PlayerData>(
        create: (BuildContext context) => getPlayerData(),
        initialData: PlayerData.fromMap(PlayerData.defaultData),
        ),
        FutureProvider<Settings>(
        create: (BuildContext context) => getSettings(),
        initialData: Settings(soundEffects: false, backgroundMusic: false),
        ),
      ],
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<PlayerData>.value(
              value: Provider.of<PlayerData>(context),
            ),
            ChangeNotifierProvider<Settings>.value(
              value: Provider.of<Settings>(context),
            ),
          ],
          child: child
        );
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'BungeeInline',
          scaffoldBackgroundColor: Colors.black),
        home: const MainMenu(),
      ),
    ),
  );
}

Future<void> initHive() async {
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter(PlayerDataAdapter());
  Hive.registerAdapter(SpaceshipTypeAdapter());
  Hive.registerAdapter(SettingsAdapter());
}

Future<PlayerData> getPlayerData() async {

  final box = await Hive.openBox<PlayerData>(PlayerData.playerDataBox);
  final playerData = box.get(PlayerData.playerDataKey);
  if(playerData == null){
    box.put(PlayerData.playerDataKey, PlayerData.fromMap(PlayerData.defaultData));
  }
  return box.get(PlayerData.playerDataKey)!;
}

Future<Settings> getSettings() async {
  final box = await Hive.openBox<Settings>(Settings.settingsBox);
  final settings = box.get(Settings.settingsKey);
  if(settings == null){
    box.put(Settings.settingsKey, Settings(soundEffects: true, backgroundMusic: true));
  }
  return box.get(Settings.settingsKey)!;
}
