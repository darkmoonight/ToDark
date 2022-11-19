import 'package:dark_todo/app/widgets/text_form.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TaskTypeCu extends StatelessWidget {
  const TaskTypeCu({
    super.key,
    required this.save,
    required this.titleEdit,
    required this.descEdit,
    required this.color,
    required this.pickerColor,
    required this.text,
  });
  final String text;
  final Function() save;
  final TextEditingController titleEdit;
  final TextEditingController descEdit;
  final Color color;
  final Function(Color) pickerColor;

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
                            titleEdit.clear();
                            descEdit.clear();
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.close,
                          ),
                        ),
                        Text(
                          text,
                          style: context.theme.textTheme.headline2,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      save();
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
            ),
            MyTextForm(
              textEditingController: descEdit,
              hintText: 'Описание',
              type: TextInputType.text,
              icon: const Icon(Iconsax.note_text),
            ),
            ColorPicker(
              color: color,
              onColorChanged: pickerColor,
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
