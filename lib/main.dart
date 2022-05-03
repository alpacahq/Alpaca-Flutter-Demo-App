import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/dashboard.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const loginRoute = '/';
const dashboardRoute = '/dashboard';

Future<void> main() async {
  setPathUrlStrategy(); // Removes /#/ from the URL
  await dotenv.load();
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
      // final args = settings.arguments;
      // final Map<String, dynamic> arguments = args as Map<String, dynamic>;
      // final Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
      Widget screen;
      // TODO: Implement a redirect route that will pass the code paramter back
      // to the parent window: https://pub.dev/packages/oauth2_client#web
      switch (settings.name) {
        case loginRoute:
          screen = LoginPage(title: "Log in with Alpaca");
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
