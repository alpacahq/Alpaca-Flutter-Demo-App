// Main with routing

import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/dashboard.dart';
import 'package:url_strategy/url_strategy.dart';

const loginRoute = '/';
const dashboardRoute = '/dashboard';

void main() {
  setPathUrlStrategy(); // Removes /#/ from the URL
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(onGenerateRoute: _routes(), theme: _theme());
  }

  RouteFactory _routes() {
    return (settings) {
      final args = settings.arguments;
      final Map<String, dynamic> arguments = args as Map<String, dynamic>;
      Widget screen;
      switch (settings.name) {
        case loginRoute:
          screen = const LoginPage(title: "Log in with Alpaca");
          break;
        case dashboardRoute:
          screen = const Dashboard();
          break;
        default:
          return null;
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }

  ThemeData _theme() {
    return ThemeData(
      primarySwatch: Colors.yellow,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
