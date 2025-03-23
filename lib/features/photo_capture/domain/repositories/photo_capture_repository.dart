import 'package:larid/features/photo_capture/domain/entities/photo_capture.dart';

abstract class PhotoCaptureRepository {
  Future<void> savePhotoCapture(PhotoCapture photoCapture);
  Future<Map<String, dynamic>> uploadImage(String imagePath);
}
