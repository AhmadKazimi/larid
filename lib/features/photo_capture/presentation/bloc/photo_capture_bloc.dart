import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:larid/core/utils/network_connectivity.dart';
import 'package:larid/features/photo_capture/data/services/photo_sync_service.dart';
import 'package:larid/features/photo_capture/domain/entities/photo_capture.dart';
import 'package:larid/features/photo_capture/domain/usecases/save_photo_capture_usecase.dart';
import 'package:larid/features/photo_capture/domain/usecases/upload_image_usecase.dart';
import 'package:larid/features/photo_capture/presentation/bloc/photo_capture_event.dart';
import 'package:larid/features/photo_capture/presentation/bloc/photo_capture_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:larid/core/storage/shared_prefs.dart';

class PhotoCaptureBloc extends Bloc<PhotoCaptureEvent, PhotoCaptureState> {
  final SavePhotoCaptureUseCase _savePhotoCaptureUseCase;
  final UploadImageUseCase _uploadImageUseCase;
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity();
  late final PhotoSyncService _photoSyncService;

  // Subscription for sync status updates
  StreamSubscription<SyncStatus>? _syncSubscription;

  final ImagePicker _picker = ImagePicker();

  PhotoCaptureBloc({
    required SavePhotoCaptureUseCase savePhotoCaptureUseCase,
    required UploadImageUseCase uploadImageUseCase,
  }) : _savePhotoCaptureUseCase = savePhotoCaptureUseCase,
       _uploadImageUseCase = uploadImageUseCase,
       super(const PhotoCaptureState()) {
    on<TakeBeforePicture>(_onTakeBeforePicture);
    on<TakeAfterPicture>(_onTakeAfterPicture);
    on<SavePhotoCapture>(_onSavePhotoCapture);
    on<UploadImage>(_onUploadImage);
    on<LoadSavedPhotos>(_onLoadSavedPhotos);
    on<ClearError>(_onClearError);
    on<UpdateFromSyncStatus>(_onUpdateFromSyncStatus);

    // Initialize photo sync service
    _photoSyncService = PhotoSyncService(
      uploadImageUseCase: _uploadImageUseCase,
    );
    _photoSyncService.initialize();

    // Listen for sync status updates
    _syncSubscription = _photoSyncService.syncStatusStream.listen((status) {
      print("📲 Received sync status update: ${status.message}");
      add(UpdateFromSyncStatus(status));
    });
  }

  // Handle sync status updates
  void _onUpdateFromSyncStatus(
    UpdateFromSyncStatus event,
    Emitter<PhotoCaptureState> emit,
  ) {
    final status = event.status;

    // If we have a successful sync with customer code, update the UI
    if (status.customerCode != null &&
        status.isBefore != null &&
        status.filename != null) {
      print(
        "🔄 Updating UI from sync: ${status.customerCode}, ${status.isBefore}, ${status.filename}",
      );

      // Update SharedPrefs first
      if (status.isBefore!) {
        SharedPrefs.setBeforeImageSynced(status.customerCode!, true);
        SharedPrefs.setBeforeImageFilename(
          status.customerCode!,
          status.filename!,
        );
      } else {
        SharedPrefs.setAfterImageSynced(status.customerCode!, true);
        SharedPrefs.setAfterImageFilename(
          status.customerCode!,
          status.filename!,
        );
      }

      // Only update UI if it's for the current customer being viewed
      if (state.beforeImagePath != null && state.afterImagePath != null) {
        final beforePath = File(state.beforeImagePath!).uri.pathSegments.last;
        final afterPath = File(state.afterImagePath!).uri.pathSegments.last;
        final syncPath = File(status.lastSyncedFile!).uri.pathSegments.last;

        print(
          "💡 Checking paths - Before: $beforePath, After: $afterPath, Synced: $syncPath",
        );

        if (status.isBefore! && beforePath == syncPath) {
          emit(
            state.copyWith(
              beforeImageUploaded: true,
              beforeImageFilename: status.filename,
            ),
          );
          print("✅ Updated before image as uploaded");
        } else if (!status.isBefore! && afterPath == syncPath) {
          emit(
            state.copyWith(
              afterImageUploaded: true,
              afterImageFilename: status.filename,
            ),
          );
          print("✅ Updated after image as uploaded");
        }
      }
    }
  }

  Future<void> _onTakeBeforePicture(
    TakeBeforePicture event,
    Emitter<PhotoCaptureState> emit,
  ) async {
    try {
      final status = await Permission.camera.request();
      if (status.isGranted) {
        final pickedFile = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 80,
        );

        if (pickedFile != null) {
          emit(
            state.copyWith(
              beforeImagePath: pickedFile.path,
              beforeImageUploaded: false,
            ),
          );

          // Save the latest image path for this customer if available
          final currentEvent = event as TakeBeforePicture;
          if (currentEvent.customerCode != null) {
            await SharedPrefs.setBeforeImagePath(
              currentEvent.customerCode!,
              pickedFile.path,
            );
            await SharedPrefs.setBeforeImageSynced(
              currentEvent.customerCode!,
              false,
            );
          }
        }
      } else {
        emit(state.copyWith(error: 'Camera permission denied'));
      }
    } catch (e) {
      emit(
        state.copyWith(error: 'Error taking before picture: ${e.toString()}'),
      );
    }
  }

  Future<void> _onTakeAfterPicture(
    TakeAfterPicture event,
    Emitter<PhotoCaptureState> emit,
  ) async {
    try {
      final status = await Permission.camera.request();
      if (status.isGranted) {
        final pickedFile = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 80,
        );

        if (pickedFile != null) {
          emit(
            state.copyWith(
              afterImagePath: pickedFile.path,
              afterImageUploaded: false,
            ),
          );

          // Save the latest image path for this customer if available
          final currentEvent = event as TakeAfterPicture;
          if (currentEvent.customerCode != null) {
            await SharedPrefs.setAfterImagePath(
              currentEvent.customerCode!,
              pickedFile.path,
            );
            await SharedPrefs.setAfterImageSynced(
              currentEvent.customerCode!,
              false,
            );
          }
        }
      } else {
        emit(state.copyWith(error: 'Camera permission denied'));
      }
    } catch (e) {
      emit(
        state.copyWith(error: 'Error taking after picture: ${e.toString()}'),
      );
    }
  }

  Future<void> _onSavePhotoCapture(
    SavePhotoCapture event,
    Emitter<PhotoCaptureState> emit,
  ) async {
    try {
      if (state.beforeImagePath == null || state.afterImagePath == null) {
        emit(
          state.copyWith(error: 'Please take both before and after pictures'),
        );
        return;
      }

      emit(state.copyWith(isLoading: true));

      // Save images locally regardless of connectivity
      final photoCapture = PhotoCapture(
        beforeImagePath: state.beforeImagePath!,
        afterImagePath: state.afterImagePath!,
        customerCode: event.customerCode,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      await _savePhotoCaptureUseCase.call(photoCapture);

      // Save paths to SharedPrefs
      await SharedPrefs.setBeforeImagePath(
        event.customerCode,
        state.beforeImagePath!,
      );
      await SharedPrefs.setAfterImagePath(
        event.customerCode,
        state.afterImagePath!,
      );

      print("💾 Photos saved locally for customer: ${event.customerCode}");

      // Attempt to upload if connected, otherwise queue for later
      if (_networkConnectivity.isConnected()) {
        print("📱 Network connected, uploading images");

        // Update SharedPrefs to indicate upload is in progress
        await SharedPrefs.setBeforeImageSynced(event.customerCode, false);
        await SharedPrefs.setAfterImageSynced(event.customerCode, false);

        // Upload before image
        add(
          UploadImage(
            imagePath: state.beforeImagePath!,
            customerCode: event.customerCode,
            isBefore: true,
          ),
        );

        // Upload after image
        add(
          UploadImage(
            imagePath: state.afterImagePath!,
            customerCode: event.customerCode,
            isBefore: false,
          ),
        );
      } else {
        print("📱 Network disconnected, saving images for later upload");

        // Update SharedPrefs to indicate images are not synced
        await SharedPrefs.setBeforeImageSynced(event.customerCode, false);
        await SharedPrefs.setAfterImageSynced(event.customerCode, false);

        // Add to sync service for later upload
        await _photoSyncService.addPendingUpload(
          state.beforeImagePath!,
          event.customerCode,
          isBefore: true,
        );

        await _photoSyncService.addPendingUpload(
          state.afterImagePath!,
          event.customerCode,
          isBefore: false,
        );

        // Update state to show images are saved but not uploaded
        emit(
          state.copyWith(
            isLoading: false,
            beforeImageFilename:
                File(state.beforeImagePath!).uri.pathSegments.last,
            afterImageFilename:
                File(state.afterImagePath!).uri.pathSegments.last,
          ),
        );
      }
    } catch (e) {
      print("❌ Error saving photos: ${e.toString()}");
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
    try {
      if (!_networkConnectivity.isConnected()) {
        // Queue for later upload if not connected
        print(
          "📡 No network connection, adding to pending uploads: ${event.imagePath}",
        );

        await _photoSyncService.addPendingUpload(
          event.imagePath,
          event.customerCode,
          isBefore: event.isBefore,
        );

        // Update SharedPrefs to indicate not synced
        if (event.isBefore) {
          await SharedPrefs.setBeforeImageSynced(event.customerCode, false);
        } else {
          await SharedPrefs.setAfterImageSynced(event.customerCode, false);
        }

        // Update UI accordingly
        if (event.isBefore) {
          emit(
            state.copyWith(
              beforeImageFilename: File(event.imagePath).uri.pathSegments.last,
              beforeImageUploaded: false,
            ),
          );
        } else {
          emit(
            state.copyWith(
              afterImageFilename: File(event.imagePath).uri.pathSegments.last,
              afterImageUploaded: false,
            ),
          );
        }
        return;
      }

      print("📤 Uploading image: ${event.imagePath}");
      final result = await _uploadImageUseCase.call(
        imagePath: event.imagePath,
        customerCode: event.customerCode,
        isBefore: event.isBefore,
      );

      if (result != null && result['success'] == true) {
        print("✅ Upload successful: ${result['filename']}");

        if (event.isBefore) {
          // Update SharedPrefs
          await SharedPrefs.setBeforeImageSynced(event.customerCode, true);
          await SharedPrefs.setBeforeImageFilename(
            event.customerCode,
            result['filename'] as String,
          );

          emit(
            state.copyWith(
              beforeImageUploaded: true,
              beforeImageFilename: result['filename'] as String?,
              isLoading: false,
            ),
          );
        } else {
          // Update SharedPrefs
          await SharedPrefs.setAfterImageSynced(event.customerCode, true);
          await SharedPrefs.setAfterImageFilename(
            event.customerCode,
            result['filename'] as String,
          );

          emit(
            state.copyWith(
              afterImageUploaded: true,
              afterImageFilename: result['filename'] as String?,
              isLoading: false,
            ),
          );
        }
      } else {
        print("❌ Upload failed, adding to pending uploads: ${event.imagePath}");

        // Update SharedPrefs to indicate not synced
        if (event.isBefore) {
          await SharedPrefs.setBeforeImageSynced(event.customerCode, false);
        } else {
          await SharedPrefs.setAfterImageSynced(event.customerCode, false);
        }

        // If upload fails, add to pending uploads
        await _photoSyncService.addPendingUpload(
          event.imagePath,
          event.customerCode,
          isBefore: event.isBefore,
        );

        emit(
          state.copyWith(
            error:
                'Failed to upload image. Will try again when connection is available.',
            isLoading: false,
          ),
        );
      }
    } catch (e) {
      print("❌ Upload error: ${e.toString()}");

      // Update SharedPrefs to indicate not synced
      if (event.isBefore) {
        await SharedPrefs.setBeforeImageSynced(event.customerCode, false);
      } else {
        await SharedPrefs.setAfterImageSynced(event.customerCode, false);
      }

      // In case of error, add to pending uploads
      await _photoSyncService.addPendingUpload(
        event.imagePath,
        event.customerCode,
        isBefore: event.isBefore,
      );

      emit(
        state.copyWith(
          error: 'Error uploading image: ${e.toString()}',
          isLoading: false,
        ),
      );
    }
  }

  Future<void> _onLoadSavedPhotos(
    LoadSavedPhotos event,
    Emitter<PhotoCaptureState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      print("📂 Loading saved photos for customer: ${event.customerCode}");

      // Load saved image paths from SharedPrefs
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

      print(
        "📊 Status - Before: ${beforeImageExists ? 'Exists' : 'Missing'}, Synced: $beforeImageSynced, Filename: $beforeImageFilename",
      );
      print(
        "📊 Status - After: ${afterImageExists ? 'Exists' : 'Missing'}, Synced: $afterImageSynced, Filename: $afterImageFilename",
      );

      // Force check pending uploads to ensure we have the latest status
      await _loadPendingUploadsStatus(event.customerCode);

      // Check if there are pending uploads for this customer
      final pendingImages = await _photoSyncService.getPendingImagesForCustomer(
        event.customerCode,
      );

      // Try to sync if we have connectivity
      if (pendingImages.isNotEmpty && _networkConnectivity.isConnected()) {
        print("🔄 Found pending uploads, triggering sync");
        _photoSyncService.syncPendingUploads();
      }

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
    } catch (e) {
      print("❌ Error loading saved photos: ${e.toString()}");
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Error loading saved photos: ${e.toString()}',
        ),
      );
    }
  }

  // Helper method to check and update pending uploads status
  Future<void> _loadPendingUploadsStatus(String customerCode) async {
    final beforeImagePath = SharedPrefs.getBeforeImagePath(customerCode);
    final afterImagePath = SharedPrefs.getAfterImagePath(customerCode);

    // If paths don't exist, nothing to check
    if (beforeImagePath == null && afterImagePath == null) return;

    // Get all pending uploads for this customer
    final pendingUploads = await _photoSyncService.getPendingImagesForCustomer(
      customerCode,
    );
    print(
      "📑 Found ${pendingUploads.length} pending uploads for customer $customerCode",
    );

    // Update SharedPrefs status based on pending uploads
    if (beforeImagePath != null) {
      final isPending = pendingUploads.contains(beforeImagePath);
      final currentStatus = SharedPrefs.getBeforeImageSynced(customerCode);

      // If it's not pending but status says not synced, update to synced
      if (!isPending && !currentStatus) {
        print("🔄 Updating before image status to synced for $customerCode");
        await SharedPrefs.setBeforeImageSynced(customerCode, true);
      }

      // If it is pending but status says synced, update to not synced
      if (isPending && currentStatus) {
        print(
          "🔄 Updating before image status to not synced for $customerCode",
        );
        await SharedPrefs.setBeforeImageSynced(customerCode, false);
      }
    }

    if (afterImagePath != null) {
      final isPending = pendingUploads.contains(afterImagePath);
      final currentStatus = SharedPrefs.getAfterImageSynced(customerCode);

      // If it's not pending but status says not synced, update to synced
      if (!isPending && !currentStatus) {
        print("🔄 Updating after image status to synced for $customerCode");
        await SharedPrefs.setAfterImageSynced(customerCode, true);
      }

      // If it is pending but status says synced, update to not synced
      if (isPending && currentStatus) {
        print("🔄 Updating after image status to not synced for $customerCode");
        await SharedPrefs.setAfterImageSynced(customerCode, false);
      }
    }
  }

  void _onClearError(ClearError event, Emitter<PhotoCaptureState> emit) {
    emit(state.copyWith(error: null));
  }

  @override
  Future<void> close() {
    _syncSubscription?.cancel();
    return super.close();
  }
}
