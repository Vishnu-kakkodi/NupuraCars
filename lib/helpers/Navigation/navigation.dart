import 'package:flutter/material.dart';

class NavigationController {
  static final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  // ✅ Getter for currentIndex
  static ValueNotifier<int> get currentIndex => _currentIndex;
}

