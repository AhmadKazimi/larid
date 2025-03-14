import 'package:larid/features/photo_capture/domain/entities/photo_capture.dart';
import 'package:larid/features/photo_capture/domain/repositories/photo_capture_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PhotoCaptureRepositoryImpl implements PhotoCaptureRepository {
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
}
