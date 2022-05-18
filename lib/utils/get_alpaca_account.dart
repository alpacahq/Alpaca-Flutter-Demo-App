import 'dart:convert';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/account.dart';

Future<Account> getAlpacaAccount(OAuth2Helper oauthHelper) async {
  final String tradeUrl = dotenv.env['ALPACA_TRADE_URL'] ?? 'TRADE URL NOT FOUND';
  const String accountEndpoint = 'v2/account';
  http.Response response = await oauthHelper.get('$tradeUrl$accountEndpoint');
  if (response.statusCode == 200) {
    return Account.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get account');
  }
}
