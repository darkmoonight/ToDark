import 'package:dark_todo/app/core/values/colors.dart';
import 'package:dark_todo/app/core/values/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

List<Icon> getIcons() {
  return [
    Icon(
      const IconData(personIcon, fontFamily: 'MaterialIcons'),
      color: purple,
      size: 20.sp,
    ),
    Icon(
      const IconData(workIcon, fontFamily: 'MaterialIcons'),
      color: pink,
      size: 20.sp,
    ),
    Icon(
      const IconData(movieIcon, fontFamily: 'MaterialIcons'),
      color: green,
      size: 20.sp,
    ),
    Icon(
      const IconData(sportIcon, fontFamily: 'MaterialIcons'),
      color: yellow,
      size: 20.sp,
    ),
    Icon(
      const IconData(travelIcon, fontFamily: 'MaterialIcons'),
      color: deepPink,
      size: 20.sp,
    ),
    Icon(
      const IconData(shopIcon, fontFamily: 'MaterialIcons'),
      color: lightOrange,
      size: 20.sp,
    ),
    Icon(
      const IconData(gameIcon, fontFamily: 'MaterialIcons'),
      color: ultraLightBlue,
      size: 20.sp,
    ),
  ];
}
