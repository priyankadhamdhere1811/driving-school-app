import 'package:flutter/foundation.dart';

/// Holds authentication state for the app.
/// Future Supabase auth integration can update this provider.
class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void signInPlaceholder() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void signOutPlaceholder() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
