import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:larid/features/photo_capture/domain/entities/photo_capture.dart';
import 'package:larid/features/photo_capture/domain/usecases/save_photo_capture_usecase.dart';
import 'package:larid/features/photo_capture/presentation/bloc/photo_capture_event.dart';
import 'package:larid/features/photo_capture/presentation/bloc/photo_capture_state.dart';

class PhotoCaptureBloc extends Bloc<PhotoCaptureEvent, PhotoCaptureState> {
  final SavePhotoCaptureUseCase savePhotoCaptureUseCase;
  final ImagePicker _picker = ImagePicker();

  PhotoCaptureBloc({required this.savePhotoCaptureUseCase})
    : super(const PhotoCaptureState()) {
    on<TakeBeforePicture>(_onTakeBeforePicture);
    on<TakeAfterPicture>(_onTakeAfterPicture);
    on<SavePhotoCapture>(_onSavePhotoCapture);
    on<ClearError>(_onClearError);
  }

  Future<void> _onTakeBeforePicture(
    TakeBeforePicture event,
    Emitter<PhotoCaptureState> emit,
  ) async {
    try {
      final result = await Permission.camera.request();
      if (result.isDenied) {
        emit(state.copyWith(error: 'Camera permission is required'));
        return;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        emit(state.copyWith(beforeImagePath: image.path));
      }
    } catch (e) {
      emit(state.copyWith(error: 'Error accessing camera. Please try again.'));
    }
  }

  Future<void> _onTakeAfterPicture(
    TakeAfterPicture event,
    Emitter<PhotoCaptureState> emit,
  ) async {
    try {
      final result = await Permission.camera.request();
      if (result.isDenied) {
        emit(state.copyWith(error: 'Camera permission is required'));
        return;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        emit(state.copyWith(afterImagePath: image.path));
      }
    } catch (e) {
      emit(state.copyWith(error: 'Error accessing camera. Please try again.'));
    }
  }

  Future<void> _onSavePhotoCapture(
    SavePhotoCapture event,
    Emitter<PhotoCaptureState> emit,
  ) async {
    if (!state.isComplete) {
      emit(
        state.copyWith(error: 'Both before and after pictures are required'),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final photoCapture = PhotoCapture(
        customerCode: event.customerCode,
        beforeImagePath: state.beforeImagePath,
        afterImagePath: state.afterImagePath,
      );

      await savePhotoCaptureUseCase(photoCapture);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Error saving photos'));
    }
  }

  void _onClearError(ClearError event, Emitter<PhotoCaptureState> emit) {
    emit(state.copyWith(error: null));
  }
}
