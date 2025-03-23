import 'package:equatable/equatable.dart';
import 'package:larid/features/photo_capture/data/services/photo_sync_service.dart';

abstract class PhotoCaptureEvent extends Equatable {
  const PhotoCaptureEvent();

  @override
  List<Object?> get props => [];
}

class TakeBeforePicture extends PhotoCaptureEvent {
  final String? customerCode;

  const TakeBeforePicture({this.customerCode});

  @override
  List<Object?> get props => [customerCode];
}

class TakeAfterPicture extends PhotoCaptureEvent {
  final String? customerCode;

  const TakeAfterPicture({this.customerCode});

  @override
  List<Object?> get props => [customerCode];
}

class SavePhotoCapture extends PhotoCaptureEvent {
  final String customerCode;

  const SavePhotoCapture(this.customerCode);

  @override
  List<Object?> get props => [customerCode];
}

class UploadImage extends PhotoCaptureEvent {
  final String imagePath;
  final String customerCode;
  final bool isBefore;

  const UploadImage({
    required this.imagePath,
    required this.customerCode,
    required this.isBefore,
  });

  @override
  List<Object?> get props => [imagePath, customerCode, isBefore];
}

class LoadSavedPhotos extends PhotoCaptureEvent {
  final String customerCode;

  const LoadSavedPhotos(this.customerCode);

  @override
  List<Object?> get props => [customerCode];
}

class UpdateFromSyncStatus extends PhotoCaptureEvent {
  final SyncStatus status;

  const UpdateFromSyncStatus(this.status);

  @override
  List<Object?> get props => [status];
}

class ClearError extends PhotoCaptureEvent {}
