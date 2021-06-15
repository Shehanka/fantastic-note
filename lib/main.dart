import 'package:fantastic_note/app_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

Future<void> main() async {
  runApp(ModularApp(module: AppModule(), child: MyApp()));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fantastic Note',
      theme: ThemeData(
          primaryColor: new Color(0xff622F74), accentColor: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
    ).modular();
  }
}
