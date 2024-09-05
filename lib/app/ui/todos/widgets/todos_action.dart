import 'package:flutter/foundation.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:todark/app/data/db.dart';
import 'package:todark/app/controller/todo_controller.dart';
import 'package:todark/app/utils/show_dialog.dart';
import 'package:todark/app/ui/widgets/button.dart';
import 'package:todark/app/ui/widgets/text_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  TextEditingController textTodoConroller = TextEditingController();
  TextEditingController titleTodoEdit = TextEditingController();
  TextEditingController descTodoEdit = TextEditingController();
  TextEditingController timeTodoEdit = TextEditingController();

  bool todoPined = false;
  Priority todoPriority = Priority.none;

  late final _EditingController controller;

  @override
  initState() {
    if (widget.edit) {
      selectedTask = widget.todo!.task.value;
      textTodoConroller.text = widget.todo!.task.value!.title;
      titleTodoEdit = TextEditingController(text: widget.todo!.name);
      descTodoEdit = TextEditingController(text: widget.todo!.description);
      timeTodoEdit = TextEditingController(
          text: widget.todo!.todoCompletedTime != null
              ? timeformat == '12'
                  ? DateFormat.yMMMEd(locale.languageCode)
                      .add_jm()
                      .format(widget.todo!.todoCompletedTime!)
                  : DateFormat.yMMMEd(locale.languageCode)
                      .add_Hm()
                      .format(widget.todo!.todoCompletedTime!)
              : '');
      todoPined = widget.todo!.fix;
      todoPriority = widget.todo!.priority;
    }
    controller = _EditingController(
      titleTodoEdit.text,
      descTodoEdit.text,
      timeTodoEdit.text,
      todoPined,
      selectedTask,
      todoPriority,
    );
    super.initState();
  }

  Future<void> onPopInvokedWithResult(bool didPop, dynamic result) async {
    if (didPop) {
      return;
    } else if (!controller.canCompose.value) {
      Get.back();
      return;
    }

    final shouldPop = await showAdaptiveDialogTextIsNotEmpty(
      context: context,
      onPressed: () {
        titleTodoEdit.clear();
        descTodoEdit.clear();
        timeTodoEdit.clear();
        textTodoConroller.clear();
        Get.back(result: true);
      },
    );

    if (shouldPop == true && mounted) {
      Get.back();
    }
  }

  void onPressed() {
    if (formKey.currentState!.validate()) {
      textTrim(titleTodoEdit);
      textTrim(descTodoEdit);
      widget.edit
          ? todoController.updateTodo(
              widget.todo!,
              selectedTask!,
              titleTodoEdit.text,
              descTodoEdit.text,
              timeTodoEdit.text,
              todoPined,
              todoPriority,
            )
          : widget.category
              ? todoController.addTodo(
                  selectedTask!,
                  titleTodoEdit.text,
                  descTodoEdit.text,
                  timeTodoEdit.text,
                  todoPined,
                  todoPriority,
                )
              : todoController.addTodo(
                  widget.task!,
                  titleTodoEdit.text,
                  descTodoEdit.text,
                  timeTodoEdit.text,
                  todoPined,
                  todoPriority,
                );
      textTodoConroller.clear();
      titleTodoEdit.clear();
      descTodoEdit.clear();
      timeTodoEdit.clear();
      Get.back();
    }
  }

  @override
  void dispose() {
    textTodoConroller.clear();
    titleTodoEdit.clear();
    descTodoEdit.clear();
    timeTodoEdit.clear();
    controller.dispose();
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
    final todoCategory = widget.category
        ? RawAutocomplete<Tasks>(
            focusNode: focusNode,
            textEditingController: textTodoConroller,
            fieldViewBuilder: (BuildContext context,
                TextEditingController fieldTextEditingController,
                FocusNode fieldFocusNode,
                VoidCallback onFieldSubmitted) {
              return MyTextForm(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                controller: textTodoConroller,
                focusNode: focusNode,
                labelText: 'selectCategory'.tr,
                type: TextInputType.text,
                icon: const Icon(IconsaxPlusLinear.folder_2),
                iconButton: textTodoConroller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          IconsaxPlusLinear.close_square,
                          size: 18,
                        ),
                        onPressed: () {
                          textTodoConroller.clear();
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
              textTodoConroller.text = selection.title;
              selectedTask = selection;
              setState(() {
                if (widget.edit) controller.task.value = selectedTask;
              });
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
        : Container();

    final titleInput = MyTextForm(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      controller: titleTodoEdit,
      labelText: 'name'.tr,
      type: TextInputType.multiline,
      icon: const Icon(IconsaxPlusLinear.edit),
      onChanged: (value) => controller.title.value = value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'validateName'.tr;
        }
        return null;
      },
      maxLine: null,
    );

    final descriptionInput = MyTextForm(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      controller: descTodoEdit,
      labelText: 'description'.tr,
      type: TextInputType.multiline,
      icon: const Icon(IconsaxPlusLinear.note_text),
      maxLine: null,
      onChanged: (value) => controller.description.value = value,
    );

    final submitButton = ValueListenableBuilder(
      valueListenable: controller.canCompose,
      builder: (context, canCompose, _) {
        return MyTextButton(
          buttonName: 'done'.tr,
          onPressed: canCompose ? () => onPressed() : null,
        );
      },
    );

    final todoDateWidget = RawChip(
      elevation: 4,
      avatar: const Icon(IconsaxPlusLinear.calendar_search),
      label: Text(
        timeTodoEdit.text.isNotEmpty ? timeTodoEdit.text : 'timeComplete'.tr,
      ),
      deleteIcon: const Icon(
        IconsaxPlusLinear.close_square,
        size: 15,
      ),
      onDeleted: () {
        timeTodoEdit.clear();
        setState(() {
          if (widget.edit) {
            controller.time.value = timeTodoEdit.text;
          }
        });
      },
      onPressed: () async {
        DateTime? dateTime = await showOmniDateTimePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 1000)),
          is24HourMode: timeformat == '12' ? false : true,
          minutesInterval: 1,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          transitionDuration: const Duration(milliseconds: 200),
        );
        if (dateTime != null) {
          String formattedDate = timeformat == '12'
              ? DateFormat.yMMMEd(locale.languageCode).add_jm().format(dateTime)
              : DateFormat.yMMMEd(locale.languageCode)
                  .add_Hm()
                  .format(dateTime);

          timeTodoEdit.text = formattedDate;

          setState(() {
            if (widget.edit) controller.time.value = formattedDate;
          });
        }
      },
    );

    final todoPriorityWidget = MenuAnchor(
      alignmentOffset: const Offset(0, -160),
      style: MenuStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
        ),
        alignment: AlignmentDirectional.bottomStart,
      ),
      menuChildren: [
        for (final priority in Priority.values)
          MenuItemButton(
            leadingIcon: Icon(
              IconsaxPlusLinear.flag,
              color: priority.color,
            ),
            child: Text(priority.name.tr),
            onPressed: () {
              todoPriority = priority;
              controller.priority.value = priority;
            },
          ),
      ],
      builder: (context, menuController, _) {
        return ValueListenableBuilder(
          valueListenable: controller.priority,
          builder: (context, priority, _) {
            return ActionChip(
              elevation: 4,
              avatar: Icon(
                IconsaxPlusLinear.flag,
                color: priority.color,
              ),
              label: Text(priority.name.tr),
              onPressed: () {
                if (menuController.isOpen) {
                  menuController.close();
                } else {
                  menuController.open();
                }
              },
            );
          },
        );
      },
    );

    final todoFixWidget = ChoiceChip(
      elevation: 4,
      avatar: const Icon(IconsaxPlusLinear.attach_square),
      label: Text(
        'todoPined'.tr,
      ),
      selected: todoPined,
      onSelected: (value) {
        setState(() {
          todoPined = value;
          if (widget.edit) controller.pined.value = value;
        });
      },
    );

    final attributes = Row(
      children: [
        todoDateWidget,
        const Gap(10),
        todoPriorityWidget,
        const Gap(10),
        todoFixWidget,
      ],
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 14, bottom: 7),
                    child: Text(
                      widget.text,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  todoCategory,
                  titleInput,
                  descriptionInput,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: attributes,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: submitButton,
                  ),
                  const Gap(10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EditingController extends ChangeNotifier {
  _EditingController(
    this.initialTitle,
    this.initialDescription,
    this.initialTime,
    this.initialPined,
    this.initialTask,
    this.initialPriority,
  ) {
    title.value = initialTitle;
    description.value = initialDescription;
    time.value = initialTime;
    pined.value = initialPined;
    task.value = initialTask;
    priority.value = initialPriority;

    title.addListener(_updateCanCompose);
    description.addListener(_updateCanCompose);
    time.addListener(_updateCanCompose);
    pined.addListener(_updateCanCompose);
    task.addListener(_updateCanCompose);
    priority.addListener(_updateCanCompose);
  }

  final String? initialTitle;
  final String? initialDescription;
  final String? initialTime;
  final bool? initialPined;
  final Tasks? initialTask;
  final Priority initialPriority;

  final title = ValueNotifier<String?>(null);
  final description = ValueNotifier<String?>(null);
  final time = ValueNotifier<String?>(null);
  final pined = ValueNotifier<bool?>(null);
  final task = ValueNotifier<Tasks?>(null);
  final priority = ValueNotifier(Priority.none);

  final _canCompose = ValueNotifier(false);
  ValueListenable<bool> get canCompose => _canCompose;

  void _updateCanCompose() {
    _canCompose.value = (title.value != initialTitle) ||
        (description.value != initialDescription) ||
        (time.value != initialTime) ||
        (pined.value != initialPined) ||
        (task.value != initialTask) ||
        (priority.value != initialPriority);
  }

  @override
  void dispose() {
    title.removeListener(_updateCanCompose);
    description.removeListener(_updateCanCompose);
    time.removeListener(_updateCanCompose);
    pined.removeListener(_updateCanCompose);
    task.removeListener(_updateCanCompose);
    priority.removeListener(_updateCanCompose);
    super.dispose();
  }
}
