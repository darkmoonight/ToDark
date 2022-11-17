import 'package:dark_todo/app/data/schema.dart';
import 'package:dark_todo/app/widgets/select_button.dart';
import 'package:dark_todo/app/widgets/task_type_cu.dart';
import 'package:dark_todo/app/widgets/text_form.dart';
import 'package:dark_todo/main.dart';
import 'package:flutter/cupertino.dart';
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
  late bool isChecked = false;
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

  updateTask() async {
    await isar.writeTxn(() async {
      widget.task.title = titleTaskEdit.text;
      widget.task.description = descTaskEdit.text;
      widget.task.taskColor = myColor.hashCode;
      await isar.tasks.put(widget.task);
    });
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
    Color getColor(Set<MaterialState> states) {
      <MaterialState>{
        MaterialState.pressed,
      };
      return Colors.black;
    }

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
                                  save: () {
                                    updateTask();
                                  },
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
                    Expanded(
                      child: Visibility(
                        visible: isLoaded,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: Visibility(
                          visible: todos.isNotEmpty,
                          replacement: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/AddTasks.png',
                                    scale: 5,
                                  ),
                                  Text(
                                    'Добавьте задачу',
                                    style: context.theme.textTheme.headline4
                                        ?.copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: todos.length,
                            itemBuilder: (BuildContext context, int index) {
                              final todo = todos[index];
                              return Dismissible(
                                key: ObjectKey(todos),
                                direction: DismissDirection.endToStart,
                                onDismissed: (DismissDirection direction) {
                                  deleteTodo(todo);
                                },
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  child: const Padding(
                                    padding: EdgeInsets.only(
                                      right: 15,
                                    ),
                                    child: Icon(
                                      Iconsax.trush_square,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 20, left: 20, bottom: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    // color: Colors.white,
                                  ),
                                  child: CupertinoButton(
                                    minSize: double.minPositive,
                                    padding: EdgeInsets.zero,
                                    onPressed: () {},
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                checkColor: Colors.white,
                                                fillColor: MaterialStateProperty
                                                    .resolveWith(getColor),
                                                value: isChecked,
                                                shape: const CircleBorder(),
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    isChecked = value!;
                                                  });
                                                },
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      todo.name,
                                                      style: context.theme
                                                          .textTheme.headline4
                                                          ?.copyWith(
                                                        color: Colors.black,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      todo.description,
                                                      style: context.theme
                                                          .textTheme.subtitle2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          todo.todoTimeCompleted,
                                          style:
                                              context.theme.textTheme.subtitle2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
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
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 5, right: 10),
                        child: Row(
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      titleEdit.clear();
                                      descEdit.clear();
                                      timeEdit.clear();
                                      Get.back();
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                    ),
                                  ),
                                  Text(
                                    'Создание',
                                    style: context.theme.textTheme.headline2,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                addTodo();
                                Get.back();
                              },
                              icon: const Icon(
                                Icons.save,
                              ),
                            ),
                          ],
                        ),
                      ),
                      MyTextForm(
                        textEditingController: titleEdit,
                        hintText: 'Имя',
                        type: TextInputType.text,
                        icon: const Icon(Iconsax.edit_2),
                        password: false,
                        autofocus: false,
                      ),
                      MyTextForm(
                        textEditingController: descEdit,
                        hintText: 'Описание',
                        type: TextInputType.text,
                        icon: const Icon(Iconsax.note_text),
                        password: false,
                        autofocus: false,
                      ),
                      MyTextForm(
                        textEditingController: timeEdit,
                        hintText: 'Время выполнения',
                        type: TextInputType.datetime,
                        icon: const Icon(Iconsax.clock),
                        password: false,
                        autofocus: false,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
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
