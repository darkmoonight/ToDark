import 'package:iconsax/iconsax.dart';
import 'package:isar/isar.dart';
import 'package:swipe/swipe.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/app/services/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todark/app/widgets/todos_ce.dart';
import 'package:todark/app/widgets/todos_list.dart';
import 'package:todark/main.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final service = IsarServices();
  final locale = Get.locale;
  DateTime selectedDay = DateTime.now();
  DateTime firstDay = DateTime.now().add(const Duration(days: -1000));
  DateTime lastDay = DateTime.now().add(const Duration(days: 1000));
  CalendarFormat calendarFormat = CalendarFormat.week;

  var todos = <Todos>[];
  int countTotalTodos = 0;
  int countDoneTodos = 0;

  @override
  void initState() {
    getCountTodos();
    getTodosAll();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  getCountTodos() async {
    final countTotal = await service.getCountTotalTodosCalendar(selectedDay);
    final countDone = await service.getCountDoneTodosCalendar(selectedDay);
    setState(() {
      countTotalTodos = countTotal;
      countDoneTodos = countDone;
    });
  }

  getTodosAll() async {
    final todosCollection = isar.todos;
    List<Todos> getTodos;
    getTodos = await todosCollection
        .filter()
        .doneEqualTo(false)
        .todoCompletedTimeIsNotNull()
        .task((q) => q.archiveEqualTo(false))
        .findAll();
    setState(() {
      todos = getTodos;
    });
  }

  int getCountTotalTodosCalendar(DateTime date) => todos
      .where((e) =>
          e.todoCompletedTime != null &&
          e.task.value!.archive == false &&
          DateTime(date.year, date.month, date.day, 0, -1)
              .isBefore(e.todoCompletedTime!) &&
          DateTime(date.year, date.month, date.day, 23, 60)
              .isAfter(e.todoCompletedTime!))
      .length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                return getCountTotalTodosCalendar(day) != 0
                    ? Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            getCountTotalTodosCalendar(day).toString(),
                            style: context.theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    : null;
              },
            ),
            startingDayOfWeek: StartingDayOfWeek.monday,
            firstDay: firstDay,
            lastDay: lastDay,
            focusedDay: selectedDay,
            locale: '${locale?.languageCode}',
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
              getCountTodos();
            },
            onPageChanged: (focused) {
              setState(() {
                selectedDay = focused;
              });
              getCountTodos();
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
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.secondaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30, top: 10, bottom: 5, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'tasks'.tr,
                              style:
                                  context.theme.textTheme.titleLarge?.copyWith(
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '($countDoneTodos/$countTotalTodos) ${'completed'.tr}',
                              style:
                                  context.theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          activeColor: Colors.white,
                          activeTrackColor: Colors.black,
                          thumbIcon: service.thumbIconTodo,
                          value: service.toggleValue.value,
                          onChanged: (value) {
                            setState(() {
                              service.toggleValue.value = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Swipe(
                      horizontalMinDisplacement: 20,
                      onSwipeLeft: () {
                        if (selectedDay.isBefore(lastDay)) {
                          selectedDay =
                              selectedDay.add(const Duration(days: 1));
                          setState(() {});
                        }
                      },
                      onSwipeRight: () {
                        if (selectedDay.isAfter(firstDay)) {
                          selectedDay =
                              selectedDay.add(const Duration(days: -1));
                          setState(() {});
                        }
                      },
                      child: TodosList(
                        calendare: true,
                        allTask: false,
                        toggle: service.toggleValue.value,
                        selectedDay: selectedDay,
                        set: () {
                          getCountTodos();
                          getTodosAll();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            enableDrag: false,
            backgroundColor: context.theme.scaffoldBackgroundColor,
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return TodosCe(
                text: "create".tr,
                edit: false,
                category: true,
                set: () {
                  getCountTodos();
                  getTodosAll();
                },
              );
            },
          );
        },
        backgroundColor: context.theme.colorScheme.primaryContainer,
        child: const Icon(
          Iconsax.add,
          color: Colors.greenAccent,
        ),
      ),
    );
  }
}
