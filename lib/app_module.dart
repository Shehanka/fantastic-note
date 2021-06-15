import 'package:fantastic_note/screens/login_screen/login_screen.dart';
import 'package:fantastic_note/screens/login_screen/signup_screen.dart';
import 'package:fantastic_note/screens/splash_screen/splash_screen.dart';
import 'package:fantastic_note/screens/welcome_screen/welcome_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => SplashScreen()),
    ChildRoute('/welcome', child: (_, args) => WelcomeScreen()),
    ChildRoute('/login', child: (_, args) => LoginScreen()),
    ChildRoute('/signup', child: (_, args) => SignUpScreen()),
  ];
}
