import 'dart:convert';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void sendOrder(OAuth2Helper oauthHelper, String notional, String symbol,
    String side) async {
      
  final String tradeUrl =
      dotenv.env['ALPACA_TRADE_URL'] ?? 'TRADE URL NOT FOUND';
  const String ordersEndpoint = 'v2/orders';
  String combinedUrl = '$tradeUrl$ordersEndpoint';

  String timeInForce = 'day'; // Must be day for notional orders
  String type = 'market'; // Hardcoding notional market orders for this example
  String body = jsonEncode(<String, String>{
    'symbol': symbol,
    'notional': notional,
    'side': side,
    'type': type,
    'time_in_force': timeInForce
  });

  http.Response response = await oauthHelper.post(combinedUrl, body: body);

  if (response.statusCode == 200) {
    // return jsonDecode(response.body);
  } else {
    throw Exception('Failed to send order');
  }
}
