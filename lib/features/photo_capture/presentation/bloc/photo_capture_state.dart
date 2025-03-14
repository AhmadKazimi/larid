import 'package:equatable/equatable.dart';

class PhotoCaptureState extends Equatable {
  final String? beforeImagePath;
  final String? afterImagePath;
  final bool isLoading;
  final String? error;

  const PhotoCaptureState({
    this.beforeImagePath,
    this.afterImagePath,
    this.isLoading = false,
    this.error,
  });

  bool get isComplete => beforeImagePath != null && afterImagePath != null;

  PhotoCaptureState copyWith({
    String? beforeImagePath,
    String? afterImagePath,
    bool? isLoading,
    String? error,
  }) {
    return PhotoCaptureState(
      beforeImagePath: beforeImagePath ?? this.beforeImagePath,
      afterImagePath: afterImagePath ?? this.afterImagePath,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    beforeImagePath,
    afterImagePath,
    isLoading,
    error,
  ];
}
