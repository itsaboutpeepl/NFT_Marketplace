import 'package:flutter/material.dart';
import 'package:nftapp/constants/style.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? size;
  final Color? color;
  final FontWeight? weight;

  const CustomText({required this.text, this.size, this.color, this.weight});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: size ?? 20,
          color: color ?? callToAction,
          fontWeight: weight ?? FontWeight.normal),
    );
  }
}

class CustomText2 extends StatelessWidget {
  final String text;
  final double? size;
  final Color? color;
  final FontWeight? weight;

  const CustomText2({required this.text, this.size, this.color, this.weight});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: size ?? 20,
          color: color ?? callToAction,
          fontWeight: weight ?? FontWeight.normal),
    );
  }
}
