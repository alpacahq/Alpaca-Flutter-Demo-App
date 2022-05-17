import 'package:flutter/material.dart';
import '../utils/get_alpaca_account.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import '../models/alpaca_client.dart';
import '../models/account.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final clientId = dotenv.env['OAUTH_CLIENT_ID'] ?? 'CLIENT ID NOT FOUND';
  final clientSecret =
      dotenv.env['OAUTH_CLIENT_SECRET'] ?? 'CLIENT SECRET NOT FOUND';
  final redirectUri =
      dotenv.env['OAUTH_REDIRECT_URI'] ?? 'REDIRECT URI NOT FOUND';

  late AlpacaClient client = AlpacaClient(
      redirectUri: redirectUri,
      customUriScheme: redirectUri,
      clientId: clientId,
      clientSecret: clientSecret);
  late OAuth2Helper oauthHelper = OAuth2Helper(client,
      grantType: OAuth2Helper.AUTHORIZATION_CODE,
      clientId: clientId,
      clientSecret: clientSecret,
      scopes: ['account:write', 'trading', 'data']);

  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  late Future<Account> account;
  void getAccount(OAuth2Helper oauthHelper) async {
    Future<Account> accountResponse = getAlpacaAccount(oauthHelper);
    setState(() {
      account = accountResponse;
    });
  }

  // Display initial account data
  @override
  void initState() {
    super.initState();
    getAccount(oauthHelper);
  }

  @override
  Widget build(BuildContext context) {
    print(account);
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
