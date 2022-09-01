import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showErrorSnack({
  required BuildContext context,
  String? title,
  int duration = 3,
  EdgeInsets? margin,
  String? message,
}) {
  Flushbar(
    boxShadows: const [
      BoxShadow(
        offset: Offset(0.5, 0.5),
        blurRadius: 5,
      ),
    ],
    duration: Duration(seconds: duration),
    titleText: const Text(
      'Wrong Chain! Please connect to FUSE Network \nAnd Refresh',
      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
    ),
    messageText: Text(
      message ?? "Try again later!",
      style: const TextStyle(
        fontSize: 14.0,
      ),
    ),
    backgroundColor: Theme.of(context).bottomAppBarColor,
    margin: margin ?? EdgeInsets.only(top: 8, right: 8, left: 8, bottom: MediaQuery.of(context).size.height * 0.01),
    borderRadius: const BorderRadius.all(
      Radius.circular(8.0),
    ),
  ).show(context);
}
