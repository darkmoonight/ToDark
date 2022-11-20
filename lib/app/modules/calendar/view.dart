import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDay = normalizeDate(DateTime.now());
  CalendarFormat calendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    final tag = Localizations.maybeLocaleOf(context)?.toLanguageTag();
    return Column(
      children: [
        TableCalendar(
          startingDayOfWeek: StartingDayOfWeek.monday,
          firstDay: DateTime(2022, 09, 01),
          lastDay: selectedDay.add(const Duration(days: 1000)),
          focusedDay: selectedDay,
          locale: '$tag',
          weekendDays: const [DateTime.sunday],
          availableCalendarFormats: {
            CalendarFormat.month: 'month'.tr,
            CalendarFormat.twoWeeks: 'two_week'.tr,
            CalendarFormat.week: 'week'.tr
          },
          selectedDayPredicate: (day) {
            return isSameDay(selectedDay, day);
          },
          onDaySelected: (selected, focused) {
            setState(() {
              selectedDay = selected;
            });
          },
          onPageChanged: (focused) {
            setState(() {
              selectedDay = focused;
            });
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
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 14),
            width: Get.size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 30, top: 20, bottom: 20, right: 20),
                  child: Text(
                    'tasks'.tr,
                    style: context.theme.textTheme.headline1
                        ?.copyWith(color: context.theme.backgroundColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
