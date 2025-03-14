import 'package:equatable/equatable.dart';

abstract class PhotoCaptureEvent extends Equatable {
  const PhotoCaptureEvent();

  @override
  List<Object?> get props => [];
}

class TakeBeforePicture extends PhotoCaptureEvent {}

class TakeAfterPicture extends PhotoCaptureEvent {}

class SavePhotoCapture extends PhotoCaptureEvent {
  final String customerCode;

  const SavePhotoCapture(this.customerCode);

  @override
  List<Object?> get props => [customerCode];
}

class ClearError extends PhotoCaptureEvent {}
