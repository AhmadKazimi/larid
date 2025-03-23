import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:larid/features/photo_capture/domain/entities/photo_capture.dart';
import 'package:larid/features/photo_capture/domain/usecases/save_photo_capture_usecase.dart';
import 'package:larid/features/photo_capture/domain/usecases/upload_image_usecase.dart';
import 'package:larid/features/photo_capture/presentation/bloc/photo_capture_event.dart';
import 'package:larid/features/photo_capture/presentation/bloc/photo_capture_state.dart';
import 'package:larid/core/storage/shared_prefs.dart';
import 'dart:io';

class PhotoCaptureBloc extends Bloc<PhotoCaptureEvent, PhotoCaptureState> {
  final SavePhotoCaptureUseCase savePhotoCaptureUseCase;
  final UploadImageUseCase uploadImageUseCase;
  final ImagePicker _picker = ImagePicker();
  String? _currentCustomerCode;

  PhotoCaptureBloc({
    required this.savePhotoCaptureUseCase,
    required this.uploadImageUseCase,
  }) : super(const PhotoCaptureState()) {
    on<TakeBeforePicture>(_onTakeBeforePicture);
    on<TakeAfterPicture>(_onTakeAfterPicture);
    on<SavePhotoCapture>(_onSavePhotoCapture);
    on<UploadImage>(_onUploadImage);
    on<LoadSavedPhotos>(_onLoadSavedPhotos);
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

        // Save the image path to SharedPreferences if we have a customer code
        if (_currentCustomerCode != null) {
          await SharedPrefs.setBeforeImagePath(
            _currentCustomerCode!,
            image.path,
          );
          await SharedPrefs.setBeforeImageSynced(_currentCustomerCode!, false);
        }
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

        // Save the image path to SharedPreferences if we have a customer code
        if (_currentCustomerCode != null) {
          await SharedPrefs.setAfterImagePath(
            _currentCustomerCode!,
            image.path,
          );
          await SharedPrefs.setAfterImageSynced(_currentCustomerCode!, false);
        }
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

    // Save the customer code for later use
    _currentCustomerCode = event.customerCode;

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

          // Update shared preferences with the upload status and filename
          await SharedPrefs.setBeforeImageSynced(event.customerCode, true);
          if (beforeResult['filename'] != null) {
            await SharedPrefs.setBeforeImageFilename(
              event.customerCode,
              beforeResult['filename'],
            );
          }

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

          // Update shared preferences with the upload status and filename
          await SharedPrefs.setAfterImageSynced(event.customerCode, true);
          if (afterResult['filename'] != null) {
            await SharedPrefs.setAfterImageFilename(
              event.customerCode,
              afterResult['filename'],
            );
          }

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

      // Save paths to SharedPreferences if they're not already saved
      if (state.beforeImagePath != null) {
        await SharedPrefs.setBeforeImagePath(
          event.customerCode,
          state.beforeImagePath!,
        );
      }
      if (state.afterImagePath != null) {
        await SharedPrefs.setAfterImagePath(
          event.customerCode,
          state.afterImagePath!,
        );
      }

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
          // Update shared preferences if we have a customer code
          if (_currentCustomerCode != null) {
            await SharedPrefs.setBeforeImageSynced(_currentCustomerCode!, true);
            if (result['filename'] != null) {
              await SharedPrefs.setBeforeImageFilename(
                _currentCustomerCode!,
                result['filename'],
              );
            }
          }

          emit(
            state.copyWith(
              isLoading: false,
              beforeImageUploaded: true,
              beforeImageFilename: result['filename'],
            ),
          );
        } else if (state.afterImagePath == event.imagePath) {
          // Update shared preferences if we have a customer code
          if (_currentCustomerCode != null) {
            await SharedPrefs.setAfterImageSynced(_currentCustomerCode!, true);
            if (result['filename'] != null) {
              await SharedPrefs.setAfterImageFilename(
                _currentCustomerCode!,
                result['filename'],
              );
            }
          }

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

  Future<void> _onLoadSavedPhotos(
    LoadSavedPhotos event,
    Emitter<PhotoCaptureState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      // Save the customer code for later use
      _currentCustomerCode = event.customerCode;

      // Load saved image paths from SharedPreferences
      final beforeImagePath = SharedPrefs.getBeforeImagePath(
        event.customerCode,
      );
      final afterImagePath = SharedPrefs.getAfterImagePath(event.customerCode);

      // Check if the files exist
      bool beforeImageExists =
          beforeImagePath != null && File(beforeImagePath).existsSync();
      bool afterImageExists =
          afterImagePath != null && File(afterImagePath).existsSync();

      // Load sync states
      final beforeImageSynced = SharedPrefs.getBeforeImageSynced(
        event.customerCode,
      );
      final afterImageSynced = SharedPrefs.getAfterImageSynced(
        event.customerCode,
      );

      // Load filenames
      final beforeImageFilename = SharedPrefs.getBeforeImageFilename(
        event.customerCode,
      );
      final afterImageFilename = SharedPrefs.getAfterImageFilename(
        event.customerCode,
      );

      // Emit new state with loaded data
      emit(
        state.copyWith(
          isLoading: false,
          beforeImagePath: beforeImageExists ? beforeImagePath : null,
          afterImagePath: afterImageExists ? afterImagePath : null,
          beforeImageUploaded: beforeImageSynced,
          afterImageUploaded: afterImageSynced,
          beforeImageFilename: beforeImageFilename,
          afterImageFilename: afterImageFilename,
        ),
      );

      print('📸 Loaded saved photos for customer: ${event.customerCode}');
      print(
        '   Before image: ${beforeImageExists ? beforeImagePath : "Not found"}',
      );
      print(
        '   After image: ${afterImageExists ? afterImagePath : "Not found"}',
      );
      print('   Before image synced: $beforeImageSynced');
      print('   After image synced: $afterImageSynced');
    } catch (e) {
      print('❌ Load saved photos EXCEPTION: ${e.toString()}');
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Error loading saved photos: ${e.toString()}',
        ),
      );
    }
  }

  void _onClearError(ClearError event, Emitter<PhotoCaptureState> emit) {
    emit(state.copyWith(error: null));
  }
}
