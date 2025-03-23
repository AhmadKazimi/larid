import 'package:larid/features/photo_capture/domain/repositories/photo_capture_repository.dart';

class UploadImageUseCase {
  final PhotoCaptureRepository repository;

  UploadImageUseCase(this.repository);

  Future<Map<String, dynamic>> call(String imagePath) async {
    return await repository.uploadImage(imagePath);
  }
}
