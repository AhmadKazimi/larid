import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larid/core/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:larid/core/theme/app_theme.dart';
import 'package:larid/features/photo_capture/presentation/bloc/photo_capture_bloc.dart';
import 'package:larid/features/photo_capture/presentation/bloc/photo_capture_event.dart';
import 'package:larid/features/photo_capture/presentation/bloc/photo_capture_state.dart';
import 'package:get_it/get_it.dart';
import 'package:larid/features/photo_capture/domain/usecases/save_photo_capture_usecase.dart';
import 'package:larid/features/photo_capture/domain/usecases/upload_image_usecase.dart';

class PhotoCapturePage extends StatelessWidget {
  final String customerName;
  final String customerCode;
  final String? customerAddress;

  const PhotoCapturePage({
    super.key,
    required this.customerName,
    required this.customerCode,
    this.customerAddress,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) {
        final bloc = PhotoCaptureBloc(
          savePhotoCaptureUseCase: GetIt.I<SavePhotoCaptureUseCase>(),
          uploadImageUseCase: GetIt.I<UploadImageUseCase>(),
        );

        // Load saved photos for this customer
        bloc.add(LoadSavedPhotos(customerCode));

        return bloc;
      },
      child: BlocConsumer<PhotoCaptureBloc, PhotoCaptureState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
            context.read<PhotoCaptureBloc>().add(ClearError());
          }

          // Show success message when all operations complete successfully
          if (state.areImagesUploaded &&
              !state.isLoading &&
              state.error == null) {
            // Check if this is after clicking the save button and photos were just uploaded
            // We can track this by checking if both images were recently uploaded
            if (state.beforeImageFilename != null &&
                state.afterImageFilename != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Photos saved and uploaded successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                Column(
                  children: [
                    // Custom Header with Gradient
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      customerName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      localizations.takingPicture,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Main Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Before Picture Section
                            _buildPictureSection(
                              context: context,
                              title: localizations.beforePicture,
                              imagePath: state.beforeImagePath,
                              isUploaded: state.beforeImageUploaded,
                              onTap:
                                  () => context.read<PhotoCaptureBloc>().add(
                                    TakeBeforePicture(),
                                  ),
                            ),
                            const SizedBox(height: 24),
                            // After Picture Section
                            _buildPictureSection(
                              context: context,
                              title: localizations.afterPicture,
                              imagePath: state.afterImagePath,
                              isUploaded: state.afterImageUploaded,
                              onTap:
                                  () => context.read<PhotoCaptureBloc>().add(
                                    TakeAfterPicture(),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Save Button
                    if (state.isComplete)
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, -4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (!state.areImagesUploaded && !state.isLoading)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Photos will be uploaded when you click save',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ElevatedButton(
                              onPressed:
                                  state.isLoading
                                      ? null
                                      : () => context
                                          .read<PhotoCaptureBloc>()
                                          .add(SavePhotoCapture(customerCode)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                elevation: 5,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child:
                                  state.isLoading
                                      ? const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      )
                                      : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.save),
                                          const SizedBox(width: 8),
                                          Text(
                                            localizations.submit,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                // Full-screen loading overlay
                if (state.isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(height: 16),
                              Text(
                                'Uploading images...',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPictureSection({
    required BuildContext context,
    required String title,
    required String? imagePath,
    required VoidCallback onTap,
    bool isUploaded = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            if (imagePath != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isUploaded ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isUploaded ? Icons.check : Icons.photo_camera,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isUploaded ? 'Uploaded' : 'Ready',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              image:
                  imagePath != null
                      ? DecorationImage(
                        image: FileImage(File(imagePath)),
                        fit: BoxFit.cover,
                      )
                      : null,
            ),
            child:
                imagePath == null
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.tapToTakePhoto,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                    : null,
          ),
        ),
      ],
    );
  }
}
