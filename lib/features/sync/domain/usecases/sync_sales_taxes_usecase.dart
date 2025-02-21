import 'dart:developer' as dev;
import '../../../../core/models/api_response.dart';
import '../entities/sales_tax_entity.dart';
import '../repositories/sync_repository.dart';

class SyncSalesTaxesUseCase {
  final SyncRepository _repository;

  SyncSalesTaxesUseCase(this._repository);

  Future<ApiResponse<List<SalesTaxEntity>>> call() async {
    try {
      dev.log('Starting sales taxes sync');
      
      // Get sales taxes from API
      final response = await _repository.getSalesTaxes();
      dev.log('API Response: ${response.isSuccess}, Error: ${response.errorCode}, Message: ${response.message}');
      
      // If successful, save taxes to local database
      if (response.isSuccess && response.data != null) {
        dev.log('Saving ${response.data!.length} sales taxes to database');
        try {
          await _repository.saveSalesTaxes(response.data!);
          dev.log('Successfully saved sales taxes to database');
        } catch (dbError) {
          dev.log('Error saving to database: $dbError');
          return ApiResponse(
            errorCode: '-1',
            message: 'Failed to save sales taxes to database: $dbError',
          );
        }
      }
      
      return response;
    } catch (e) {
      dev.log('Error in SyncSalesTaxesUseCase: $e');
      return ApiResponse(
        errorCode: '-9000',
        message: 'Failed to sync sales taxes: $e',
      );
    }
  }
}
