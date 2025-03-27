import 'package:equatable/equatable.dart';

class PhotoCaptureState extends Equatable {
  final String? beforeImagePath;
  final String? afterImagePath;
  final bool isLoading;
  final String? error;
  final bool beforeImageUploaded;
  final bool afterImageUploaded;
  final String? beforeImageFilename;
  final String? afterImageFilename;
  final String? comment;

  const PhotoCaptureState({
    this.beforeImagePath,
    this.afterImagePath,
    this.isLoading = false,
    this.error,
    this.beforeImageUploaded = false,
    this.afterImageUploaded = false,
    this.beforeImageFilename,
    this.afterImageFilename,
    this.comment,
  });

  bool get isComplete => beforeImagePath != null && afterImagePath != null;
  bool get areImagesUploaded => beforeImageUploaded && afterImageUploaded;

  PhotoCaptureState copyWith({
    String? beforeImagePath,
    String? afterImagePath,
    bool? isLoading,
    String? error,
    bool? beforeImageUploaded,
    bool? afterImageUploaded,
    String? beforeImageFilename,
    String? afterImageFilename,
    String? comment,
  }) {
    return PhotoCaptureState(
      beforeImagePath: beforeImagePath ?? this.beforeImagePath,
      afterImagePath: afterImagePath ?? this.afterImagePath,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      beforeImageUploaded: beforeImageUploaded ?? this.beforeImageUploaded,
      afterImageUploaded: afterImageUploaded ?? this.afterImageUploaded,
      beforeImageFilename: beforeImageFilename ?? this.beforeImageFilename,
      afterImageFilename: afterImageFilename ?? this.afterImageFilename,
      comment: comment ?? this.comment,
    );
  }

  @override
  List<Object?> get props => [
    beforeImagePath,
    afterImagePath,
    isLoading,
    error,
    beforeImageUploaded,
    afterImageUploaded,
    beforeImageFilename,
    afterImageFilename,
    comment,
  ];
}
