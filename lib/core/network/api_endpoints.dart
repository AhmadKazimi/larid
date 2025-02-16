class ApiEndpoints {
  // Auth endpoints
  static const String checkUser = '/CheckUser';

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
