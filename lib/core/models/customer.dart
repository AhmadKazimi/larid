class Customer {
  final String code; // sCustomer_cd
  final String name; // sCustomer_nm
  final String address; // sAddress1
  final String? phone;
  final String? email;
  final String? taxCode;
  final double? balance;

  Customer({
    required this.code,
    required this.name,
    required this.address,
    this.phone,
    this.email,
    this.taxCode,
    this.balance,
  });

  // Factory constructor to create a Customer from a JSON map
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      code: json['sCustomer_cd'] ?? '',
      name: json['sCustomer_nm'] ?? '',
      address: json['sAddress1'] ?? '',
      phone: json['sPhone'] as String?,
      email: json['sEmail'] as String?,
      taxCode: json['sTax_cd'] as String?,
      balance:
          json['mBalance_amt'] != null
              ? double.tryParse(json['mBalance_amt'].toString())
              : null,
    );
  }

  // Convert Customer to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'sCustomer_cd': code,
      'sCustomer_nm': name,
      'sAddress1': address,
      'sPhone': phone,
      'sEmail': email,
      'sTax_cd': taxCode,
      'mBalance_amt': balance,
    };
  }
}
