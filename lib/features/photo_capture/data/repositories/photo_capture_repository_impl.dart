import 'package:larid/features/photo_capture/domain/entities/photo_capture.dart';
import 'package:larid/features/photo_capture/domain/repositories/photo_capture_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:larid/core/network/api_service.dart';
import 'package:larid/features/auth/domain/repositories/auth_repository.dart';
import 'package:get_it/get_it.dart';

class PhotoCaptureRepositoryImpl implements PhotoCaptureRepository {
  final ApiService _apiService;
  final AuthRepository _authRepository;

  PhotoCaptureRepositoryImpl({
    required ApiService apiService,
    required AuthRepository authRepository,
  }) : _apiService = apiService,
       _authRepository = authRepository;

  @override
  Future<void> savePhotoCapture(PhotoCapture photoCapture) async {
    final directory = await getApplicationDocumentsDirectory();
    final photoCaptureDir = Directory(
      '${directory.path}/photo_captures/${photoCapture.customerCode}',
    );

    if (!await photoCaptureDir.exists()) {
      await photoCaptureDir.create(recursive: true);
    }

    if (photoCapture.beforeImagePath != null) {
      final beforeFile = File(photoCapture.beforeImagePath!);
      final beforeTargetPath = '${photoCaptureDir.path}/before.jpg';
      await beforeFile.copy(beforeTargetPath);
    }

    if (photoCapture.afterImagePath != null) {
      final afterFile = File(photoCapture.afterImagePath!);
      final afterTargetPath = '${photoCaptureDir.path}/after.jpg';
      await afterFile.copy(afterTargetPath);
    }
  }

  @override
  Future<Map<String, dynamic>> uploadImage(
    String imagePath, {
    required String customerCode,
    required bool isBefore,
    String? comment,
  }) async {
    // Get authentication details from auth repository
    final user = await _authRepository.getCurrentUser();

    if (user == null) {
      return {'success': false, 'error': 'User not logged in'};
    }

    // Upload the image to the server
    final uploadResult = await _apiService.uploadSalesrepPic(
      userid: user.userid,
      workspace: user.workspace,
      password: user.password,
      customerCode: customerCode,
      imageBase64: imagePath,
    );

    if (uploadResult['success'] == true && uploadResult['filename'] != null) {
      // After successful image upload, call the uploadPic API
      final visitDt = DateTime.now().toIso8601String();
      final index = isBefore ? 1 : 2; // 1 for before, 2 for after

      final picResult = await _apiService.uploadPic(
        userid: user.userid,
        workspace: user.workspace,
        password: user.password,
        filename: uploadResult['filename'],
        customerCode: customerCode,
        visitDt: visitDt,
        index: index,
        comments: comment,
      );

      if (picResult['success'] == true) {
        return uploadResult;
      } else {
        return {
          'success': false,
          'error': picResult['error'] ?? 'Failed to update picture info',
        };
      }
    }

    return uploadResult;
  }
}
