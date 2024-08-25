import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/app/controller/todo_controller.dart';
import 'package:todark/app/services/utils.dart';
import 'package:todark/app/widgets/text_form.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TasksAction extends StatefulWidget {
  const TasksAction({
    super.key,
    required this.text,
    required this.edit,
    this.task,
    this.updateTaskName,
  });
  final String text;
  final bool edit;
  final Tasks? task;
  final Function()? updateTaskName;

  @override
  State<TasksAction> createState() => _TasksActionState();
}

class _TasksActionState extends State<TasksAction> {
  final formKey = GlobalKey<FormState>();
  final todoController = Get.put(TodoController());
  Color myColor = const Color(0xFF2196F3);

  @override
  initState() {
    if (widget.edit) {
      todoController.titleCategoryEdit =
          TextEditingController(text: widget.task!.title);
      todoController.descCategoryEdit =
          TextEditingController(text: widget.task!.description);
      myColor = Color(widget.task!.taskColor);
    }
    super.initState();
  }

  textTrim(value) {
    value.text = value.text.trim();
    while (value.text.contains('  ')) {
      value.text = value.text.replaceAll('  ', ' ');
    }
  }

  @override
  void dispose() {
    todoController.titleCategoryEdit.clear();
    todoController.descCategoryEdit.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Form(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () async {
                          if (todoController.titleCategoryEdit.text.length >
                                  20 ||
                              todoController.descCategoryEdit.text.length >
                                  20) {
                            showAdaptiveDialogTextIsNotEmpty(
                              context: context,
                              onPressed: () {
                                todoController.titleCategoryEdit.clear();
                                todoController.descCategoryEdit.clear();
                                Get.back(result: true);
                                Get.back();
                              },
                            );
                          } else {
                            todoController.titleCategoryEdit.clear();
                            todoController.descCategoryEdit.clear();
                            Get.back();
                          }
                        },
                        icon: const Icon(
                          IconsaxPlusLinear.close_square,
                          size: 20,
                        ),
                      ),
                      Text(
                        widget.text,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      IconButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            textTrim(todoController.titleCategoryEdit);
                            textTrim(todoController.descCategoryEdit);
                            if (widget.edit) {
                              todoController.updateTask(
                                widget.task!,
                                todoController.titleCategoryEdit.text,
                                todoController.descCategoryEdit.text,
                                myColor,
                              );
                              widget.updateTaskName!();
                            } else {
                              todoController.addTask(
                                  todoController.titleCategoryEdit.text,
                                  todoController.descCategoryEdit.text,
                                  myColor);
                              todoController.titleCategoryEdit.clear();
                              todoController.descCategoryEdit.clear();
                            }
                            Get.back();
                          }
                        },
                        icon: const Icon(
                          IconsaxPlusLinear.tick_square,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                MyTextForm(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  controller: todoController.titleCategoryEdit,
                  labelText: 'name'.tr,
                  type: TextInputType.text,
                  icon: const Icon(IconsaxPlusLinear.edit),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'validateName'.tr;
                    }
                    return null;
                  },
                ),
                MyTextForm(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  controller: todoController.descCategoryEdit,
                  labelText: 'description'.tr,
                  type: TextInputType.multiline,
                  icon: const Icon(IconsaxPlusLinear.note_text),
                  maxLine: null,
                ),
                Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    splashColor: Colors.transparent,
                    onTap: () async {
                      final Color newColor = await showColorPickerDialog(
                        context,
                        myColor,
                        borderRadius: 20,
                        enableShadesSelection: false,
                        enableTonalPalette: true,
                        pickersEnabled: const <ColorPickerType, bool>{
                          ColorPickerType.accent: false,
                          ColorPickerType.primary: true,
                          ColorPickerType.wheel: false,
                          ColorPickerType.both: false,
                        },
                      );
                      setState(() {
                        myColor = newColor;
                      });
                    },
                    leading: const Icon(IconsaxPlusLinear.colors_square),
                    title: Text(
                      'color'.tr,
                      style: context.textTheme.labelLarge,
                      overflow: TextOverflow.visible,
                    ),
                    trailing: ColorIndicator(
                      height: 25,
                      width: 25,
                      borderRadius: 20,
                      color: myColor,
                      onSelectFocus: false,
                    ),
                  ),
                ),
                const Gap(10)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
