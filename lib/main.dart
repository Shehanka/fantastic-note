import 'package:fantastic_note/app_module.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ModularApp(module: AppModule(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  // await Firebase.initializeApp();
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
