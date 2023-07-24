import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/app/services/controller.dart';
import 'package:todark/app/widgets/text_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todark/main.dart';

class TodosCe extends StatefulWidget {
  const TodosCe({
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
  State<TodosCe> createState() => _TodosCeState();
}

class _TodosCeState extends State<TodosCe> {
  final formKey = GlobalKey<FormState>();
  final todoController = Get.put(TodoController());
  final locale = Get.locale;
  Tasks? selectedTask;
  List<Tasks>? task;
  final FocusNode focusNode = FocusNode();
  final textConroller = TextEditingController();
  TextEditingController titleEdit = TextEditingController();
  TextEditingController descEdit = TextEditingController();
  TextEditingController timeEdit = TextEditingController();

  @override
  initState() {
    if (widget.edit == true) {
      selectedTask = widget.todo!.task.value;
      textConroller.text = widget.todo!.task.value!.title!;
      titleEdit = TextEditingController(text: widget.todo!.name);
      descEdit = TextEditingController(text: widget.todo!.description);
      timeEdit = TextEditingController(
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
      final title = element.title!.toLowerCase();
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
                      onPressed: () {
                        titleEdit.clear();
                        descEdit.clear();
                        timeEdit.clear();
                        textConroller.clear();
                        Get.back();
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
                    IconButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          textTrim(titleEdit);
                          textTrim(descEdit);
                          widget.category == false
                              ? todoController.addTodo(
                                  widget.task!,
                                  titleEdit,
                                  descEdit,
                                  timeEdit,
                                )
                              : widget.edit == false
                                  ? todoController.addTodo(
                                      selectedTask!,
                                      titleEdit,
                                      descEdit,
                                      timeEdit,
                                    )
                                  : todoController.updateTodo(
                                      widget.todo!,
                                      selectedTask!,
                                      titleEdit,
                                      descEdit,
                                      timeEdit,
                                    );
                          textConroller.clear();
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
              ),
              widget.category == true
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
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
                            style: context.textTheme.labelLarge,
                            decoration: InputDecoration(
                              labelText: 'selectCategory'.tr,
                              prefixIcon: const Icon(Iconsax.folder_2),
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
                          return getTodosAll(textEditingValue.text);
                        },
                        onSelected: (Tasks selection) {
                          textConroller.text = selection.title!;
                          selectedTask = selection;
                          focusNode.unfocus();
                        },
                        displayStringForOption: (Tasks option) => option.title!,
                        optionsViewBuilder: (BuildContext context,
                            AutocompleteOnSelected<Tasks> onSelected,
                            Iterable<Tasks> options) {
                          return Align(
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
                                        tasks.title!,
                                        style: context.textTheme.labelLarge,
                                      ),
                                      trailing: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: Color(tasks.taskColor!),
                                          shape: BoxShape.circle,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                controller: titleEdit,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                controller: descEdit,
                labelText: 'description'.tr,
                type: TextInputType.text,
                icon: const Icon(Iconsax.note_text),
              ),
              MyTextForm(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                readOnly: true,
                controller: timeEdit,
                labelText: 'timeComlete'.tr,
                type: TextInputType.datetime,
                icon: const Icon(Iconsax.clock),
                iconButton: IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 18,
                  ),
                  onPressed: () {
                    timeEdit.clear();
                  },
                ),
                onTap: () {
                  BottomPicker.dateTime(
                    title: 'time'.tr,
                    description: 'timeDesc'.tr,
                    titleStyle: context.textTheme.titleMedium!,
                    descriptionStyle: context.textTheme.bodyLarge!
                        .copyWith(color: Colors.grey),
                    pickerTextStyle:
                        context.textTheme.labelMedium!.copyWith(fontSize: 15),
                    closeIconColor: Colors.red,
                    backgroundColor: context.theme.colorScheme.surface,
                    onSubmit: (date) {
                      timeEdit.text = date.toString();
                    },
                    bottomPickerTheme: BottomPickerTheme.temptingAzure,
                    minDateTime: DateTime.now(),
                    maxDateTime: DateTime.now().add(const Duration(days: 1000)),
                    initialDateTime: DateTime.now(),
                    use24hFormat: true,
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
