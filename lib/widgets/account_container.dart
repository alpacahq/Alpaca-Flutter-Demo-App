// import 'package:flutter/material.dart';
// import '../models/account.dart';

// class AccountBuilder extends StatelessWidget {
//   Future<Account>? _account;

//   AccountBuilder(Future<Account>? account) {
//     this._account = account;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Account>(
//         future: _account,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return Text('Current Buying Power: ${snapshot.data!.buyingPower}');
//           } else if (snapshot.hasError) {
//             return Text('${snapshot.error}');
//           }

//           return const CircularProgressIndicator();
//         });
//   }
// }
