import 'package:dark_todo/app/widgets/text_form.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TaskTypeCE extends StatefulWidget {
  const TaskTypeCE({
    super.key,
    required this.text,
    required this.onSave,
    this.initValueName = '',
    this.initValueDesk = '',
  });
  final String text;
  final Function() onSave;
  final String initValueName;
  final String initValueDesk;

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
                    onPressed: () {
                      widget.onSave();
                    },
                    icon: const Icon(
                      Icons.save,
                    ),
                  ),
                ],
              ),
            ),
            MyTextForm(
              hintText: 'Имя',
              initValue: widget.initValueName,
              type: TextInputType.text,
              icon: const Icon(Iconsax.edit_2),
              password: false,
              autofocus: false,
            ),
            MyTextForm(
              hintText: 'Описание',
              initValue: widget.initValueDesk,
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
