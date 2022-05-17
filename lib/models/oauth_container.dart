import 'alpaca_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

class OauthContainer {
  final AlpacaClient client;
  final OAuth2Helper oauthHelper;

  OauthContainer(this.client, this.oauthHelper);
}
