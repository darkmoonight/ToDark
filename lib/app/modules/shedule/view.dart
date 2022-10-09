import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

class ShedulePage extends StatefulWidget {
  const ShedulePage({super.key});

  @override
  State<ShedulePage> createState() => _ShedulePageState();
}

class _ShedulePageState extends State<ShedulePage> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    final tag = Localizations.maybeLocaleOf(context)?.toLanguageTag();
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TableCalendar(
              startingDayOfWeek: StartingDayOfWeek.monday,
              firstDay: DateTime(2022, 09, 01),
              lastDay: DateTime(2100, 09, 01),
              focusedDay: selectedDay,
              locale: '$tag',
              selectedDayPredicate: (day) {
                return isSameDay(selectedDay, day);
              },
              onDaySelected: (selected, focused) {
                setState(
                  () {
                    selectedDay = selected;
                    focusedDay = focused;
                  },
                );
              },
              onPageChanged: (focused) {
                focusedDay = focused;
              },
              availableCalendarFormats: {
                CalendarFormat.month: AppLocalizations.of(context)!.month,
                CalendarFormat.twoWeeks: AppLocalizations.of(context)!.two_week,
                CalendarFormat.week: AppLocalizations.of(context)!.week
              },
              calendarFormat: calendarFormat,
              onFormatChanged: (format) {
                setState(
                  () {
                    calendarFormat = format;
                  },
                );
              },
            ),
            Divider(
              color: theme.dividerColor,
              height: 20.w,
              thickness: 2,
              indent: 10.w,
              endIndent: 10.w,
            ),
          ],
        ),
      ),
    );
  }
}
