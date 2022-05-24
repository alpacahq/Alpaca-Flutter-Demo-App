import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/dashboard.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:html';

const loginRoute = '/';
const dashboardRoute = '/dashboard';

Future<void> main() async {
  setPathUrlStrategy(); // Removes /#/ from the URL
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(onGenerateRoute: _routes(), theme: _theme());
  }

  RouteFactory _routes() {
    return (settings) {
      Widget screen;
      switch (settings.name) {
        case loginRoute:
          screen = LoginPage(title: "Log in with Alpaca");
          break;
        case dashboardRoute:
          screen = const Dashboard();
          break;
        default:
          String? code = Uri.base.queryParameters['code'];
          // This code tells the pop-up auth window to send the code to parent
          if (window.opener != null && code != null) {
            window.opener!.postMessage(window.location.href, "http://localhost:3000");
          }
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
