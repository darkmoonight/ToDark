import 'package:isar/isar.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/app/services/isar_service.dart';
import 'package:todark/app/widgets/text_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todark/main.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart'
    as date_picker_theme;

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
  List<Tasks>? task;
  final FocusNode focusNode = FocusNode();
  final textConroller = TextEditingController();

  @override
  initState() {
    if (widget.edit == true) {
      selectedTask = widget.todo!.task.value;
      textConroller.text = widget.todo!.task.value!.title;
      service.titleEdit.value = TextEditingController(text: widget.todo!.name);
      service.descEdit.value =
          TextEditingController(text: widget.todo!.description);
      service.timeEdit.value = TextEditingController(
          text: widget.todo!.todoCompletedTime != null
              ? widget.todo!.todoCompletedTime.toString()
              : '');
    }
    super.initState();
  }

  Future<List<Tasks>> getTodosAll(String pattern) async {
    final todosCollection = isar.tasks;
    List<Tasks> getTask;
    getTask = await todosCollection.filter().archiveEqualTo(false).findAll();
    return getTask.where((element) {
      final title = element.title.toLowerCase();
      final query = pattern.toLowerCase();
      return title.contains(query);
    }).toList();
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
                              textConroller.clear();
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
                  ],
                ),
              ),
              widget.category == true
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: RawAutocomplete<Tasks>(
                        focusNode: focusNode,
                        textEditingController: textConroller,
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController fieldTextEditingController,
                            FocusNode fieldFocusNode,
                            VoidCallback onFieldSubmitted) {
                          return TextFormField(
                            controller: textConroller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              labelText: "selectCategory".tr,
                              labelStyle:
                                  context.theme.textTheme.labelLarge?.copyWith(
                                color: Colors.grey,
                              ),
                              prefixIcon: const Icon(Iconsax.folder_2),
                              fillColor:
                                  context.theme.colorScheme.primaryContainer,
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
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  size: 18,
                                ),
                                onPressed: () {
                                  textConroller.clear();
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "selectCategory".tr;
                              }
                              return null;
                            },
                          );
                        },
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<Tasks>.empty();
                          }
                          return getTodosAll(textEditingValue.text);
                        },
                        onSelected: (Tasks selection) {
                          textConroller.text = selection.title;
                          selectedTask = selection;
                          focusNode.unfocus();
                        },
                        displayStringForOption: (Tasks option) => option.title,
                        optionsViewBuilder: (BuildContext context,
                            AutocompleteOnSelected<Tasks> onSelected,
                            Iterable<Tasks> options) {
                          return Align(
                            alignment: Alignment.topCenter,
                            child: Material(
                              color: context.theme.scaffoldBackgroundColor,
                              elevation: 4.0,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: options.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final Tasks tasks = options.elementAt(index);
                                  return InkWell(
                                    onTap: () => onSelected(tasks),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: ListTile(
                                        title: Text(
                                          tasks.title,
                                          style:
                                              context.theme.textTheme.bodyLarge,
                                        ),
                                        trailing: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: Color(tasks.taskColor),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(),
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
              Row(
                children: [
                  Flexible(
                    flex: 5,
                    child: MyTextForm(
                      readOnly: true,
                      controller: service.timeEdit.value,
                      labelText: 'timeComlete'.tr,
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
                          theme: date_picker_theme.DatePickerTheme(
                            backgroundColor:
                                context.theme.scaffoldBackgroundColor,
                            cancelStyle: const TextStyle(color: Colors.red),
                            itemStyle: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          minTime: DateTime.now(),
                          maxTime:
                              DateTime.now().add(const Duration(days: 1000)),
                          onConfirm: (date) {
                            service.timeEdit.value.text = date.toString();
                          },
                          currentTime: DateTime.now(),
                          locale: '${locale?.languageCode}' == 'ru'
                              ? LocaleType.ru
                              : '${locale?.languageCode}' == 'zh'
                                  ? LocaleType.zh
                                  : LocaleType.en,
                        );
                      },
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin:
                          const EdgeInsets.only(right: 10, bottom: 5, top: 10),
                      decoration: const BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: IconButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            textTrim(service.titleEdit.value);
                            textTrim(service.descEdit.value);
                            widget.category == false
                                ? service.addTodo(
                                    widget.task!,
                                    service.titleEdit.value,
                                    service.descEdit.value,
                                    service.timeEdit.value,
                                    widget.set,
                                  )
                                : widget.edit == false
                                    ? service.addTodo(
                                        selectedTask!,
                                        service.titleEdit.value,
                                        service.descEdit.value,
                                        service.timeEdit.value,
                                        widget.set,
                                      )
                                    : service.updateTodo(
                                        widget.todo!,
                                        selectedTask!,
                                        service.titleEdit.value,
                                        service.descEdit.value,
                                        service.timeEdit.value,
                                        widget.set,
                                      );
                            textConroller.clear();
                            Get.back();
                          }
                        },
                        icon: const Icon(
                          Iconsax.send_1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
