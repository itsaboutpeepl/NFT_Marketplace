import 'package:flutter/material.dart';

import 'package:peeplDapp/pages/dashboard/dashboard_screen.dart';

import 'package:peeplDapp/routing/routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case overviewPageRoute:
      return _getPageRoute(const DashboardScreen());

    default:
      return _getPageRoute(const DashboardScreen());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
