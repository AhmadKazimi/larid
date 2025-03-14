import 'package:larid/core/network/api_service.dart';
import 'package:larid/features/receipt_voucher/domain/repositories/receipt_voucher_repository.dart';

class ReceiptVoucherRepositoryImpl implements ReceiptVoucherRepository {
  final ApiService _apiService;

  ReceiptVoucherRepositoryImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<Map<String, dynamic>> uploadReceiptVoucher({
    required String userid,
    required String workspace,
    required String password,
    required String customerCode,
    required double paidAmount,
    required String description,
    required int paymentmethod,
  }) async {
    return await _apiService.uploadReceiptVoucher(
      userid: userid,
      workspace: workspace,
      password: password,
      customerCode: customerCode,
      paidAmount: paidAmount,
      description: description,
      paymentmethod: paymentmethod,
    );
  }
}
