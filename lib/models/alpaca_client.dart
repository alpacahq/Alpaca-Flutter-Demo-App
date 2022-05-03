import 'package:oauth2_client/oauth2_client.dart';

class AlpacaClient extends OAuth2Client {
  AlpacaClient({required String redirectUri, required String customUriScheme})
      : super(
            authorizeUrl:
                'https://app.alpaca.markets/oauth/authorize', //Your service's authorization url
            tokenUrl:
                'https://api.alpaca.markets/oauth/token', //Your service access token url
            redirectUri: redirectUri,
            customUriScheme: customUriScheme);
}