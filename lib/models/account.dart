class Account {
  final String buyingPower;
  final String cash;
  final String equity;
  final String date;

  const Account({
    required this.buyingPower,
    required this.cash,
    required this.equity,
    required this.date,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    // DateTime now = DateTime.parse(json['created_at']);
    DateTime now = DateTime.now();
    String convertedDateTime = "${now.year.toString()}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')} ${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}";
    return Account(
      buyingPower: json['buying_power'],
      cash: json['cash'],
      equity: json['equity'],
      date: convertedDateTime,
    );
  }
}
