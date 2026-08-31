class Address {
  final String doorNumber;
  final String street;
  final String area;
  final String localAddress;
  final String city;
  final String district;
  final String state;
  final String pinCode;

  Address({
    required this.doorNumber,
    required this.street,
    required this.area,
    required this.localAddress,
    required this.city,
    required this.district,
    required this.state,
    required this.pinCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      doorNumber: json['doorNumber'] ?? '',
      street: json['street'] ?? '',
      area: json['area'] ?? '',
      localAddress: json['localAddress'] ?? '',
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      state: json['state'] ?? '',
      pinCode: json['pinCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doorNumber': doorNumber,
      'street': street,
      'area': area,
      'localAddress': localAddress,
      'city': city,
      'district': district,
      'state': state,
      'pinCode': pinCode,
    };
  }

  Address copyWith({
    String? doorNumber,
    String? street,
    String? area,
    String? localAddress,
    String? city,
    String? district,
    String? state,
    String? pinCode,
  }) {
    return Address(
      doorNumber: doorNumber ?? this.doorNumber,
      street: street ?? this.street,
      area: area ?? this.area,
      localAddress: localAddress ?? this.localAddress,
      city: city ?? this.city,
      district: district ?? this.district,
      state: state ?? this.state,
      pinCode: pinCode ?? this.pinCode,
    );
  }
}
