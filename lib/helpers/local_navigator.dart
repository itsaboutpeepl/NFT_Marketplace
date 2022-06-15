import 'package:flutter/material.dart';
import 'package:peeplDapp/constants/controllers.dart';

import 'package:peeplDapp/routing/router.dart';
import 'package:peeplDapp/routing/routes.dart';

Navigator localNavigator() => Navigator(
      key: navigationController.navigationKey,
      initialRoute: vestingPageRoute,
      onGenerateRoute: generateRoute,
    );
