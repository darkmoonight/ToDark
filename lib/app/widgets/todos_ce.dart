import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:isar/isar.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/app/services/isar_service.dart';
import 'package:todark/app/widgets/text_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todark/main.dart';

class TodosCe extends StatefulWidget {
  const TodosCe({
    super.key,
    required this.text,
    required this.edit,
    required this.category,
    required this.set,
    this.task,
    this.todo,
  });
  final String text;
  final Tasks? task;
  final Todos? todo;
  final bool edit;
  final bool category;
  final Function() set;

  @override
  State<TodosCe> createState() => _TodosCeState();
}

class _TodosCeState extends State<TodosCe> {
  final formKey = GlobalKey<FormState>();
  final service = IsarServices();
  final locale = Get.locale;
  Tasks? selectedTask;
  List<Tasks>? taskList;

  @override
  initState() {
    getTodosAll();
    if (widget.edit == true) {
      service.titleEdit.value = service.titleEdit.value =
          TextEditingController(text: widget.todo!.name);
      service.descEdit.value = service.descEdit.value =
          TextEditingController(text: widget.todo!.description);
      service.timeEdit.value = service.timeEdit.value = TextEditingController(
          text: widget.todo!.todoCompletedTime != null
              ? widget.todo!.todoCompletedTime.toString()
              : '');
    }
    super.initState();
  }

  getTodosAll() async {
    final todosCollection = isar.tasks;
    List<Tasks> getTasks;
    getTasks = await todosCollection.filter().archiveEqualTo(false).findAll();
    setState(() {
      taskList = getTasks;
    });
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
                              service.timeEdit.value.clear();
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
                          textTrim(service.titleEdit.value);
                          textTrim(service.descEdit.value);
                          widget.category == false
                              ? service.addTodo(
                                  widget.task,
                                  service.titleEdit.value,
                                  service.descEdit.value,
                                  service.timeEdit.value,
                                  widget.set,
                                )
                              : widget.edit == false
                                  ? service.addTodo(
                                      selectedTask,
                                      service.titleEdit.value,
                                      service.descEdit.value,
                                      service.timeEdit.value,
                                      widget.set,
                                    )
                                  : widget.task != null
                                      ? service.updateTodo(
                                          widget.todo,
                                          widget.task,
                                          service.titleEdit.value,
                                          service.descEdit.value,
                                          service.timeEdit.value,
                                        )
                                      : service.updateTodo(
                                          widget.todo,
                                          selectedTask,
                                          service.titleEdit.value,
                                          service.descEdit.value,
                                          service.timeEdit.value,
                                        );

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
                textEditingController: service.titleEdit.value,
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
                textEditingController: service.descEdit.value,
                hintText: 'description'.tr,
                type: TextInputType.text,
                icon: const Icon(Iconsax.note_text),
              ),
              MyTextForm(
                readOnly: true,
                textEditingController: service.timeEdit.value,
                hintText: 'timeComlete'.tr,
                type: TextInputType.datetime,
                icon: const Icon(Iconsax.clock),
                iconButton: IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 18,
                  ),
                  onPressed: () {
                    service.timeEdit.value.clear();
                  },
                ),
                onTap: () {
                  DatePicker.showDateTimePicker(
                    context,
                    showTitleActions: true,
                    theme: DatePickerTheme(
                      backgroundColor: context.theme.scaffoldBackgroundColor,
                      cancelStyle: const TextStyle(color: Colors.red),
                      itemStyle: TextStyle(
                          color: context.theme.textTheme.headline6?.color),
                    ),
                    minTime: DateTime.now(),
                    maxTime: DateTime.now().add(const Duration(days: 1000)),
                    onConfirm: (date) {
                      service.timeEdit.value.text = date.toString();
                    },
                    currentTime: DateTime.now(),
                    locale: locale.toString() == 'ru_RU'
                        ? LocaleType.ru
                        : LocaleType.en,
                  );
                },
              ),
              widget.category == true
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Iconsax.folder_2),
                          fillColor: context.theme.primaryColor,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: context.theme.disabledColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: context.theme.disabledColor,
                            ),
                          ),
                        ),
                        focusColor: Colors.transparent,
                        hint: Text(
                          "selectCategory".tr,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15.sp,
                          ),
                        ),
                        dropdownColor: context.theme.scaffoldBackgroundColor,
                        icon: const Icon(
                          Iconsax.arrow_down_1,
                        ),
                        isExpanded: true,
                        value: widget.todo != null
                            ? selectedTask = taskList?.firstWhere(
                                (e) => e.id == widget.todo!.task.value?.id)
                            : null,
                        items: taskList?.map((e) {
                          return DropdownMenuItem(
                              value: e, child: Text(e.title));
                        }).toList(),
                        onChanged: (Tasks? newValue) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {
                            selectedTask = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return "selectCategory".tr;
                          }
                          return null;
                        },
                      ),
                    )
                  : Container(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
