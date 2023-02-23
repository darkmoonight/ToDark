import 'package:todark/app/data/schema.dart';
import 'package:todark/app/services/isar_service.dart';
import 'package:todark/app/widgets/text_form.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TaskTypeCu extends StatefulWidget {
  const TaskTypeCu({
    super.key,
    required this.text,
    required this.edit,
    this.task,
    this.set,
  });
  final String text;
  final bool edit;
  final Tasks? task;
  final Function()? set;

  @override
  State<TaskTypeCu> createState() => _TaskTypeCuState();
}

class _TaskTypeCuState extends State<TaskTypeCu> {
  final formKey = GlobalKey<FormState>();
  final service = IsarServices();

  @override
  initState() {
    if (widget.edit == true) {
      service.titleEdit.value = TextEditingController(text: widget.task!.title);
      service.descEdit.value =
          TextEditingController(text: widget.task!.description);
      service.myColor.value = Color(widget.task!.taskColor);
    }
    super.initState();
  }

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
                              service.titleEdit.value.clear();
                              service.descEdit.value.clear();

                              Get.back();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            widget.text,
                            style: context.theme.textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          textTrim(service.titleEdit.value);
                          textTrim(service.descEdit.value);
                          if (widget.edit == false) {
                            service.addTask(service.titleEdit.value,
                                service.descEdit.value, service.myColor.value);
                          } else {
                            service.updateTask(
                              widget.task!,
                              service.titleEdit.value,
                              service.descEdit.value,
                              service.myColor.value,
                            );
                            widget.set!();
                          }
                          Get.back();
                        }
                      },
                      icon: const Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              MyTextForm(
                controller: service.titleEdit.value,
                labelText: 'name'.tr,
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
                controller: service.descEdit.value,
                labelText: 'description'.tr,
                type: TextInputType.text,
                icon: const Icon(Iconsax.note_text),
              ),
              ColorPicker(
                color: service.myColor.value,
                onColorChanged: (Color color) => setState(
                  () {
                    service.myColor.value = color;
                  },
                ),
                borderRadius: 20,
                enableShadesSelection: false,
                enableTonalPalette: true,
                pickersEnabled: const <ColorPickerType, bool>{
                  ColorPickerType.accent: false,
                  ColorPickerType.primary: true,
                  ColorPickerType.wheel: false,
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
