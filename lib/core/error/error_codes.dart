enum ApiErrorCode {
  paymentUploadFailed(-201, 'Payment Upload Failed'),
  invUploadFailed(-401, 'Invoice Upload Failed'),
  noItems(-601, 'No Items Found'),
  noCustomers(-602, 'No Customers Found'),
  errorDataNotCompleted(-500, 'Data Not Completed'),
  invalidCompany(-501, 'Invalid Company'),
  invalidCustomer(-502, 'Invalid Customer'),
  invalidItem(-503, 'Invalid Item'),
  invalidUnit(-504, 'Invalid Unit'),
  invalidTax(-505, 'Invalid Tax'),
  exceptionFailure(-9000, 'System Error'),
  paidAmtExceedTotalAmt(-700, 'Paid Amount Exceeds Total Amount'),
  userNotExist(-1, 'User Does Not Exist'),
  userExist(1, 'User Already Exists'),
  noDefaultLocation(-603, 'No Default Location'),
  noSalesTax(-604, 'No Sales Tax Found');

  final int code;
  final String message;

  const ApiErrorCode(this.code, this.message);

  static ApiErrorCode? fromCode(dynamic code) {
    if (code is String) {
      code = int.tryParse(code);
    }
    if (code is! int) return null;
    
    return ApiErrorCode.values.firstWhere(
      (e) => e.code == code,
      orElse: () => ApiErrorCode.exceptionFailure,
    );
  }

  static String getErrorMessage(dynamic errorCode) {
    final code = fromCode(errorCode);
    return code?.message ?? 'Unknown Error';
  }
}
