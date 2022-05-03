import 'package:crypto_trading_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import '../models/alpaca_client.dart';
import '../models/oauth_container.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;
  // Do not hardcode these later
  final clientId = dotenv.env['OAUTH_CLIENT_ID'] ?? 'CLIENT ID NOT FOUND';
  final clientSecret =
      dotenv.env['OAUTH_CLIENT_SECRET'] ?? 'CLIENT SECRET NOT FOUND';
  final redirectUri =
      dotenv.env['OAUTH_REDIRECT_URI'] ?? 'REDIRECT URI NOT FOUND';

  void startLogin(BuildContext context) {
    AlpacaClient client = AlpacaClient(
        redirectUri: redirectUri,
        customUriScheme: redirectUri); // Not applicable for web platform
    OAuth2Helper oauthHelper = OAuth2Helper(client,
        grantType: OAuth2Helper.AUTHORIZATION_CODE,
        clientId: clientId,
        clientSecret: clientSecret,
        scopes: ['account:write trading data']);
    print("hello world");
    var tknResp =
        oauthHelper.getToken().then((value) => print("hello and $value"));
    Navigator.pushNamed(context, dashboardRoute,
        arguments: OauthContainer(client, oauthHelper));
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                style: style,
                onPressed: () {
                  startLogin(context);
                },
                child: const Text('Log in')),
            // ElevatedButton(
            //     style: style,
            //     onPressed: getCryptoBars,
            //     child: const Text('Log in'))
          ],
        ),
      ),
    );
  }
}
