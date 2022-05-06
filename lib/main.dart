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
  // This widget is the root of your application.

  void listen(Event event) {
    var data = (event as MessageEvent).data;
    print(
        "Message event received, data is: $data"); // Successfully got the code
    //setState(() {})
  }

  @override
  Widget build(BuildContext context) {
    window.addEventListener("message", listen, true);
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
          // TODO:
          // Grab the code from the URL and send it back to original
          // Push this window to an auth complete screen, prompt user to close
          print("In default case");
          String? code = Uri.base.queryParameters['code'];
          print('Auth code is $code');
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
