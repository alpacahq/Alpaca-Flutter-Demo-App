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
    // Takes a string-type number and returns it with two decimal places
    String roundNumber(String number) {
      double numAsDouble = double.parse(number);
      String roundedNumber = numAsDouble.toStringAsFixed(2);
      return roundedNumber;
    }

    // Creates a string for the current date and time
    DateTime now = DateTime.now();
    String convertedDateTime =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

    return Account(
      buyingPower: roundNumber(json['buying_power']),
      cash: roundNumber(json['cash']),
      equity: roundNumber(json['equity']),
      date: convertedDateTime,
    );
  }
}
