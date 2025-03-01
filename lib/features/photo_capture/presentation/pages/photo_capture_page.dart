import 'package:flutter/material.dart';
import 'package:larid/core/l10n/app_localizations.dart';
import 'package:larid/core/theme/app_theme.dart';
import 'package:larid/features/sync/domain/entities/customer_entity.dart';

class PhotoCapturePage extends StatefulWidget {
  final CustomerEntity customer;

  const PhotoCapturePage({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  State<PhotoCapturePage> createState() => _PhotoCapturePageState();
}

class _PhotoCapturePageState extends State<PhotoCapturePage> {
  // This will be expanded with actual camera functionality
  
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.takePhoto),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Customer info header
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primary.withOpacity(0.1),
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.customer.customerName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Camera preview placeholder
          Expanded(
            child: Container(
              color: Colors.black87,
              child: const Center(
                child: Text(
                  'Camera Preview will be implemented here',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          
          // Camera controls
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Gallery button
                IconButton(
                  onPressed: () {
                    // To be implemented
                  },
                  icon: const Icon(Icons.photo_library, color: Colors.white, size: 32),
                ),
                
                // Capture button
                GestureDetector(
                  onTap: () {
                    // To be implemented
                  },
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                
                // Switch camera button
                IconButton(
                  onPressed: () {
                    // To be implemented
                  },
                  icon: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 32),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
