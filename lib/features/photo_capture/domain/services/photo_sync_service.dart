import 'dart:async';
import 'dart:io';
import 'package:larid/core/utils/network_connectivity.dart';
import 'package:larid/core/storage/shared_prefs.dart';
import 'package:larid/features/photo_capture/domain/usecases/upload_image_usecase.dart';

class PhotoSyncService {
  // Singleton instance
  static final PhotoSyncService _instance = PhotoSyncService._internal();

  factory PhotoSyncService() => _instance;

  PhotoSyncService._internal();

  final NetworkConnectivity _networkConnectivity = NetworkConnectivity();
  final Map<String, bool> _syncInProgress = {};
  StreamSubscription<NetworkStatus>? _networkSubscription;
  Timer? _syncTimer;
  bool _isServiceActive = false;
  final Set<String> _pendingSyncCustomers = <String>{};

  // Initialize the service with the upload use case
  UploadImageUseCase? _uploadImageUseCase;

  void initialize(UploadImageUseCase uploadImageUseCase) {
    _uploadImageUseCase = uploadImageUseCase;
    _startService();
  }

  void _startService() {
    if (_isServiceActive) return;

    _isServiceActive = true;

    // Listen for network status changes
    _networkSubscription = _networkConnectivity.networkStatusStream.listen((
      status,
    ) {
      if (status == NetworkStatus.online) {
        // When network comes back online, try to sync pending images
        _scheduleSyncPendingImages();
      }
    });

    // Start a periodic timer to check for pending images to sync
    _syncTimer = Timer.periodic(const Duration(minutes: 30), (_) {
      if (_networkConnectivity.isConnected()) {
        _scheduleSyncPendingImages();
      }
    });
  }

  void _scheduleSyncPendingImages() {
    // Use a microtask to avoid blocking the UI
    Future.microtask(() => _syncPendingImages());
  }

  // Add a customer to the pending sync list
  void addCustomerForSync(String customerCode) {
    _pendingSyncCustomers.add(customerCode);

    // If we're online, try to sync right away
    if (_networkConnectivity.isConnected()) {
      _scheduleSyncPendingImages();
    }
  }

  // Sync pending images for all customers in the list
  Future<void> _syncPendingImages() async {
    if (_uploadImageUseCase == null) return;

    // Make a copy of the set to avoid concurrent modification
    final customersToSync = Set<String>.from(_pendingSyncCustomers);

    for (final customerCode in customersToSync) {
      // Skip if a sync is already in progress for this customer
      if (_syncInProgress[customerCode] == true) continue;

      try {
        _syncInProgress[customerCode] = true;

        // Check if there are images to sync for this customer
        final beforeImagePath = SharedPrefs.getBeforeImagePath(customerCode);
        final afterImagePath = SharedPrefs.getAfterImagePath(customerCode);
        final beforeImageSynced = SharedPrefs.getBeforeImageSynced(
          customerCode,
        );
        final afterImageSynced = SharedPrefs.getAfterImageSynced(customerCode);

        bool synced = true;

        // Check and upload before image if needed
        if (beforeImagePath != null &&
            !beforeImageSynced &&
            File(beforeImagePath).existsSync()) {
          final result = await _uploadImageUseCase!.call(
            imagePath: beforeImagePath,
            customerCode: customerCode,
            isBefore: true,
          );
          if (result['success'] == true) {
            print(
              '🔄 Background sync - Before image uploaded for customer: $customerCode',
            );
            await SharedPrefs.setBeforeImageSynced(customerCode, true);
            if (result['filename'] != null) {
              await SharedPrefs.setBeforeImageFilename(
                customerCode,
                result['filename'],
              );
            }
          } else {
            print(
              '❌ Background sync - Failed to upload before image: ${result['error']}',
            );
            synced = false;
          }
        }

        // Check and upload after image if needed
        if (afterImagePath != null &&
            !afterImageSynced &&
            File(afterImagePath).existsSync()) {
          final result = await _uploadImageUseCase!.call(
            imagePath: afterImagePath,
            customerCode: customerCode,
            isBefore: false,
          );
          if (result['success'] == true) {
            print(
              '🔄 Background sync - After image uploaded for customer: $customerCode',
            );
            await SharedPrefs.setAfterImageSynced(customerCode, true);
            if (result['filename'] != null) {
              await SharedPrefs.setAfterImageFilename(
                customerCode,
                result['filename'],
              );
            }
          } else {
            print(
              '❌ Background sync - Failed to upload after image: ${result['error']}',
            );
            synced = false;
          }
        }

        // If all images are synced, remove from pending list
        if (synced) {
          _pendingSyncCustomers.remove(customerCode);
        }
      } catch (e) {
        print('❌ Background sync - Exception for customer $customerCode: $e');
      } finally {
        _syncInProgress[customerCode] = false;
      }
    }
  }

  // Force sync a specific customer's images
  Future<void> syncCustomerImages(String customerCode) async {
    if (_uploadImageUseCase == null || !_networkConnectivity.isConnected())
      return;

    // Skip if a sync is already in progress for this customer
    if (_syncInProgress[customerCode] == true) return;

    try {
      _syncInProgress[customerCode] = true;

      // Check if there are images to sync for this customer
      final beforeImagePath = SharedPrefs.getBeforeImagePath(customerCode);
      final afterImagePath = SharedPrefs.getAfterImagePath(customerCode);
      final beforeImageSynced = SharedPrefs.getBeforeImageSynced(customerCode);
      final afterImageSynced = SharedPrefs.getAfterImageSynced(customerCode);

      bool synced = true;

      // Check and upload before image if needed
      if (beforeImagePath != null &&
          !beforeImageSynced &&
          File(beforeImagePath).existsSync()) {
        final result = await _uploadImageUseCase!.call(
          imagePath: beforeImagePath,
          customerCode: customerCode,
          isBefore: true,
        );
        if (result['success'] == true) {
          print(
            '🔄 Forced sync - Before image uploaded for customer: $customerCode',
          );
          await SharedPrefs.setBeforeImageSynced(customerCode, true);
          if (result['filename'] != null) {
            await SharedPrefs.setBeforeImageFilename(
              customerCode,
              result['filename'],
            );
          }
        } else {
          print(
            '❌ Forced sync - Failed to upload before image: ${result['error']}',
          );
          synced = false;
        }
      }

      // Check and upload after image if needed
      if (afterImagePath != null &&
          !afterImageSynced &&
          File(afterImagePath).existsSync()) {
        final result = await _uploadImageUseCase!.call(
          imagePath: afterImagePath,
          customerCode: customerCode,
          isBefore: false,
        );
        if (result['success'] == true) {
          print(
            '🔄 Forced sync - After image uploaded for customer: $customerCode',
          );
          await SharedPrefs.setAfterImageSynced(customerCode, true);
          if (result['filename'] != null) {
            await SharedPrefs.setAfterImageFilename(
              customerCode,
              result['filename'],
            );
          }
        } else {
          print(
            '❌ Forced sync - Failed to upload after image: ${result['error']}',
          );
          synced = false;
        }
      }

      // If all images are synced, remove from pending list
      if (synced) {
        _pendingSyncCustomers.remove(customerCode);
      } else {
        // Add to pending list if sync failed
        _pendingSyncCustomers.add(customerCode);
      }
    } catch (e) {
      print('❌ Forced sync - Exception for customer $customerCode: $e');
      // Add to pending list if there was an exception
      _pendingSyncCustomers.add(customerCode);
    } finally {
      _syncInProgress[customerCode] = false;
    }
  }

  // Check if there are pending images to sync for a customer
  bool hasPendingImages(String customerCode) {
    final beforeImagePath = SharedPrefs.getBeforeImagePath(customerCode);
    final afterImagePath = SharedPrefs.getAfterImagePath(customerCode);
    final beforeImageSynced = SharedPrefs.getBeforeImageSynced(customerCode);
    final afterImageSynced = SharedPrefs.getAfterImageSynced(customerCode);

    bool beforePending =
        beforeImagePath != null &&
        !beforeImageSynced &&
        File(beforeImagePath).existsSync();

    bool afterPending =
        afterImagePath != null &&
        !afterImageSynced &&
        File(afterImagePath).existsSync();

    return beforePending || afterPending;
  }

  // Dispose resources
  void dispose() {
    _isServiceActive = false;
    _networkSubscription?.cancel();
    _syncTimer?.cancel();
    _pendingSyncCustomers.clear();
    _syncInProgress.clear();
  }
}
