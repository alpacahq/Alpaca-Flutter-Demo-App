import 'package:crypto_trading_app/models/alpaca_client.dart';
import 'package:flutter/material.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import '../utils/get_account.dart';
import '../models/oauth_container.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as OauthContainer?;
    late OAuth2Helper oauthHelper;
    late AlpacaClient client;
    if (args != null) {
      client = args.client;
      oauthHelper = args.oauthHelper;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Alpaca Trading Dashboard"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                style: style,
                onPressed: () {
                  getAccount(oauthHelper);
                },
                child: const Text('Display Account Info')),
          ],
        ),
      ),
    );
  }
}
