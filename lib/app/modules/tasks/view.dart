import 'package:dark_todo/app/data/schema.dart';
import 'package:dark_todo/app/widgets/select_button.dart';
import 'package:dark_todo/app/widgets/task_type_cu.dart';
import 'package:dark_todo/app/widgets/todos_ce.dart';
import 'package:dark_todo/app/widgets/todos_list.dart';
import 'package:dark_todo/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:isar/isar.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({
    super.key,
    required this.id,
    required this.title,
    required this.desc,
    required this.task,
  });
  final int id;
  final String title;
  final String desc;
  final Tasks task;

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

  @override
  void initState() {
    myColor = const Color(0xFF2196F3);
    getTodo();
    super.initState();
  }

  getTodo() async {
    final todosCollection = isar.todos;
    final getTodos = await todosCollection
        .filter()
        .task((q) => q.idEqualTo(widget.id))
        .findAll();
    setState(() {
      todos = getTodos;
      isLoaded = true;
    });
  }

  deleteTodo(todos) async {
    await isar.writeTxn(() async {
      await isar.todos.delete(todos.id);
    });
    getTodo();
  }

  addTodo() async {
    final todosCreate = Todos(
      name: titleEdit.text,
      description: descEdit.text,
      todoTimeCompleted: timeEdit.text,
    )..task.value = widget.task;

    await isar.writeTxn(() async {
      await isar.todos.put(todosCreate);
      await todosCreate.task.save();
    });
    getTodo();
    titleEdit.clear();
    descEdit.clear();
    timeEdit.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
              child: Row(
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Iconsax.arrow_left_1),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: context.theme.textTheme.headline1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                widget.desc,
                                style: context.theme.textTheme.subtitle2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
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
                                titleTaskEdit =
                                    TextEditingController(text: widget.title);
                                descTaskEdit =
                                    TextEditingController(text: widget.desc);
                                return TaskTypeCu(
                                  text: 'Редактирование',
                                  save: () {},
                                  titleEdit: titleTaskEdit,
                                  descEdit: descTaskEdit,
                                  color: myColor,
                                  pickerColor: (Color color) =>
                                      setState(() => myColor = color),
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
                                'Задачи',
                                style: context.theme.textTheme.headline1
                                    ?.copyWith(
                                        color: context.theme.backgroundColor),
                              ),
                              Text(
                                '(1/2) Завершено',
                                style: context.theme.textTheme.subtitle2,
                              ),
                            ],
                          ),
                          SelectButton(
                            icons: const [
                              Icon(
                                Iconsax.close_circle,
                                color: Colors.black,
                              ),
                              Icon(
                                Iconsax.tick_circle,
                                color: Colors.black,
                              ),
                            ],
                            onToggleCallback: (value) {
                              setState(() {
                                toggleValue = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    TodosList(
                      isLoaded: isLoaded,
                      todos: todos,
                      deleteTodo: deleteTodo,
                      editTodo: () {
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
                            return TodosCe(
                              text: 'Создание',
                              save: () {},
                              titleEdit: titleEdit,
                              descEdit: descEdit,
                              timeEdit: timeEdit,
                            );
                          },
                        );
                      },
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
                text: 'Создание',
                save: () {
                  addTodo();
                },
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
          color: Colors.white,
        ),
      ),
    );
  }
}
