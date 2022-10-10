import 'package:dark_todo/app/core/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/utils/extensions.dart';
import '../detail/view.dart';
import '../home/controller.dart';

class ShedulePage extends StatefulWidget {
  const ShedulePage({super.key});

  @override
  State<ShedulePage> createState() => _ShedulePageState();
}

class _ShedulePageState extends State<ShedulePage> {
  final homeCtrl = Get.find<HomeController>();

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
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Text(
                'Невыполненные задачи',
                style: theme.textTheme.headline2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            // TableCalendar(
            //   startingDayOfWeek: StartingDayOfWeek.monday,
            //   firstDay: DateTime(2022, 09, 01),
            //   lastDay: DateTime(2100, 09, 01),
            //   focusedDay: selectedDay,
            //   locale: '$tag',
            //   selectedDayPredicate: (day) {
            //     return isSameDay(selectedDay, day);
            //   },
            //   onDaySelected: (selected, focused) {
            //     setState(
            //       () {
            //         selectedDay = selected;
            //         focusedDay = focused;
            //       },
            //     );
            //   },
            //   onPageChanged: (focused) {
            //     focusedDay = focused;
            //   },
            //   availableCalendarFormats: {
            //     CalendarFormat.month: AppLocalizations.of(context)!.month,
            //     CalendarFormat.twoWeeks: AppLocalizations.of(context)!.two_week,
            //     CalendarFormat.week: AppLocalizations.of(context)!.week
            //   },
            //   calendarFormat: calendarFormat,
            //   onFormatChanged: (format) {
            //     setState(
            //       () {
            //         calendarFormat = format;
            //       },
            //     );
            //   },
            // ),
            Divider(
              color: theme.dividerColor,
              height: 10.w,
              thickness: 2,
              indent: 10.w,
              endIndent: 10.w,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: homeCtrl.tasks.length,
                itemBuilder: (context, index) {
                  final task = homeCtrl.tasks[index];
                  var color = HexColor.fromHex(task.color);
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: task.todos?.length,
                    itemBuilder: (context, index) {
                      final todo = task.todos?[index];
                      return Padding(
                        padding:
                            EdgeInsets.only(left: 10.w, right: 10.w, top: 10.w),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 5.w, right: 5.w),
                            child: CupertinoButton(
                              onPressed: () {
                                homeCtrl.changeTask(task);
                                homeCtrl.changeTodos(task.todos ?? []);
                                Get.to(() => const DetailPage(),
                                    transition: Transition.downToUp);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        IconData(task.icon,
                                            fontFamily: 'MaterialIcons'),
                                        color: color,
                                        size: 20.sp,
                                      ),
                                      Flexible(
                                          child: SizedBox(
                                        width: 5.w,
                                      )),
                                      Text(
                                        task.title,
                                        style: TextStyle(
                                          color: color,
                                          fontSize: 16.w,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        ' - ',
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.headline6,
                                      ),
                                      Text(
                                        todo['title'],
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.headline6,
                                      ),
                                    ],
                                  ),
                                  todo['desc'].toString().isEmpty
                                      ? const SizedBox.shrink()
                                      : Flexible(child: SizedBox(height: 10.w)),
                                  todo['desc'].toString().isEmpty
                                      ? const SizedBox.shrink()
                                      : Text(
                                          todo['desc'],
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              theme.primaryTextTheme.subtitle2,
                                        ),
                                  todo['date'].toString().isEmpty
                                      ? const SizedBox.shrink()
                                      : Flexible(child: SizedBox(height: 10.w)),
                                  todo['date'].toString().isEmpty
                                      ? const SizedBox.shrink()
                                      : Text(
                                          todo['date'],
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              theme.primaryTextTheme.subtitle2,
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
