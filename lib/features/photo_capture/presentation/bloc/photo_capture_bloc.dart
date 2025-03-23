import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:larid/features/photo_capture/domain/entities/photo_capture.dart';
import 'package:larid/features/photo_capture/domain/usecases/save_photo_capture_usecase.dart';
import 'package:larid/features/photo_capture/domain/usecases/upload_image_usecase.dart';
import 'package:larid/features/photo_capture/presentation/bloc/photo_capture_event.dart';
import 'package:larid/features/photo_capture/presentation/bloc/photo_capture_state.dart';

class PhotoCaptureBloc extends Bloc<PhotoCaptureEvent, PhotoCaptureState> {
  final SavePhotoCaptureUseCase savePhotoCaptureUseCase;
  final UploadImageUseCase uploadImageUseCase;
  final ImagePicker _picker = ImagePicker();

  PhotoCaptureBloc({
    required this.savePhotoCaptureUseCase,
    required this.uploadImageUseCase,
  }) : super(const PhotoCaptureState()) {
    on<TakeBeforePicture>(_onTakeBeforePicture);
    on<TakeAfterPicture>(_onTakeAfterPicture);
    on<SavePhotoCapture>(_onSavePhotoCapture);
    on<UploadImage>(_onUploadImage);
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
        emit(
          state.copyWith(
            beforeImagePath: image.path,
            beforeImageUploaded: false, // Reset upload status
          ),
        );
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
        emit(
          state.copyWith(
            afterImagePath: image.path,
            afterImageUploaded: false, // Reset upload status
          ),
        );
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
      // First, ensure both images are uploaded
      if (!state.beforeImageUploaded && state.beforeImagePath != null) {
        final beforeResult = await uploadImageUseCase(state.beforeImagePath!);
        if (beforeResult['success'] != true) {
          print('❌ Before image upload ERROR: ${beforeResult['error']}');
          emit(
            state.copyWith(
              isLoading: false,
              error: 'Failed to upload before image: ${beforeResult['error']}',
            ),
          );
          return;
        } else {
          print('📸 Before image upload SUCCESS: ${beforeResult['filename']}');
          emit(
            state.copyWith(
              beforeImageUploaded: true,
              beforeImageFilename: beforeResult['filename'],
            ),
          );
        }
      }

      if (!state.afterImageUploaded && state.afterImagePath != null) {
        final afterResult = await uploadImageUseCase(state.afterImagePath!);
        if (afterResult['success'] != true) {
          print('❌ After image upload ERROR: ${afterResult['error']}');
          emit(
            state.copyWith(
              isLoading: false,
              error: 'Failed to upload after image: ${afterResult['error']}',
            ),
          );
          return;
        } else {
          print('📸 After image upload SUCCESS: ${afterResult['filename']}');
          emit(
            state.copyWith(
              afterImageUploaded: true,
              afterImageFilename: afterResult['filename'],
            ),
          );
        }
      }

      // Then save photos locally
      final photoCapture = PhotoCapture(
        customerCode: event.customerCode,
        beforeImagePath: state.beforeImagePath,
        afterImagePath: state.afterImagePath,
      );

      await savePhotoCaptureUseCase(photoCapture);
      print('✅ Photos saved locally for customer: ${event.customerCode}');
      emit(state.copyWith(isLoading: false, error: null));
    } catch (e) {
      print('❌ Save photos EXCEPTION: ${e.toString()}');
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Error saving photos: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onUploadImage(
    UploadImage event,
    Emitter<PhotoCaptureState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final result = await uploadImageUseCase(event.imagePath);

      if (result['success'] == true) {
        // Debug print for successful upload
        print('📸 Image upload SUCCESS: ${result['filename']}');

        // Update the upload status based on which image was uploaded
        if (state.beforeImagePath == event.imagePath) {
          emit(
            state.copyWith(
              isLoading: false,
              beforeImageUploaded: true,
              beforeImageFilename: result['filename'],
            ),
          );
        } else if (state.afterImagePath == event.imagePath) {
          emit(
            state.copyWith(
              isLoading: false,
              afterImageUploaded: true,
              afterImageFilename: result['filename'],
            ),
          );
        } else {
          emit(state.copyWith(isLoading: false));
        }
      } else {
        // Debug print for failed upload
        print('❌ Image upload ERROR: ${result['error']}');

        // Upload failed
        emit(
          state.copyWith(
            isLoading: false,
            error: 'Failed to upload image: ${result['error']}',
          ),
        );
      }
    } catch (e) {
      // Debug print for exception
      print('❌ Image upload EXCEPTION: ${e.toString()}');

      emit(
        state.copyWith(
          isLoading: false,
          error: 'Error uploading image: ${e.toString()}',
        ),
      );
    }
  }

  void _onClearError(ClearError event, Emitter<PhotoCaptureState> emit) {
    emit(state.copyWith(error: null));
  }
}
