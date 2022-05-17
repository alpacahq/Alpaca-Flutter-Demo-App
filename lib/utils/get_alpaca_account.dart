import 'dart:convert';

import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/account.dart';

Future<Account> getAlpacaAccount(OAuth2Helper oauthHelper) async {
  // AccessTokenResponse? tknResp = await oauthHelper.getTokenFromStorage();
  final String baseUrl = dotenv.env['ALPACA_TRADE_URL'] ?? 'DATA URL NOT FOUND';
  const String accountEndpoint = 'v2/account';
  http.Response response = await oauthHelper.get('$baseUrl$accountEndpoint');
  if (response.statusCode == 200) {
    return Account.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get account');
  }
}
