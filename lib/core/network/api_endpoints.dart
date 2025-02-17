class ApiEndpoints {
  // Auth endpoints
  static const String checkUser = '/CheckUser';
  static const String getCustomers = '/GetCustomers';
  static const String getSalesrepRouteCustomers = '/GetSalesrepRout';
  static const String getCustomersPriceList = '/GetCustomersPriceList';
  static const String getInventoryItems = '/GetIVItems';
  static const String getInventoryUnits = '/GetIVUnits';
  static const String getUserWearhouse = '/GetUserWH';
  static const String getSalesTaxes = '/GetSalesTaxes';
  static const String uploadPayment = '/UploadPayment';

  // Helper method to build full endpoint URL
  static String buildUrl(String endpoint) {
    return endpoint;
  }
}

class ApiParameters {
  // CheckUser parameters
  static const String userid = 'userid';
  static const String workspace = 'workspace';
  static const String password = 'password';
}
