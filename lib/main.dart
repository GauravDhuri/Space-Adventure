import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:space_adventure/models/player_data.dart';
import 'package:space_adventure/models/spaceship_details.dart';
import 'package:space_adventure/screens/main_menu.dart';
import 'package:provider/provider.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();

  runApp(
    FutureProvider<PlayerData>(
      create: (BuildContext context) => getPlayerData(),
      initialData: PlayerData.fromMap(PlayerData.defaultData),
      builder: (context, child){
        return ChangeNotifierProvider<PlayerData>.value(
          value: Provider.of<PlayerData>(context),
          child: child,
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
    )
  );
}

Future<void> initHive() async {
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter(PlayerDataAdapter());
  Hive.registerAdapter(SpaceshipTypeAdapter());
}

Future<PlayerData> getPlayerData() async {

  await initHive();

  final box = await Hive.openBox<PlayerData>('PlayerDataBox');
  final playerData = box.get('PlayerData');
  if(playerData == null){
    box.put('PlayerData', PlayerData.fromMap(PlayerData.defaultData));
  }
  return box.get('PlayerData')!;
}
