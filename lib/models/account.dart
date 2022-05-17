class Account {
  final String buyingPower;
  final String cash;
  final String equity;

  const Account({
    required this.buyingPower,
    required this.cash,
    required this.equity,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      buyingPower: json['buying_power'],
      cash: json['cash'],
      equity: json['equity'],
    );
  }
}
