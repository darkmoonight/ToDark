import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShedulePage extends StatelessWidget {
  const ShedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    var tag = Localizations.maybeLocaleOf(context)?.toLanguageTag();
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.w),
            child: CalendarTimeline(
              initialDate: DateTime.now(),
              firstDate: DateTime(2022, 09, 01),
              lastDate: DateTime(2100, 09, 01),
              onDateSelected: (date) {},
              monthColor: Colors.grey[400],
              dayColor: Colors.grey[600],
              activeDayColor: Colors.white,
              activeBackgroundDayColor: Colors.blue,
              dotsColor: theme.primaryColor,
              // selectableDayPredicate: (date) => date.day != 23,
              locale: '$tag',
            ),
          ),
        ],
      )),
    );
  }
}
