import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

abstract class AppTheme {
  static ThemeData get light {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        elevation: 0,
        color: Colors.transparent,
        foregroundColor: Colors.black,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        systemOverlayStyle: darkSystemUiOverlayStyle,
        centerTitle: true,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF3E3E3E),
          side: const BorderSide(
            color: AppColors.primary,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 8.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shadowColor: Colors.transparent,
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.disabledButton,
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 8.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: const BorderSide(
              color: Color(0xFFF8F8F8),
            ),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 8.0,
          ),
        ),
      ),
      scaffoldBackgroundColor: Colors.white,
      primaryColor: AppColors.primary,
      splashColor: Colors.transparent,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: AppColors.secondary,
      ),
      fontFamily: 'Poppins',
    );
  }
}

const lightSystemUiOverlayStyle = SystemUiOverlayStyle(
  systemNavigationBarColor: Color(0xFF000000),
  systemNavigationBarIconBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
  statusBarColor: Colors.transparent,
);

const darkSystemUiOverlayStyle = SystemUiOverlayStyle(
  systemNavigationBarColor: Color(0xFF000000),
  systemNavigationBarIconBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
  statusBarColor: Colors.transparent,
);
