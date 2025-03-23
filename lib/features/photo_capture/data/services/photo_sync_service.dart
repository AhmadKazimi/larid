import 'dart:async';
import 'dart:io';
import 'package:larid/core/utils/network_connectivity.dart';
import 'package:larid/features/photo_capture/domain/entities/pending_upload.dart';
import 'package:larid/features/photo_capture/domain/usecases/upload_image_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class PhotoSyncService {
  static final PhotoSyncService _instance = PhotoSyncService._internal();
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity();
  late UploadImageUseCase _uploadImageUseCase;

  // Queue of pending uploads
  List<PendingUpload> _pendingUploads = [];

  // Stream controller for sync status updates
  final _syncStatusController = StreamController<SyncStatus>.broadcast();

  // Keys for shared preferences
  static const String _pendingUploadsKey = 'pending_uploads';

  // For network connectivity monitor
  StreamSubscription<NetworkStatus>? _networkSubscription;
  bool _syncInProgress = false;

  // Private constructor
  PhotoSyncService._internal();

  // Factory constructor for singleton pattern
  factory PhotoSyncService({required UploadImageUseCase uploadImageUseCase}) {
    _instance._uploadImageUseCase = uploadImageUseCase;
    return _instance;
  }

  // Initialize service
  Future<void> initialize() async {
    await _loadPendingUploads();

    // Cancel any existing subscription to avoid duplicates
    _networkSubscription?.cancel();

    // Listen to network connectivity changes
    _networkSubscription = _networkConnectivity.networkStatusStream.listen((
      status,
    ) {
      print("📶 Network status changed: $status");
      if (status == NetworkStatus.online) {
        print("🌐 Network is online, syncing pending uploads");
        syncPendingUploads();
      }
    });

    // Initial sync check
    if (_networkConnectivity.isConnected() && _pendingUploads.isNotEmpty) {
      print(
        "🌐 Network is connected at start, syncing ${_pendingUploads.length} pending uploads",
      );
      syncPendingUploads();
    }
  }

  // Add a pending upload to the queue
  Future<void> addPendingUpload(
    String imagePath,
    String customerCode, {
    bool isBefore = true,
  }) async {
    final pendingUpload = PendingUpload(
      imagePath: imagePath,
      customerCode: customerCode,
      isBefore: isBefore,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    _pendingUploads.add(pendingUpload);
    await _savePendingUploads();

    print(
      "📝 Added to pending uploads: ${pendingUpload.imagePath} (total: ${_pendingUploads.length})",
    );

    // Try to sync immediately if connected
    if (_networkConnectivity.isConnected()) {
      print("🌐 Network connected, attempting immediate sync");
      syncPendingUploads();
    }
  }

  // Get stream of sync status updates
  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;

  // Get the list of pending uploads
  List<PendingUpload> get pendingUploads => List.unmodifiable(_pendingUploads);

  // Load pending uploads from shared preferences
  Future<void> _loadPendingUploads() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingUploadsJson = prefs.getStringList(_pendingUploadsKey) ?? [];

      _pendingUploads =
          pendingUploadsJson
              .map((json) => PendingUpload.fromJson(jsonDecode(json)))
              .toList();

      // Verify files still exist
      _pendingUploads =
          _pendingUploads.where((upload) {
            final file = File(upload.imagePath);
            return file.existsSync();
          }).toList();

      print("🔄 Loaded ${_pendingUploads.length} pending uploads from storage");

      // Save cleaned list
      await _savePendingUploads();
    } catch (e) {
      print('❌ Error loading pending uploads: $e');
      _pendingUploads = [];
    }
  }

  // Save pending uploads to shared preferences
  Future<void> _savePendingUploads() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingUploadsJson =
          _pendingUploads.map((upload) => jsonEncode(upload.toJson())).toList();

      await prefs.setStringList(_pendingUploadsKey, pendingUploadsJson);
      print("💾 Saved ${_pendingUploads.length} pending uploads to storage");
    } catch (e) {
      print('❌ Error saving pending uploads: $e');
    }
  }

  // Sync pending uploads
  Future<void> syncPendingUploads() async {
    if (_pendingUploads.isEmpty) {
      print("ℹ️ No pending uploads to sync");
      return;
    }

    if (_syncInProgress) {
      print("⏳ Sync already in progress, skipping");
      return;
    }

    if (!_networkConnectivity.isConnected()) {
      print("📡 No network connection, cannot sync");
      _syncStatusController.add(
        SyncStatus(
          isSyncing: false,
          message: 'No internet connection',
          pendingCount: _pendingUploads.length,
        ),
      );
      return;
    }

    _syncInProgress = true;
    print("🔄 Starting sync of ${_pendingUploads.length} pending uploads");

    _syncStatusController.add(
      SyncStatus(
        isSyncing: true,
        message: 'Syncing ${_pendingUploads.length} pending uploads',
        pendingCount: _pendingUploads.length,
      ),
    );

    final uploadsToProcess = List<PendingUpload>.from(_pendingUploads);

    for (final upload in uploadsToProcess) {
      try {
        final file = File(upload.imagePath);
        if (!file.existsSync()) {
          print("⚠️ File no longer exists: ${upload.imagePath}");
          _pendingUploads.remove(upload);
          continue;
        }

        print("📤 Uploading: ${upload.imagePath}");
        final result = await _uploadImageUseCase.call(
          imagePath: upload.imagePath,
          customerCode: upload.customerCode,
          isBefore: upload.isBefore,
        );

        if (result != null && result['success'] == true) {
          _pendingUploads.remove(upload);
          print("✅ Successfully uploaded: ${upload.imagePath}");

          _syncStatusController.add(
            SyncStatus(
              isSyncing: true,
              message: 'Successfully uploaded ${upload.imagePath}',
              pendingCount: _pendingUploads.length,
              lastSyncedFile: upload.imagePath,
              customerCode: upload.customerCode,
              isBefore: upload.isBefore,
              filename: result['filename'] as String?,
            ),
          );
        } else {
          print("❌ Failed to upload: ${upload.imagePath}");
          _syncStatusController.add(
            SyncStatus(
              isSyncing: true,
              message:
                  'Error uploading: ${result?['error'] ?? 'Unknown error'}',
              pendingCount: _pendingUploads.length,
              error: result?['error'] ?? 'Unknown error',
            ),
          );
        }
      } catch (e) {
        print('❌ Error syncing upload: $e');
        _syncStatusController.add(
          SyncStatus(
            isSyncing: true,
            message: 'Error uploading: ${e.toString()}',
            pendingCount: _pendingUploads.length,
            error: e.toString(),
          ),
        );
      }
    }

    await _savePendingUploads();
    _syncInProgress = false;

    _syncStatusController.add(
      SyncStatus(
        isSyncing: false,
        message:
            _pendingUploads.isEmpty
                ? 'All uploads completed'
                : '${_pendingUploads.length} uploads still pending',
        pendingCount: _pendingUploads.length,
      ),
    );

    print("🏁 Sync completed. ${_pendingUploads.length} uploads remaining");
  }

  // Return list of images that have been saved locally but not uploaded
  Future<List<String>> getPendingImagesForCustomer(String customerCode) async {
    return _pendingUploads
        .where((upload) => upload.customerCode == customerCode)
        .map((upload) => upload.imagePath)
        .toList();
  }

  // Dispose resources
  void dispose() {
    _networkSubscription?.cancel();
    _syncStatusController.close();
  }
}

// Status class for sync updates
class SyncStatus {
  final bool isSyncing;
  final String message;
  final int pendingCount;
  final String? lastSyncedFile;
  final String? error;
  final String? customerCode;
  final bool? isBefore;
  final String? filename;

  SyncStatus({
    required this.isSyncing,
    required this.message,
    required this.pendingCount,
    this.lastSyncedFile,
    this.error,
    this.customerCode,
    this.isBefore,
    this.filename,
  });
}
