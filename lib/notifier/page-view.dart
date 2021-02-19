import 'package:flutter/material.dart';

class PageViewNotifier extends ChangeNotifier {
  int currentPage = 0;

  changePage(int index) {
    currentPage = index;
    notifyListeners();
  }
}
