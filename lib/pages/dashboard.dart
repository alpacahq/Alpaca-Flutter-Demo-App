import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oauth2_client/oauth2_helper.dart';

import '../models/alpaca_client.dart';
import '../models/account.dart';
import '../utils/get_alpaca_account.dart';
import '../utils/send_order.dart';
import '../widgets/account_builder.dart';

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

  // final myController = TextEditingController();
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
  final GlobalKey<FormState> _notionalFormKey = GlobalKey();
  final GlobalKey<FormState> _symbolFormKey = GlobalKey();

  String notional = '';
  String side = 'buy';
  void toggleOrderSide(bool isBuySide) {
    print('switched');
    print('notional is : $notional');
    setState(() {
      // notional = myController.text;
      if (isBuySide) {
        side = 'buy';
      } else {
        side = 'sell';
      }
    });
  }

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
            ElevatedButton(
                style: style,
                onPressed: () {
                  // Validate the symbol and notional input
                  if (_notionalFormKey.currentState!.validate()) {
                    // TODO: Add symbol later
                    _notionalFormKey.currentState!.save();
                    sendOrder(oauthHelper, notional, 'BTCUSD', 'buy');
                  }
                },
                child: const Text('Send order')),
            AccountBuilder(account),
            TextFormField(
              key: _notionalFormKey,
              // controller: myController, // Remove if onSaved-> setState works
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: '1234.56',
                labelText: 'Notional value *',
              ),
              onSaved: (String? value) {
                // Not working for me?
                // This optional block of code can be used to run
                // code when the user saves the form.
                setState(() {
                  notional = value!;
                });
              },
              validator: (String? value) {
                // 33.3
                return (value != null && double.tryParse(value) == null)
                    ? 'Please enter a number (e.g. 123.45).'
                    : null;
              },
            ),
            Switch(
              value: true,
              onChanged: toggleOrderSide,
            ),
          ],
        ),
      ),
    );
  }
}
