import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final ThemeData baseLigth = ThemeData.light();
final ThemeData baseDark = ThemeData.dark();

class TodoTheme {
  static ThemeData get darkTheme {
    return baseDark.copyWith(
      brightness: Brightness.dark,
      iconTheme: baseDark.iconTheme.copyWith(
        color: Colors.white,
        size: 20.sp,
      ),
      dividerColor: Colors.white,
      selectedRowColor: Colors.grey[200],
      primaryColor: const Color.fromARGB(255, 37, 36, 41),
      cardColor: const Color.fromARGB(255, 40, 40, 40),
      backgroundColor: Colors.black,
      unselectedWidgetColor: Colors.grey[200],
      scaffoldBackgroundColor: const Color(0xff191720),
      textTheme: baseDark.textTheme.copyWith(
        headline1: TextStyle(
          color: Colors.white,
          fontSize: 25.sp,
          fontWeight: FontWeight.bold,
        ),
        headline2: TextStyle(
          color: Colors.white,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
        headline3: TextStyle(color: Colors.white, fontSize: 18.sp),
        headline4: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
        headline5: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
        ),
        subtitle1: TextStyle(
          color: Colors.grey[300],
          fontSize: 16.sp,
        ),
        subtitle2: TextStyle(
          color: Colors.grey[700],
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      primaryTextTheme: baseLigth.primaryTextTheme.copyWith(
        subtitle1: TextStyle(
          color: Colors.grey,
          fontSize: 14.sp,
        ),
        subtitle2: TextStyle(
          color: Colors.grey,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
        headline4: TextStyle(
          color: Colors.white,
          fontSize: 15.sp,
        ),
        headline5: TextStyle(
          color: Colors.white,
          fontSize: 17.sp,
        ),
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
