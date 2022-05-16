import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<http.Response> getAccount(OAuth2Helper oauthHelper) async {
  print("getAccount called");
  AccessTokenResponse? tknResp = await oauthHelper.getTokenFromStorage();
  print("Inside getAccount with a token of $tknResp");
  final String baseUrl = dotenv.env['ALPACA_TRADE_URL'] ?? 'DATA URL NOT FOUND';
  const String accountEndpoint = 'v2/account';
  http.Response resp = await oauthHelper.get('$baseUrl$accountEndpoint');
  return resp;
}
