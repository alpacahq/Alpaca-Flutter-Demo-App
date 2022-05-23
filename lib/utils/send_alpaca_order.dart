import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oauth2_client/oauth2_helper.dart';


void sendAlpacaOrder(OAuth2Helper oauthHelper, String notional, String symbol,
    String side) async {
  
  // Creating the proper endpoint 
  final String tradeUrl =
      dotenv.env['ALPACA_TRADE_URL'] ?? 'TRADE URL NOT FOUND';
  const String ordersEndpoint = 'v2/orders';
  String combinedUrl = '$tradeUrl$ordersEndpoint';

  // Parameters for the order
  String timeInForce = 'day'; // Must be day for notional orders
  String type = 'market'; // Hardcoding notional market orders for this example
  String body = jsonEncode(<String, String>{
    'symbol': symbol,
    'notional': notional,
    'side': side,
    'type': type,
    'time_in_force': timeInForce
  });

  // Send post request
  http.Response response = await oauthHelper.post(combinedUrl, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to send order');
  }
}
