import 'package:oauth2_client/oauth2_client.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/authorization_response.dart';
import 'package:oauth2_client/oauth2_response.dart';
import 'package:oauth2_client/src/oauth2_utils.dart';

import 'package:random_string/random_string.dart';

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
                'https://app.alpaca.markets/oauth/authorize', //Your service's authorization url
            tokenUrl:
                'https://api.alpaca.markets/oauth/token', //Your service access token url
            redirectUri: redirectUri,
            customUriScheme: customUriScheme);
  @override
  Map<String, dynamic> getTokenUrlParams(
      {required String code,
      String? redirectUri,
      String? codeVerifier,
      Map<String, dynamic>? customParams}) {
    var foo = super.getTokenUrlParams(
        code: code,
        redirectUri: redirectUri,
        // codeVerifier: codeVerifier,
        customParams: customParams);
    foo['client_id'] = clientId;
    foo['client_secret'] = clientSecret;
    return foo;
  }
}
