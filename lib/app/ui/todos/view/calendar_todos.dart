import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:todark/app/controller/todo_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todark/app/ui/todos/widgets/todos_list.dart';
import 'package:todark/app/ui/todos/widgets/todos_transfer.dart';
import 'package:todark/app/ui/widgets/my_delegate.dart';
import 'package:todark/main.dart';

class CalendarTodos extends StatefulWidget {
  const CalendarTodos({super.key});

  @override
  State<CalendarTodos> createState() => _CalendarTodosState();
}

class _CalendarTodosState extends State<CalendarTodos> {
  final todoController = Get.put(TodoController());
  DateTime selectedDay = DateTime.now();
  DateTime firstDay = DateTime.now().add(const Duration(days: -1000));
  DateTime lastDay = DateTime.now().add(const Duration(days: 1000));
  CalendarFormat calendarFormat = CalendarFormat.week;

  StartingDayOfWeek firstDayOfWeek() {
    switch (settings.firstDay) {
      case 'monday':
        return StartingDayOfWeek.monday;
      case 'tuesday':
        return StartingDayOfWeek.tuesday;
      case 'wednesday':
        return StartingDayOfWeek.wednesday;
      case 'thursday':
        return StartingDayOfWeek.thursday;
      case 'friday':
        return StartingDayOfWeek.friday;
      case 'saturday':
        return StartingDayOfWeek.saturday;
      case 'sunday':
        return StartingDayOfWeek.sunday;
      default:
        return StartingDayOfWeek.monday;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: todoController.isPop.value,
        onPopInvokedWithResult: (didPop, value) {
          if (didPop) {
            return;
          }

          if (todoController.isMultiSelectionTodo.isTrue) {
            todoController.doMultiSelectionTodoClear();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: todoController.isMultiSelectionTodo.isTrue
                ? IconButton(
                    onPressed: () => todoController.doMultiSelectionTodoClear(),
                    icon: const Icon(
                      IconsaxPlusLinear.close_square,
                      size: 20,
                    ),
                  )
                : null,
            title: Text(
              'calendar'.tr,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              Visibility(
                visible: todoController.selectedTodo.isNotEmpty,
                replacement: const Offstage(),
                child: IconButton(
                  icon: const Icon(
                    IconsaxPlusLinear.arrange_square,
                    size: 20,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      enableDrag: false,
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return TodosTransfer(
                          text: 'editing'.tr,
                          todos: todoController.selectedTodo,
                        );
                      },
                    );
                  },
                ),
              ),
              Visibility(
                visible: todoController.selectedTodo.isNotEmpty,
                child: IconButton(
                  icon: const Icon(
                    IconsaxPlusLinear.trash_square,
                    size: 20,
                  ),
                  onPressed: () async {
                    await showAdaptiveDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog.adaptive(
                          title: Text(
                            'deletedTodo'.tr,
                            style: context.textTheme.titleLarge,
                          ),
                          content: Text(
                            'deletedTodoQuery'.tr,
                            style: context.textTheme.titleMedium,
                          ),
                          actions: [
                            TextButton(
                                onPressed: () => Get.back(),
                                child: Text('cancel'.tr,
                                    style: context.textTheme.titleMedium
                                        ?.copyWith(color: Colors.blueAccent))),
                            TextButton(
                                onPressed: () {
                                  todoController
                                      .deleteTodo(todoController.selectedTodo);
                                  todoController.doMultiSelectionTodoClear();
                                  Get.back();
                                },
                                child: Text('delete'.tr,
                                    style: context.textTheme.titleMedium
                                        ?.copyWith(color: Colors.red))),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          body: DefaultTabController(
            length: 2,
            child: NestedScrollView(
              physics: const NeverScrollableScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: TableCalendar(
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, day, events) {
                          return Obx(() {
                            var countTodos =
                                todoController.countTotalTodosCalendar(day);
                            return countTodos != 0
                                ? selectedDay.isAtSameMomentAs(day)
                                    ? Container(
                                        width: 16,
                                        height: 16,
                                        decoration: const BoxDecoration(
                                          color: Colors.amber,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '$countTodos',
                                            style: context.textTheme.bodyLarge
                                                ?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Text(
                                        '$countTodos',
                                        style: const TextStyle(
                                          color: Colors.amber,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      )
                                : const SizedBox.shrink();
                          });
                        },
                      ),
                      startingDayOfWeek: firstDayOfWeek(),
                      weekendDays: const [],
                      firstDay: firstDay,
                      lastDay: lastDay,
                      focusedDay: selectedDay,
                      locale: locale.languageCode,
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
                  ),
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverPersistentHeader(
                      delegate: MyDelegate(
                        TabBar(
                          tabAlignment: TabAlignment.start,
                          isScrollable: true,
                          dividerColor: Colors.transparent,
                          splashFactory: NoSplash.splashFactory,
                          overlayColor: WidgetStateProperty.resolveWith<Color?>(
                            (Set<WidgetState> states) {
                              return Colors.transparent;
                            },
                          ),
                          tabs: [
                            Tab(text: 'doing'.tr),
                            Tab(text: 'done'.tr),
                          ],
                        ),
                      ),
                      floating: true,
                      pinned: true,
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  TodosList(
                    calendare: true,
                    allTodos: false,
                    done: false,
                    selectedDay: selectedDay,
                    searchTodo: '',
                  ),
                  TodosList(
                    calendare: true,
                    allTodos: false,
                    done: true,
                    selectedDay: selectedDay,
                    searchTodo: '',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
