import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:larid/core/theme/app_theme.dart';

// For backward compatibility with existing code
enum NetworkStatus { online, offline }

class NetworkConnectivity {
  static final NetworkConnectivity _instance = NetworkConnectivity._internal();
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  List<ConnectivityResult> _connectionStatus = [];
  final _connectivityStatusController =
      StreamController<List<ConnectivityResult>>.broadcast();

  // For backward compatibility
  final _networkStatusController = StreamController<NetworkStatus>.broadcast();

  // Singleton pattern
  factory NetworkConnectivity() {
    return _instance;
  }

  NetworkConnectivity._internal() {
    // Initialize connectivity monitoring
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      _updateConnectionStatus(result);
      // Update the legacy stream too
      _networkStatusController.add(
        isConnected() ? NetworkStatus.online : NetworkStatus.offline,
      );
    });
  }

  // Empty initialize method for backward compatibility
  void initialize() {
    // Initialization already happens in constructor
    // This method exists for backward compatibility
  }

  // Initialize connectivity
  Future<void> _initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      print('Connectivity check failed: $e');
      result = [ConnectivityResult.none];
    }
    _updateConnectionStatus(result);
    // Update the legacy stream too
    _networkStatusController.add(
      isConnected() ? NetworkStatus.online : NetworkStatus.offline,
    );
  }

  // Update connection status
  void _updateConnectionStatus(List<ConnectivityResult> result) {
    _connectionStatus = result;
    _connectivityStatusController.add(result);
  }

  // Check if connected to the internet
  bool isConnected() {
    return _connectionStatus.contains(ConnectivityResult.mobile) ||
        _connectionStatus.contains(ConnectivityResult.wifi) ||
        _connectionStatus.contains(ConnectivityResult.ethernet);
  }

  // Get connectivity stream
  Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivityStatusController.stream;

  // Get current connection status
  List<ConnectivityResult> get currentStatus => _connectionStatus;

  // Dispose resources
  void dispose() {
    _connectivitySubscription.cancel();
    _connectivityStatusController.close();
    _networkStatusController.close();
  }

  // Get a Widget that shows current network status
  Widget getNetworkStatusIndicator() {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: connectivityStream,
      initialData: _connectionStatus,
      builder: (context, snapshot) {
        final isConnected =
            snapshot.data?.contains(ConnectivityResult.mobile) == true ||
            snapshot.data?.contains(ConnectivityResult.wifi) == true ||
            snapshot.data?.contains(ConnectivityResult.ethernet) == true;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color:
                isConnected
                    ? Colors.green.withOpacity(0.8)
                    : Colors.red.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isConnected ? Icons.wifi : Icons.wifi_off,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                isConnected ? 'Online' : 'Offline',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // For backward compatibility
  Stream<NetworkStatus> get networkStatusStream =>
      _networkStatusController.stream;
}
