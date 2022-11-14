import 'package:dark_todo/app/widgets/text_form.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TaskTypeCE extends StatefulWidget {
  const TaskTypeCE({super.key});

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
