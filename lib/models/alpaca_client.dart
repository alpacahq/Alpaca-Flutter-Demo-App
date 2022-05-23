import 'package:oauth2_client/oauth2_client.dart';

class AlpacaClient extends OAuth2Client {
  String clientId;
  String clientSecret;
  AlpacaClient(
      {required String redirectUri,
      required String customUriScheme,
      required this.clientId,
      required this.clientSecret})
      : super(
            authorizeUrl:
                'https://app.alpaca.markets/oauth/authorize',
            tokenUrl:
                'https://api.alpaca.markets/oauth/token',
            redirectUri: redirectUri,
            customUriScheme: customUriScheme);
            
  // Override the base class to add extra fields to the request parameters
  @override
  Map<String, dynamic> getTokenUrlParams(
      {required String code,
      String? redirectUri,
      String? codeVerifier,
      Map<String, dynamic>? customParams}) {
    var foo = super.getTokenUrlParams(
        code: code,
        redirectUri: redirectUri,
        customParams: customParams);
    foo['client_id'] = clientId;
    foo['client_secret'] = clientSecret;
    return foo;
  }
}
