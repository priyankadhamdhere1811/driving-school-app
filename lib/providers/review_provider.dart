import 'package:flutter/foundation.dart';

/// Holds review-related state for public and owner review screens.
/// Future review moderation or Supabase data can be wired here.
class ReviewProvider extends ChangeNotifier {
  int _reviewCount = 0;

  int get reviewCount => _reviewCount;

  void addReview() {
    _reviewCount++;
    notifyListeners();
  }

  void resetReviews() {
    _reviewCount = 0;
    notifyListeners();
  }
}
