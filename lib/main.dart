import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:round2/Home/Home.dart';
import 'package:round2/Introduction/introduction_animation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamily: 'Avenir'),
    initialRoute: 'intro',
    routes: {
      'intro': (context) => const IntroductionAnimationScreen(),
      'home': (context) => const HomePage()
    },
  ));
}
