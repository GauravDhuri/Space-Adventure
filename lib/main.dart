import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:space_adventure/screens/main_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  runApp(
   MaterialApp(
     themeMode: ThemeMode.dark,
     darkTheme: ThemeData.dark().copyWith(
       textTheme: GoogleFonts.bungeeInlineTextTheme(),
       scaffoldBackgroundColor: Colors.black,
     ),
     home: const MainMenu(),
   )
  );
}


