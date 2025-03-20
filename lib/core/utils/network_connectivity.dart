import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

enum NetworkStatus { online, offline }

class NetworkConnectivity {
  // Singleton instance
  static final NetworkConnectivity _instance = NetworkConnectivity._internal();
  
  factory NetworkConnectivity() => _instance;
  
  NetworkConnectivity._internal();

  // Connectivity instance
  final Connectivity _connectivity = Connectivity();
  
  // Controller for broadcasting network status changes
  final _networkStatusController = StreamController<NetworkStatus>.broadcast();
  
  // Stream that can be listened to for network status updates
  Stream<NetworkStatus> get networkStatusStream => _networkStatusController.stream;
  
  // Current network status
  NetworkStatus _networkStatus = NetworkStatus.offline;
  NetworkStatus get status => _networkStatus;
  
  // Initialize and start listening to connectivity changes
  void initialize() {
    _connectivity.onConnectivityChanged.listen((result) {
      _updateConnectionStatus(result);
    });
    _checkConnectivity();
  }
  
  // Check current connectivity status
  Future<void> _checkConnectivity() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }
  
  // Update connection status based on connectivity result
  void _updateConnectionStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.none) && result.length == 1) {
      _networkStatus = NetworkStatus.offline;
    } else {
      _networkStatus = NetworkStatus.online;
    }
    
    // Broadcast the new status
    _networkStatusController.add(_networkStatus);
  }
  
  // Check if device is currently connected
  bool isConnected() {
    return _networkStatus == NetworkStatus.online;
  }
  
  // Dispose resources
  void dispose() {
    _networkStatusController.close();
  }
  
  // Get a widget that displays current network status
  Widget getNetworkStatusIndicator() {
    return StreamBuilder<NetworkStatus>(
      stream: networkStatusStream,
      initialData: _networkStatus,
      builder: (context, snapshot) {
        final isConnected = snapshot.data == NetworkStatus.online;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isConnected ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isConnected ? Icons.wifi : Icons.wifi_off,
                color: isConnected ? Colors.green : Colors.red,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                isConnected ? 'Online' : 'Offline',
                style: TextStyle(
                  color: isConnected ? Colors.green : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 