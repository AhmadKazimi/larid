import 'dart:developer' as dev;
import '../../../../core/models/api_response.dart';
import '../entities/company_info_entity.dart';
import '../repositories/sync_repository.dart';

class SyncCompanyInfoUseCase {
  final SyncRepository repository;

  SyncCompanyInfoUseCase(this.repository);

  Future<ApiResponse<List<CompanyInfoEntity>>> call() async {
    dev.log('Starting company info sync process');

    try {
      // Fetch company info from the API
      final response = await repository.getCompanyInfo();

      dev.log(
        'API Response received - success: ${response.isSuccess}, errorCode: ${response.errorCode}, message: ${response.message}',
      );

      // If successful, save company info to local database
      if (response.isSuccess &&
          response.data != null &&
          response.data!.isNotEmpty) {
        dev.log('Received company info data: ${response.data!.length} items');

        // Get the first company info (as per requirement, we only need the first one)
        final companyInfo = response.data!.first;
        dev.log(
          'First company info: ${companyInfo.companyName}, ${companyInfo.address1}, taxId: ${companyInfo.taxId}',
        );

        // Save to local database
        await repository.saveCompanyInfo(companyInfo);

        dev.log('Successfully synced and saved company info');
      } else {
        dev.log(
          'Failed to sync company info: ${response.message ?? "Unknown error"}',
        );
      }

      return response;
    } catch (e, stackTrace) {
      dev.log('Error in SyncCompanyInfoUseCase: $e\n$stackTrace');
      return ApiResponse(
        errorCode: '-9000',
        message: 'Exception during company info sync: $e',
      );
    }
  }
}
