import 'package:dark_todo/app/widgets/select_button.dart';
import 'package:dark_todo/app/widgets/text_form.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  int toggleValue = 0;
  late bool isChecked = false;
  late Color myColor;

  @override
  void initState() {
    myColor = Colors.blue;
    super.initState();
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
                                'Comrun',
                                style: context.theme.textTheme.headline1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Раннер про компьютер',
                                style: context.theme.textTheme.subtitle2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
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
                                return SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10, top: 15),
                                          child: Text(
                                            'Редактирование',
                                            style: context
                                                .theme.textTheme.headline2,
                                          ),
                                        ),
                                        const MyTextForm(
                                          hintText: 'Имя',
                                          type: TextInputType.text,
                                          icon: Icon(Iconsax.edit_2),
                                          password: false,
                                          autofocus: false,
                                        ),
                                        const MyTextForm(
                                          hintText: 'Описание',
                                          type: TextInputType.text,
                                          icon: Icon(Iconsax.note_text),
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
                                          pickersEnabled: const <
                                              ColorPickerType, bool>{
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
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: 15,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            key: const ObjectKey(1),
                            direction: DismissDirection.endToStart,
                            onDismissed: (DismissDirection direction) {},
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
                                onPressed: () {
                                  showModalBottomSheet(
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
                                      return SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10, top: 15),
                                                child: Text(
                                                  'Редактирование',
                                                  style: context.theme.textTheme
                                                      .headline2,
                                                ),
                                              ),
                                              const MyTextForm(
                                                hintText: 'Имя',
                                                type: TextInputType.text,
                                                icon: Icon(Iconsax.edit_2),
                                                password: false,
                                                autofocus: true,
                                              ),
                                              const MyTextForm(
                                                hintText: 'Описание',
                                                type: TextInputType.text,
                                                icon: Icon(Iconsax.note_text),
                                                password: false,
                                                autofocus: false,
                                              ),
                                              const MyTextForm(
                                                hintText: 'Время выполнения',
                                                type: TextInputType.datetime,
                                                icon: Icon(Iconsax.clock),
                                                password: false,
                                                autofocus: false,
                                              ),
                                              const SizedBox(height: 15),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
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
                                                  'TileMap',
                                                  style: context
                                                      .theme.textTheme.headline4
                                                      ?.copyWith(
                                                    color: Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  'Составить карту тайлов',
                                                  style: context.theme.textTheme
                                                      .subtitle2,
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
                                      '13.12 15:46',
                                      style: context.theme.textTheme.subtitle2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
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
                        padding: const EdgeInsets.only(bottom: 10, top: 15),
                        child: Text(
                          'Создание',
                          style: context.theme.textTheme.headline2,
                        ),
                      ),
                      const MyTextForm(
                        hintText: 'Имя',
                        type: TextInputType.text,
                        icon: Icon(Iconsax.edit_2),
                        password: false,
                        autofocus: true,
                      ),
                      const MyTextForm(
                        hintText: 'Описание',
                        type: TextInputType.text,
                        icon: Icon(Iconsax.note_text),
                        password: false,
                        autofocus: false,
                      ),
                      const MyTextForm(
                        hintText: 'Время выполнения',
                        type: TextInputType.datetime,
                        icon: Icon(Iconsax.clock),
                        password: false,
                        autofocus: false,
                      ),
                      const SizedBox(height: 15),
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
