import 'package:flutter/material.dart';
import 'package:peeplDapp/Widgets/large_screen.dart';

import 'package:peeplDapp/Widgets/small_screen.dart';

import 'package:peeplDapp/helpers/responsiveness.dart';

class SiteLayout extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        body: const ResponsiveWidget(
          largeScreen: LargeScreen(),
          smallScreen: SmallScreen(),
        ));
  }
}
