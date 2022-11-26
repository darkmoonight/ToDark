import 'package:dark_todo/app/data/schema.dart';
import 'package:dark_todo/app/services/notification.dart';
import 'package:dark_todo/app/widgets/select_button.dart';
import 'package:dark_todo/app/widgets/task_type_cu.dart';
import 'package:dark_todo/app/widgets/todos_ce.dart';
import 'package:dark_todo/app/widgets/todos_list.dart';
import 'package:dark_todo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:isar/isar.dart';
// ignore_for_file: depend_on_referenced_packages

class TaskPage extends StatefulWidget {
  const TaskPage({
    super.key,
    required this.task,
    required this.back,
  });

  final Tasks task;
  final Function() back;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  int toggleValue = 0;
  late Color myColor;
  TextEditingController titleEdit = TextEditingController();
  TextEditingController descEdit = TextEditingController();
  TextEditingController timeEdit = TextEditingController();

  late TextEditingController titleTaskEdit;
  late TextEditingController descTaskEdit;

  var todos = <Todos>[];
  bool isLoaded = false;

  int countTotalTodos = 0;
  int countDoneTodos = 0;

  @override
  void initState() {
    myColor = Color(widget.task.taskColor);
    getTodo();
    super.initState();
  }

  getTodo() async {
    final todosCollection = isar.todos;
    List<Todos> getTodos;
    toggleValue == 0
        ? getTodos = await todosCollection
            .filter()
            .task((q) => q.idEqualTo(widget.task.id))
            .doneEqualTo(false)
            .findAll()
        : getTodos = await todosCollection
            .filter()
            .task((q) => q.idEqualTo(widget.task.id))
            .doneEqualTo(true)
            .findAll();
    countTotalTodos = await getCountTotalTodos();
    countDoneTodos = await getCountDoneTodos();
    toggleValue;
    setState(() {
      todos = getTodos;
      isLoaded = true;
    });
  }

  updateTask() async {
    await isar.writeTxn(() async {
      widget.task.title = titleTaskEdit.text;
      widget.task.description = descTaskEdit.text;
      widget.task.taskColor = myColor.hashCode;
      await isar.tasks.put(widget.task);
    });
    EasyLoading.showSuccess('editCategory'.tr,
        duration: const Duration(milliseconds: 500));
    widget.back();
    getTodo();
  }

  getCountTotalTodos() async {
    int res;
    final todosCollection = isar.todos;
    List<Todos> getTodos;
    getTodos = await todosCollection
        .filter()
        .task((q) => q.idEqualTo(widget.task.id))
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
        .task((q) => q.idEqualTo(widget.task.id))
        .doneEqualTo(true)
        .findAll();

    res = getTodos.length;
    return res;
  }

  deleteTodo(Todos todos) async {
    await isar.writeTxn(() async {
      await isar.todos.delete(todos.id);
      if (todos.todoCompletedTime != null) {
        await flutterLocalNotificationsPlugin.cancel(todos.id);
      }
    });
    EasyLoading.showSuccess('taskDelete'.tr,
        duration: const Duration(milliseconds: 500));
    getTodo();
  }

  addTodo() async {
    final todosCreate = Todos(
      name: titleEdit.text,
      description: descEdit.text,
      todoCompletedTime: DateTime.tryParse(timeEdit.text),
    )..task.value = widget.task;

    final todosCollection = isar.todos;
    List<Todos> getTodos;

    getTodos = await todosCollection
        .filter()
        .nameEqualTo(titleEdit.text)
        .task((q) => q.idEqualTo(widget.task.id))
        .findAll();

    if (getTodos.isEmpty) {
      await isar.writeTxn(() async {
        await isar.todos.put(todosCreate);
        await todosCreate.task.save();
        if (todosCreate.todoCompletedTime != null) {
          NotificationShow().showNotification(
            todosCreate.id,
            todosCreate.name,
            todosCreate.description,
            todosCreate.todoCompletedTime,
          );
        }
      });
      EasyLoading.showSuccess('taskCreate'.tr,
          duration: const Duration(milliseconds: 500));
    } else {
      EasyLoading.showError('duplicateTask'.tr,
          duration: const Duration(milliseconds: 500));
    }
    getTodo();
    titleEdit.clear();
    descEdit.clear();
    timeEdit.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.back();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                child: Row(
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              widget.back();
                              Get.back();
                            },
                            icon: const Icon(Iconsax.arrow_left_1),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                          Expanded(
                            child: widget.task.description.isNotEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.task.title,
                                        style:
                                            context.theme.textTheme.headline1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        widget.task.description,
                                        style:
                                            context.theme.textTheme.subtitle2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  )
                                : Text(
                                    widget.task.title,
                                    style: context.theme.textTheme.headline1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ),
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                enableDrag: false,
                                backgroundColor:
                                    context.theme.scaffoldBackgroundColor,
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  titleTaskEdit = TextEditingController(
                                    text: widget.task.title,
                                  );
                                  descTaskEdit = TextEditingController(
                                    text: widget.task.description,
                                  );
                                  return TaskTypeCu(
                                    text: 'editing'.tr,
                                    save: updateTask,
                                    titleEdit: titleTaskEdit,
                                    descEdit: descTaskEdit,
                                    color: myColor,
                                    pickerColor: (Color color) => setState(
                                      () => myColor = color,
                                    ),
                                  );
                                },
                              );
                            },
                            icon: const Icon(Iconsax.edit),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
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
                                  style: context.theme.textTheme.headline1
                                      ?.copyWith(
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
                              backgroundColor:
                                  context.theme.scaffoldBackgroundColor,
                            ),
                          ],
                        ),
                      ),
                      TodosList(
                        getTodo: getTodo,
                        isAllTask: false,
                        isCalendare: false,
                        toggleValue: toggleValue,
                        isLoaded: isLoaded,
                        todos: todos,
                        deleteTodo: deleteTodo,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              enableDrag: false,
              backgroundColor: context.theme.scaffoldBackgroundColor,
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              builder: (BuildContext context) {
                return TodosCe(
                  isCategory: false,
                  text: 'create'.tr,
                  save: addTodo,
                  titleEdit: titleEdit,
                  descEdit: descEdit,
                  timeEdit: timeEdit,
                );
              },
            );
          },
          elevation: 0,
          backgroundColor: context.theme.primaryColor,
          child: const Icon(
            Iconsax.add,
            color: Colors.greenAccent,
          ),
        ),
      ),
    );
  }
}
