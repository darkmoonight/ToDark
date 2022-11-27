import 'package:todark/app/widgets/text_form.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TaskTypeCu extends StatefulWidget {
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
  State<TaskTypeCu> createState() => _TaskTypeCuState();
}

class _TaskTypeCuState extends State<TaskTypeCu> {
  final formKey = GlobalKey<FormState>();

  textTrim(value) {
    value.text = value.text.trim();
    while (value.text.contains("  ")) {
      value.text = value.text.replaceAll("  ", " ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
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
                              widget.titleEdit.clear();
                              widget.descEdit.clear();
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
                        if (formKey.currentState!.validate()) {
                          textTrim(widget.titleEdit);
                          textTrim(widget.descEdit);
                          widget.save();
                          Get.back();
                        }
                      },
                      icon: const Icon(
                        Icons.save,
                      ),
                    ),
                  ],
                ),
              ),
              MyTextForm(
                textEditingController: widget.titleEdit,
                hintText: 'name'.tr,
                type: TextInputType.text,
                icon: const Icon(Iconsax.edit_2),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'validateName'.tr;
                  }
                  return null;
                },
              ),
              MyTextForm(
                textEditingController: widget.descEdit,
                hintText: 'description'.tr,
                type: TextInputType.text,
                icon: const Icon(Iconsax.note_text),
              ),
              ColorPicker(
                color: widget.color,
                onColorChanged: widget.pickerColor,
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
      ),
    );
  }
}
