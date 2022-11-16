import 'package:dark_todo/app/data/schema.dart';
import 'package:dark_todo/app/widgets/text_form.dart';
import 'package:dark_todo/main.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TaskTypeCE extends StatefulWidget {
  const TaskTypeCE({
    super.key,
    required this.text,
  });
  final String text;

  @override
  State<TaskTypeCE> createState() => _TaskTypeCEState();
}

class _TaskTypeCEState extends State<TaskTypeCE> {
  late Color myColor;

  @override
  void initState() {
    myColor = Colors.blue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController titleEdit = TextEditingController();
    TextEditingController descEdit = TextEditingController();
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
              padding: const EdgeInsets.only(top: 10, left: 5, right: 10),
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
                          widget.text,
                          style: context.theme.textTheme.headline2,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final pancakes = Tasks(
                        title: titleEdit.text,
                        taskCreate: DateTime.now(),
                        taskColor: myColor.hashCode,
                        description: descEdit.text,
                      );

                      await isar.writeTxn(() async {
                        await isar.tasks.put(pancakes);
                      });
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
              onColorChanged: (Color color) => setState(() => myColor = color),
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
  }
}
