import 'package:flutter/material.dart';
import '../../constants/index_constant.dart';

class RAppBarTheme {
  RAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    scrolledUnderElevation: 0,
    backgroundColor: RColors.primary,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: RColors.black, size: RSizes.iconMd),
    actionsIconTheme: IconThemeData(color: RColors.black, size: RSizes.iconMd),
    titleTextStyle: TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w600, color: RColors.black),
  );
  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    scrolledUnderElevation: 0,
    backgroundColor: RColors.primary,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: RColors.white, size: RSizes.iconMd),
    actionsIconTheme: IconThemeData(color: RColors.white, size: RSizes.iconMd),
    titleTextStyle: TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w600, color: RColors.white),
  );
}
