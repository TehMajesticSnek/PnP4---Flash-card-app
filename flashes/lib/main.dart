import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flashes/card_sets.dart';
import 'package:flashes/database_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //DatabaseHandler.debug();
  DatabaseHandler.databaseInstance = await DatabaseHandler.create();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashes',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: OpenUpwardsPageTransitionsBuilder()
          }
        )
      ),
      home: const SetsScreen(),
    );
  }
}