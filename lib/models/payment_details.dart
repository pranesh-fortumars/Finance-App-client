class PaymentDetails {
  final String? transactionId;
  final String? cardLastFour;
  final String? bankName;
  final String? upiId;
  final String? paymentGateway;

  PaymentDetails({
    this.transactionId,
    this.cardLastFour,
    this.bankName,
    this.upiId,
    this.paymentGateway,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      transactionId: json['transactionId'],
      cardLastFour: json['cardLastFour'],
      bankName: json['bankName'],
      upiId: json['upiId'],
      paymentGateway: json['paymentGateway'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'cardLastFour': cardLastFour,
      'bankName': bankName,
      'upiId': upiId,
      'paymentGateway': paymentGateway,
    };
  }

  PaymentDetails copyWith({
    String? transactionId,
    String? cardLastFour,
    String? bankName,
    String? upiId,
    String? paymentGateway,
  }) {
    return PaymentDetails(
      transactionId: transactionId ?? this.transactionId,
      cardLastFour: cardLastFour ?? this.cardLastFour,
      bankName: bankName ?? this.bankName,
      upiId: upiId ?? this.upiId,
      paymentGateway: paymentGateway ?? this.paymentGateway,
    );
  }
}
