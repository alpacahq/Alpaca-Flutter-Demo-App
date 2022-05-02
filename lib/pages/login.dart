import 'package:flutter/material.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import '../models/alpaca_client.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;
  // Do not hardcode these later
  final clientId = "4cae962faa56816799ecba13175403e6";
  final clientSecret = "e871b5a874505aa108a23f2a640cdb7b095330df";

  void startLogin() {
    AlpacaClient client = AlpacaClient(
        redirectUri: "http://localhost:3000/dashboard",
        customUriScheme: "http://localhost:3000/");
    OAuth2Helper oauthHelper = OAuth2Helper(client,
        grantType: OAuth2Helper.AUTHORIZATION_CODE,
        clientId: clientId,
        clientSecret: clientSecret,
        scopes: ['account:write trading data']);
    print("hello world");
    var tknResp = oauthHelper.getToken();
    print(tknResp);
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
                onPressed: startLogin,
                child: const Text('Log in'))
          ],
        ),
      ),
    );
  }
}
