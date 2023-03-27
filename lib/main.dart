import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peeplDapp/Widgets/no_transition_web.dart';
import 'package:peeplDapp/constants/style.dart';
import 'package:peeplDapp/controllers/home_controller.dart';
import 'package:peeplDapp/controllers/navigation_controller.dart';
import 'package:peeplDapp/pages/404/error_page.dart';
import 'package:peeplDapp/routing/routes.dart';

import 'pages/layout.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  Get.put(HomeController());
  Get.put(NavigationController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: vestingPageRoute,
      unknownRoute: GetPage(
        name: "/not-found",
        page: () => PageNotFound(),
        transition: Transition.fadeIn,
      ),
      getPages: [
        GetPage(name: RootRoute, page: () => SiteLayout()),
      ],
      title: 'Peepl Vesting',
      theme: ThemeData(
        primaryColor: const Color(0xFF292B5E),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFFB21EC1),
        ),
        textTheme: GoogleFonts.bebasNeueTextTheme(Theme.of(context).textTheme.copyWith(
              bodyText1: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.white),
              bodyText2: Theme.of(context).textTheme.bodyText2!.apply(color: Colors.white),
            )).apply(),
        scaffoldBackgroundColor: scaffoldColor,
        canvasColor: const Color(0xFF1b162d),
        pageTransitionsTheme: WebTransitions(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
