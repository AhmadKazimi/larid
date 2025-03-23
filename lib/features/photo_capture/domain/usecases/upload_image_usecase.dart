import 'package:larid/features/photo_capture/domain/repositories/photo_capture_repository.dart';

class UploadImageUseCase {
  final PhotoCaptureRepository repository;

  UploadImageUseCase(this.repository);

  Future<Map<String, dynamic>> call({
    required String imagePath,
    required String customerCode,
    required bool isBefore,
  }) async {
    return await repository.uploadImage(
      imagePath,
      customerCode: customerCode,
      isBefore: isBefore,
    );
  }
}
