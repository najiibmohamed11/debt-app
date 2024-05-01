import 'package:flutter/foundation.dart';

class UseridGenerator extends ChangeNotifier {
  String? _sessionId; // Use a private variable to store the session ID

  // Setter method to update the session ID and notify listeners
  void setSession(String? sessionId) {
    _sessionId = sessionId;
    notifyListeners(); // This will notify all the consumers of this provider about the change
  }

  // Getter method to retrieve the session ID
  String? getSession() {
    return _sessionId;
  }
}
