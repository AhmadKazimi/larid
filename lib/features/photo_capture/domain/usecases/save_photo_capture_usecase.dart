import 'package:larid/features/photo_capture/domain/entities/photo_capture.dart';
import 'package:larid/features/photo_capture/domain/repositories/photo_capture_repository.dart';

class SavePhotoCaptureUseCase {
  final PhotoCaptureRepository repository;

  SavePhotoCaptureUseCase(this.repository);

  Future<void> call(PhotoCapture photoCapture) async {
    await repository.savePhotoCapture(photoCapture);
  }
}
