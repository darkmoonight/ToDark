import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/app/controller/todo_controller.dart';
import 'package:todark/app/widgets/text_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todark/main.dart';

class TodosAction extends StatefulWidget {
  const TodosAction({
    super.key,
    required this.text,
    required this.edit,
    required this.category,
    this.task,
    this.todo,
  });
  final String text;
  final Tasks? task;
  final Todos? todo;
  final bool edit;
  final bool category;

  @override
  State<TodosAction> createState() => _TodosActionState();
}

class _TodosActionState extends State<TodosAction> {
  final formKey = GlobalKey<FormState>();
  final todoController = Get.put(TodoController());
  Tasks? selectedTask;
  List<Tasks>? task;
  final FocusNode focusNode = FocusNode();

  @override
  initState() {
    if (widget.edit) {
      selectedTask = widget.todo!.task.value;
      todoController.textTodoConroller.text = widget.todo!.task.value!.title;
      todoController.titleTodoEdit =
          TextEditingController(text: widget.todo!.name);
      todoController.descTodoEdit =
          TextEditingController(text: widget.todo!.description);
      todoController.timeTodoEdit = TextEditingController(
          text: widget.todo!.todoCompletedTime != null
              ? timeformat == '12'
                  ? DateFormat.yMMMEd(locale.languageCode)
                      .add_jm()
                      .format(widget.todo!.todoCompletedTime!)
                  : DateFormat.yMMMEd(locale.languageCode)
                      .add_Hm()
                      .format(widget.todo!.todoCompletedTime!)
              : '');
    }
    super.initState();
  }

  @override
  void dispose() {
    todoController.textTodoConroller.clear();
    todoController.titleTodoEdit.clear();
    todoController.descTodoEdit.clear();
    todoController.timeTodoEdit.clear();
    super.dispose();
  }

  Future<List<Tasks>> getTaskAll(String pattern) async {
    List<Tasks> getTask;
    getTask = isar.tasks.filter().archiveEqualTo(false).findAllSync();
    return getTask.where((element) {
      final title = element.title.toLowerCase();
      final query = pattern.toLowerCase();
      return title.contains(query);
    }).toList();
  }

  textTrim(value) {
    value.text = value.text.trim();
    while (value.text.contains('  ')) {
      value.text = value.text.replaceAll('  ', ' ');
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (todoController.titleTodoEdit.text.length >= 40 ||
                            todoController.descTodoEdit.text.length >= 40) {
                          await showAdaptiveDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog.adaptive(
                                title: Text(
                                  'clearText'.tr,
                                  style: context.textTheme.titleLarge,
                                ),
                                content: Text('clearTextWarning'.tr,
                                    style: context.textTheme.titleMedium),
                                actions: [
                                  TextButton(
                                      onPressed: () => Get.back(result: false),
                                      child: Text('cancel'.tr,
                                          style: context
                                              .theme.textTheme.titleMedium
                                              ?.copyWith(
                                                  color: Colors.blueAccent))),
                                  TextButton(
                                      onPressed: () {
                                        todoController.titleTodoEdit.clear();
                                        todoController.descTodoEdit.clear();
                                        todoController.timeTodoEdit.clear();
                                        todoController.textTodoConroller
                                            .clear();
                                        Get.back(result: true);
                                        Get.back();
                                      },
                                      child: Text('delete'.tr,
                                          style: context
                                              .theme.textTheme.titleMedium
                                              ?.copyWith(color: Colors.red))),
                                ],
                              );
                            },
                          );
                        } else {
                          todoController.titleTodoEdit.clear();
                          todoController.descTodoEdit.clear();
                          todoController.timeTodoEdit.clear();
                          todoController.textTodoConroller.clear();
                          Get.back();
                        }
                      },
                      icon: const Icon(
                        Iconsax.close_square,
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.edit
                            ? IconButton(
                                onPressed: () {
                                  todoController.updateTodoFix(widget.todo!);
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Iconsax.attach_square,
                                  size: 20,
                                ),
                              )
                            : const Offstage(),
                        IconButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              textTrim(todoController.titleTodoEdit);
                              textTrim(todoController.descTodoEdit);
                              widget.edit
                                  ? todoController.updateTodo(
                                      widget.todo!,
                                      selectedTask!,
                                      todoController.titleTodoEdit.text,
                                      todoController.descTodoEdit.text,
                                      todoController.timeTodoEdit.text,
                                    )
                                  : widget.category
                                      ? todoController.addTodo(
                                          selectedTask!,
                                          todoController.titleTodoEdit.text,
                                          todoController.descTodoEdit.text,
                                          todoController.timeTodoEdit.text,
                                        )
                                      : todoController.addTodo(
                                          widget.task!,
                                          todoController.titleTodoEdit.text,
                                          todoController.descTodoEdit.text,
                                          todoController.timeTodoEdit.text,
                                        );
                              todoController.textTodoConroller.clear();
                              todoController.titleTodoEdit.clear();
                              todoController.descTodoEdit.clear();
                              todoController.timeTodoEdit.clear();
                              Get.back();
                            }
                          },
                          icon: const Icon(
                            Iconsax.tick_square,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              widget.category
                  ? RawAutocomplete<Tasks>(
                      focusNode: focusNode,
                      textEditingController: todoController.textTodoConroller,
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController fieldTextEditingController,
                          FocusNode fieldFocusNode,
                          VoidCallback onFieldSubmitted) {
                        return MyTextForm(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          controller: todoController.textTodoConroller,
                          focusNode: focusNode,
                          labelText: 'selectCategory'.tr,
                          type: TextInputType.text,
                          icon: const Icon(Iconsax.folder_2),
                          iconButton: todoController
                                  .textTodoConroller.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    todoController.textTodoConroller.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'selectCategory'.tr;
                            }
                            return null;
                          },
                        );
                      },
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<Tasks>.empty();
                        }
                        return getTaskAll(textEditingValue.text);
                      },
                      onSelected: (Tasks selection) {
                        todoController.textTodoConroller.text = selection.title;
                        selectedTask = selection;
                        focusNode.unfocus();
                      },
                      displayStringForOption: (Tasks option) => option.title,
                      optionsViewBuilder: (BuildContext context,
                          AutocompleteOnSelected<Tasks> onSelected,
                          Iterable<Tasks> options) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              elevation: 4.0,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: options.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final Tasks tasks = options.elementAt(index);
                                  return InkWell(
                                    onTap: () => onSelected(tasks),
                                    child: ListTile(
                                      title: Text(
                                        tasks.title,
                                        style: context.textTheme.labelLarge,
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
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Container(),
              MyTextForm(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                controller: todoController.titleTodoEdit,
                labelText: 'name'.tr,
                type: TextInputType.multiline,
                icon: const Icon(Iconsax.edit_2),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'validateName'.tr;
                  }
                  return null;
                },
                maxLine: null,
              ),
              MyTextForm(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                controller: todoController.descTodoEdit,
                labelText: 'description'.tr,
                type: TextInputType.multiline,
                icon: const Icon(Iconsax.note_text),
                maxLine: null,
              ),
              MyTextForm(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                readOnly: true,
                controller: todoController.timeTodoEdit,
                labelText: 'timeComplete'.tr,
                type: TextInputType.datetime,
                icon: const Icon(Iconsax.clock),
                iconButton: todoController.timeTodoEdit.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 18,
                        ),
                        onPressed: () {
                          todoController.timeTodoEdit.clear();
                          setState(() {});
                        },
                      )
                    : null,
                onTap: () {
                  BottomPicker.dateTime(
                    titlePadding: const EdgeInsets.only(top: 10),
                    pickerTitle: Text(
                      'time'.tr,
                      style: context.textTheme.titleMedium!,
                    ),
                    pickerDescription: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'timeDesc'.tr,
                        style: context.textTheme.labelLarge!
                            .copyWith(color: Colors.grey),
                      ),
                    ),
                    titleAlignment: Alignment.centerLeft,
                    pickerTextStyle:
                        context.textTheme.labelMedium!.copyWith(fontSize: 15),
                    closeIconColor: Colors.red,
                    backgroundColor: context.theme.primaryColor,
                    onSubmit: (date) {
                      String formattedDate = timeformat == '12'
                          ? DateFormat.yMMMEd(locale.languageCode)
                              .add_jm()
                              .format(date)
                          : DateFormat.yMMMEd(locale.languageCode)
                              .add_Hm()
                              .format(date);
                      todoController.timeTodoEdit.text = formattedDate;
                      setState(() {});
                    },
                    buttonContent: Text(
                      'select'.tr,
                      textAlign: TextAlign.center,
                    ),
                    buttonStyle: BoxDecoration(
                      color: context.theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minDateTime: DateTime.now(),
                    maxDateTime: DateTime.now().add(const Duration(days: 1000)),
                    initialDateTime: DateTime.now(),
                    use24hFormat: timeformat == '12' ? false : true,
                    dateOrder: DatePickerDateOrder.dmy,
                  ).show(context);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
