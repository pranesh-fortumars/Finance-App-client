import 'package:flutter/material.dart';

enum ViewId {
  dashboard,
  users,
  entry,
  reports,
  payments,
  notifications,
  bonus,
}

class NavigationProvider extends ChangeNotifier {
  ViewId _currentView = ViewId.dashboard;

  ViewId get currentView => _currentView;

  void navigateTo(ViewId view) {
    _currentView = view;
    notifyListeners();
  }
}
