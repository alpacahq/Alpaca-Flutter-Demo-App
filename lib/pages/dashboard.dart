import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oauth2_client/oauth2_helper.dart';

import '../models/alpaca_client.dart';
import '../models/account.dart';
import '../utils/get_alpaca_account.dart';
import '../utils/send_alpaca_order.dart';
import '../widgets/account_builder.dart';
import '../widgets/button_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Env variables
  final clientId = dotenv.env['OAUTH_CLIENT_ID'] ?? 'CLIENT ID NOT FOUND';
  final clientSecret =
      dotenv.env['OAUTH_CLIENT_SECRET'] ?? 'CLIENT SECRET NOT FOUND';
  final redirectUri =
      dotenv.env['OAUTH_REDIRECT_URI'] ?? 'REDIRECT URI NOT FOUND';

  // OAuth client and helper
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

  // For operating on form widget
  final formKey = GlobalKey<FormState>();

  // Defining Alpaca variables
  late Future<Account> account;
  String symbol = 'BTCUSD';
  String notional = '';
  String side = 'buy';
  bool isBuySide = true;

  // Sends a buy/sell order and updates the displayed account information
  void sendOrder() {
    sendAlpacaOrder(oauthHelper, notional, symbol, side);
    getAccount(oauthHelper);
  }

  // Allows the user to toggle between sell and buy orders
  void toggleOrderSide() {
    if (isBuySide) {
      side = 'buy';
    } else {
      side = 'sell';
    }
  }

  // Retrieves the latest account information and sets the state
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
      body: Form(
        key: formKey,
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            buildSymbol(),
            const SizedBox(height: 16),
            buildNotional(),
            const SizedBox(height: 32),
            buildSwitch(),
            const SizedBox(height: 32),
            buildSubmit(),
          ],
        ),
      ),
    );
  }

  // Builds the text form field for symbol and does basic validation
  Widget buildSymbol() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Symbol',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a valid symbol (e.g. BTCUSD)';
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => symbol = value!),
      );

  // Builds the text field for notional value
  Widget buildNotional() => TextFormField(
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Notional Value',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a number (e.g. 12.5)';
          } else if (double.parse(value) <= 0) {
            return 'Please enter a number greater than 0';
          } else {
            return null;
          }
        },
        onSaved: (value) => setState((() => notional = value!)),
      );

  // Builds the switch for toggling buy and sell side
  Widget buildSwitch() => Transform.scale(
        scale: 2,
        child: Switch(
          value: isBuySide,
          onChanged: (isOn) => setState(() {
            isBuySide = isOn;
            toggleOrderSide();
          }),
        ),
      );

  // Builds the submit order button
  Widget buildSubmit() => Builder(
        builder: (context) => ButtonWidget(
          text: 'Submit $side order',
          onClicked: () {
            final isValid = formKey.currentState!.validate();

            if (isValid) {
              formKey.currentState!.save();

              final message =
                  'Submitted a $side order for \$$notional of $symbol';
              final snackBar = SnackBar(
                content: Text(
                  message,
                  style: const TextStyle(fontSize: 20),
                ),
                backgroundColor: Colors.green,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              sendOrder();
            }
          },
        ),
      );
}
