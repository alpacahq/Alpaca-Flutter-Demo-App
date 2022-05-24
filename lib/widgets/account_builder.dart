import 'package:flutter/material.dart';
import '../models/account.dart';

class AccountBuilder extends StatelessWidget {
  Future<Account>? _account;
  final TextStyle titleStyle = const TextStyle(
    decoration: TextDecoration.underline,
    fontSize: 20,
  );
  final TextStyle style = const TextStyle(fontSize: 20);

  AccountBuilder(Future<Account>? account) {
    _account = account;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Account>(
        future: _account,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  Text('Account Info as of ${snapshot.data!.date}',
                      style: titleStyle),
                  Text('Equity: \$${snapshot.data!.equity}', style: style),
                  Text('Cash: \$${snapshot.data!.cash}', style: style),
                  Text('Buying Power: \$${snapshot.data!.buyingPower}',
                      style: style),
                ]);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // Center and size the circular indicator upon rendering
          return (const Center(
              child: SizedBox(
                  width: 30, height: 30, child: CircularProgressIndicator())));
        });
  }
}
