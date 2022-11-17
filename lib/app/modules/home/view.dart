import 'package:dark_todo/app/data/schema.dart';
import 'package:dark_todo/app/modules/tasks/view.dart';
import 'package:dark_todo/app/widgets/select_button.dart';
import 'package:dark_todo/app/widgets/text_form.dart';
import 'package:dark_todo/main.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

import 'package:step_progress_indicator/step_progress_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int toggleValue = 0;
  bool isLoaded = false;
  var tasks = <Tasks>[];
  late Color myColor;
  TextEditingController titleEdit = TextEditingController();
  TextEditingController descEdit = TextEditingController();

  @override
  void initState() {
    myColor = const Color(0xFF2196F3);
    getTask();
    super.initState();
  }

  getTask() async {
    final taskCollection = isar.tasks;
    final getTask = await taskCollection.where().findAll();
    setState(() {
      tasks = getTask;
      isLoaded = true;
    });
  }

  addTask() async {
    final taskCreate = Tasks(
      title: titleEdit.text,
      description: descEdit.text,
      taskCreate: DateTime.now(),
      taskColor: myColor.hashCode,
    );

    await isar.writeTxn(() async {
      await isar.tasks.put(taskCreate);
    });
    getTask();
    titleEdit.clear();
    descEdit.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 30,
        title: Row(
          children: [
            Image.asset(
              'assets/icons/icons.png',
              scale: 13,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'ToDark',
              style: context.theme.textTheme.headline1,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                right: 20,
                left: 20,
                bottom: 30,
                top: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        CircularStepProgressIndicator(
                          totalSteps: 2,
                          currentStep: 1,
                          stepSize: 4,
                          selectedColor: Colors.blueAccent,
                          unselectedColor: Colors.white,
                          padding: 0,
                          selectedStepSize: 6,
                          roundedCap: (_, __) => true,
                          child: Center(
                            child: Text(
                              '50%',
                              style: context.theme.textTheme.headline2,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Text(
                            'Задач\nВыполнено',
                            style: context.theme.textTheme.headline5,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      DateFormat.MMMMd('ru').format(
                        DateTime.now(),
                      ),
                      style: context.theme.textTheme.headline6,
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
                                'Категории',
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
                          visible: tasks.isNotEmpty,
                          replacement: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/AddTasks.png',
                                    scale: 5,
                                  ),
                                  Text(
                                    'Добавьте категорию',
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
                            itemCount: tasks.length,
                            itemBuilder: (BuildContext context, int index) {
                              final task = tasks[index];
                              return Dismissible(
                                key: ObjectKey(tasks),
                                direction: DismissDirection.endToStart,
                                onDismissed:
                                    (DismissDirection direction) async {
                                  await isar.writeTxn(() async {
                                    await isar.tasks.delete(task.id);
                                  });
                                  getTask();
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
                                    bottom: 20,
                                    left: 25,
                                    right: 25,
                                  ),
                                  child: CupertinoButton(
                                    minSize: double.minPositive,
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Get.to(
                                        () => TaskPage(
                                          id: task.id,
                                          title: task.title,
                                          desc: task.description,
                                        ),
                                        transition: Transition.downToUp,
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                height: 60,
                                                width: 60,
                                                child:
                                                    CircularStepProgressIndicator(
                                                  totalSteps: 4,
                                                  currentStep: 1,
                                                  stepSize: 4,
                                                  selectedColor:
                                                      Color(task.taskColor),
                                                  unselectedColor:
                                                      Colors.grey[300],
                                                  padding: 0,
                                                  selectedStepSize: 6,
                                                  roundedCap: (_, __) => true,
                                                  child: Center(
                                                    child: Text(
                                                      '25%',
                                                      style: context.theme
                                                          .textTheme.headline6
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      task.title,
                                                      style: context.theme
                                                          .textTheme.headline4
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.black),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      task.description,
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
                                          '${task.taskCreate.day}.${task.taskCreate.month}.${task.taskCreate.year}',
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
                    )
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
                                addTask();
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
                      ColorPicker(
                        color: myColor,
                        onColorChanged: (Color color) =>
                            setState(() => myColor = color),
                        borderRadius: 20,
                        enableShadesSelection: false,
                        enableTonalPalette: true,
                        pickersEnabled: const <ColorPickerType, bool>{
                          ColorPickerType.accent: false,
                          ColorPickerType.primary: true,
                          ColorPickerType.wheel: true,
                          ColorPickerType.both: false,
                        },
                      ),
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
