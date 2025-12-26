import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AppFonts {
  static const String bodyFontFamily = 'worksans';
  static const String headerFontFamily = 'montserrat';

  static const TextStyle titleFont = TextStyle(
    fontFamily: headerFontFamily,
    fontWeight: FontWeight.w900,
    /*fontVariations: [
      FontVariation(
              'wght', 700.0)
    ],*/
    fontSize: 30.0,
    color: Colors.black,
  );

  static const TextStyle headerFont = TextStyle(
    fontFamily: headerFontFamily,
    fontWeight: FontWeight.w900,
    /*fontVariations: [
      FontVariation(
              'wght', 700.0)
    ],*/
    fontSize: 20.0,
    color: Colors.black,
  );

  static const TextStyle catFont = TextStyle(
    fontFamily: headerFontFamily,
    fontWeight: FontWeight.w900,
    /*fontVariations: [
      FontVariation(
              'wght', 700.0)
    ],*/
    fontSize: 16.0,
    color: Colors.black,
  );

  static const TextStyle bodyFont = TextStyle(
    fontFamily: bodyFontFamily,
    fontWeight: FontWeight.w400,
    /*fontVariations: [
      FontVariation(
              'wght', 350.0)
    ],*/
    fontSize: 16.0,
    color: Colors.black,
  );

  double weightFromFontWeight(FontWeight weight) {
    // FontWeight.w100 → 100, w900 → 900
    return (weight.index + 1) * 100.0;
  }

  static Style htmlFromTextStyle(TextStyle textStyle, {double? lineHeight}) {
    return Style(
      fontFamily: textStyle.fontFamily,
      fontSize: FontSize(textStyle.fontSize ?? 15),
      fontWeight: textStyle.fontWeight,
      lineHeight: lineHeight != null ? LineHeight.number(lineHeight) : null,
      color: textStyle.color,
    );
  }
}
