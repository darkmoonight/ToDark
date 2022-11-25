import 'package:dark_todo/app/widgets/todos_list.dart';
import 'package:dark_todo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:isar/isar.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../data/schema.dart';
import '../../widgets/select_button.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDay = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.week;

  var todos = <Todos>[];
  bool isLoaded = false;
  int toggleValue = 0;
  int countTotalTodos = 0;
  int countDoneTodos = 0;

  @override
  initState() {
    getTodo();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  getCountTotalTodos() async {
    int res;
    final todosCollection = isar.todos;
    List<Todos> getTodos;
    getTodos = await todosCollection
        .filter()
        .todoCompletedTimeIsNotNull()
        .todoCompletedTimeBetween(
            DateTime(
                selectedDay.year, selectedDay.month, selectedDay.day, 0, 0),
            DateTime(
                selectedDay.year, selectedDay.month, selectedDay.day, 23, 59))
        .task((q) => q.archiveEqualTo(false))
        .findAll();
    res = getTodos.length;
    return res;
  }

  getCountDoneTodos() async {
    int res;
    final todosCollection = isar.todos;
    List<Todos> getTodos;
    getTodos = await todosCollection
        .filter()
        .doneEqualTo(true)
        .todoCompletedTimeIsNotNull()
        .todoCompletedTimeBetween(
            DateTime(
                selectedDay.year, selectedDay.month, selectedDay.day, 0, 0),
            DateTime(
                selectedDay.year, selectedDay.month, selectedDay.day, 23, 59))
        .task((q) => q.archiveEqualTo(false))
        .findAll();
    res = getTodos.length;
    return res;
  }

  getTodo() async {
    final todosCollection = isar.todos;
    List<Todos> getTodos;
    toggleValue == 0
        ? getTodos = await todosCollection
            .filter()
            .doneEqualTo(false)
            .todoCompletedTimeIsNotNull()
            .todoCompletedTimeBetween(
                DateTime(
                    selectedDay.year, selectedDay.month, selectedDay.day, 0, 0),
                DateTime(selectedDay.year, selectedDay.month, selectedDay.day,
                    23, 59))
            .task((q) => q.archiveEqualTo(false))
            .findAll()
        : getTodos = await todosCollection
            .filter()
            .doneEqualTo(true)
            .todoCompletedTimeIsNotNull()
            .todoCompletedTimeBetween(
                DateTime(
                    selectedDay.year, selectedDay.month, selectedDay.day, 0, 0),
                DateTime(selectedDay.year, selectedDay.month, selectedDay.day,
                    23, 59))
            .task((q) => q.archiveEqualTo(false))
            .findAll();
    countTotalTodos = await getCountTotalTodos();
    countDoneTodos = await getCountDoneTodos();
    toggleValue;
    setState(() {
      todos = getTodos;
      isLoaded = true;
    });
  }

  deleteTodo(Todos todos) async {
    await isar.writeTxn(() async {
      await isar.todos.delete(todos.id);
      await flutterLocalNotificationsPlugin.cancel(todos.id);
    });
    EasyLoading.showSuccess('taskDelete'.tr,
        duration: const Duration(milliseconds: 500));
    getTodo();
  }

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
            getTodo();
          },
          onPageChanged: (focused) {
            setState(() {
              selectedDay = focused;
            });
            getTodo();
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'tasks'.tr,
                            style: context.theme.textTheme.headline1?.copyWith(
                                color: context.theme.backgroundColor),
                          ),
                          Text(
                            '($countDoneTodos/$countTotalTodos) ${'completed'.tr}',
                            style: context.theme.textTheme.subtitle2,
                          ),
                        ],
                      ),
                      SelectButton(
                        icons: [
                          Icon(
                            Iconsax.close_circle,
                            color: context.theme.scaffoldBackgroundColor,
                          ),
                          Icon(
                            Iconsax.tick_circle,
                            color: context.theme.scaffoldBackgroundColor,
                          ),
                        ],
                        onToggleCallback: (value) {
                          setState(() {
                            toggleValue = value;
                          });
                          getTodo();
                        },
                        backgroundColor: context.theme.scaffoldBackgroundColor,
                      ),
                    ],
                  ),
                ),
                TodosList(
                  toggleValue: toggleValue,
                  isAllTask: false,
                  isCalendare: true,
                  isLoaded: isLoaded,
                  todos: todos,
                  deleteTodo: deleteTodo,
                  getTodo: getTodo,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
