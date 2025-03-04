import 'package:flutter/foundation.dart';

/// A singleton class to manage and notify about customer visit session state changes
class VisitSessionState extends ChangeNotifier {
  static final VisitSessionState _instance = VisitSessionState._internal();
  
  factory VisitSessionState() {
    return _instance;
  }
  
  VisitSessionState._internal();
  
  // Flag to track if session state has changed and needs refresh
  bool _visitSessionChanged = false;
  
  // Getters
  bool get visitSessionChanged => _visitSessionChanged;
  
  // Mark that session state has changed and needs refresh
  void markSessionChanged() {
    _visitSessionChanged = true;
    notifyListeners();
  }
  
  // After state is refreshed, mark as consumed
  void consumeSessionChange() {
    _visitSessionChanged = false;
  }
}

// Global instance for easy access
final visitSessionState = VisitSessionState();
