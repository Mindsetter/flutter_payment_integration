class Transaction {
  final String amount;
  final String email;
  final String reference;
  final String currency;
  final List channel;

  Transaction({
    required this.amount,
    required this.email,
    required this.reference,
    required this.currency,
    required this.channel,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: json['amount'],
      email: json['email'],
      reference: json['reference'],
      currency: json['currency'],
      channel: json['channels'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'email': email,
      'reference': reference,
      'currency': currency,
      'channels': channel,
    };
  }
}
