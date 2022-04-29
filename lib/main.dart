import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:url_strategy/url_strategy.dart';
// Helper and client for Oauth2_client
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:http/http.dart' as http;

void main() {
  setPathUrlStrategy(); // Removes /#/ from the URl
  runApp(const MyApp());
}

Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

// Get these from .env or .json later
const clientId = "";
const clientSecret = "";

class AlpacaClient extends OAuth2Client {
  AlpacaClient({required String redirectUri, required String customUriScheme})
      : super(
            authorizeUrl:
                'https://app.alpaca.markets/oauth/authorize?response_type=code&client_id=$clientId&redirect_uri=$redirectUri&scope=account:write%20trading%20data', //Your service's authorization url
            tokenUrl:
                'https://api.alpaca.markets/oauth/token', //Your service access token url
            redirectUri: redirectUri,
            customUriScheme: customUriScheme);
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.lightBlue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

AlpacaClient instantiateClient() {
  AlpacaClient client = AlpacaClient(
      redirectUri: "http://localhost:3000/",
      customUriScheme: "http://localhost:3000/");
  return client;
}

OAuth2Helper instantiateHelper(AlpacaClient client) {
  OAuth2Helper oauth2Helper = OAuth2Helper(client,
      grantType: OAuth2Helper.AUTHORIZATION_CODE,
      clientId: clientId,
      clientSecret: clientSecret,
      scopes: ['account:write trading data']);
  return oauth2Helper;
}

Future<http.Response> getCryptoBars(OAuth2Helper oauthHelper) async {
  String symbol = "BTCUSD"; // Make this a param later
  String baseURL = "https://data.alpaca.markets/";
  String barsEndpoint = "v1beta1/crypto/$symbol/bars";
  http.Response bars = await oauthHelper.get("$baseURL$barsEndpoint");
  return bars;
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late Future<Album> futureAlbum;
  late OAuth2Helper oauthHelper;

  AlpacaClient client = instantiateClient();
  late Future<http.Response> cryptoBars; // Probably need to make class for bars

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
    oauthHelper = instantiateHelper(client);
  }

  void _incrementCounter() {
    cryptoBars = getCryptoBars(oauthHelper);
    print(cryptoBars);
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pressed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            FutureBuilder<Album>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.title);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
