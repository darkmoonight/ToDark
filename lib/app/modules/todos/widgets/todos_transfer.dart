import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:isar/isar.dart';
import 'package:todark/app/controller/todo_controller.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/app/widgets/text_form.dart';
import 'package:todark/main.dart';

class TodosTransfer extends StatefulWidget {
  const TodosTransfer({
    super.key,
    required this.text,
    required this.todos,
  });
  final String text;
  final List<Todos> todos;

  @override
  State<TodosTransfer> createState() => _TodosTransferState();
}

class _TodosTransferState extends State<TodosTransfer> {
  final todoController = Get.put(TodoController());
  final FocusNode focusNode = FocusNode();
  Tasks? selectedTask;
  final formKeyTransfer = GlobalKey<FormState>();

  Future<List<Tasks>> getTaskAll(String pattern) async {
    List<Tasks> getTask;
    getTask = isar.tasks.filter().archiveEqualTo(false).findAllSync();
    return getTask.where((element) {
      final title = element.title.toLowerCase();
      final query = pattern.toLowerCase();
      return title.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    todoController.transferTodoConroller.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKeyTransfer,
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
                        todoController.doMultiSelectionTodoClear();
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (formKeyTransfer.currentState!.validate()) {
                              if (selectedTask != null) {
                                todoController.transferTodos(
                                    widget.todos, selectedTask!);
                                todoController.doMultiSelectionTodoClear();
                                todoController.transferTodoConroller.clear();
                                Get.back();
                              }
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
              RawAutocomplete<Tasks>(
                focusNode: focusNode,
                optionsViewOpenDirection: OptionsViewOpenDirection.up,
                textEditingController: todoController.transferTodoConroller,
                fieldViewBuilder: (BuildContext context,
                    TextEditingController fieldTextEditingController,
                    FocusNode fieldFocusNode,
                    VoidCallback onFieldSubmitted) {
                  return MyTextForm(
                    elevation: 4,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    controller: todoController.transferTodoConroller,
                    focusNode: focusNode,
                    labelText: 'selectCategory'.tr,
                    type: TextInputType.text,
                    icon: const Icon(Iconsax.folder_2),
                    iconButton:
                        todoController.transferTodoConroller.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  size: 18,
                                ),
                                onPressed: () {
                                  todoController.transferTodoConroller.clear();
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
                  todoController.transferTodoConroller.text = selection.title;
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
                      alignment: Alignment.bottomCenter,
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        elevation: 4,
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
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
