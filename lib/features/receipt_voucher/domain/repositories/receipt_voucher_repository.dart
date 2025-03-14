abstract class ReceiptVoucherRepository {
  Future<Map<String, dynamic>> uploadReceiptVoucher({
    required String userid,
    required String workspace,
    required String password,
    required String customerCode,
    required double paidAmount,
    required String description,
    required int paymentmethod,
  });
}
