import 'package:equatable/equatable.dart';

class CompanyInfoEntity extends Equatable {
  final String companyName;
  final String address1;
  final String address2;
  final String address3;
  final String phone;
  final String taxId;

  const CompanyInfoEntity({
    required this.companyName,
    required this.address1,
    required this.address2,
    required this.address3,
    required this.phone,
    required this.taxId,
  });

  @override
  List<Object> get props => [
    companyName,
    address1,
    address2,
    address3,
    phone,
    taxId,
  ];

  factory CompanyInfoEntity.fromJson(Map<String, dynamic> json) {
    return CompanyInfoEntity(
      companyName: json['sCompany_nm'] ?? '',
      address1: json['sAddress1'] ?? '',
      address2: json['sAddress2'] ?? '',
      address3: json['sAddress3'] ?? '',
      phone: json['sPhone'] ?? '',
      taxId: json['sTax_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sCompany_nm': companyName,
      'sAddress1': address1,
      'sAddress2': address2,
      'sAddress3': address3,
      'sPhone': phone,
      'sTax_id': taxId,
    };
  }
}
