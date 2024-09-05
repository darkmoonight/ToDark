import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:isar/isar.dart';
import 'package:todark/app/controller/todo_controller.dart';
import 'package:todark/app/data/db.dart';
import 'package:todark/app/utils/show_dialog.dart';
import 'package:todark/app/ui/widgets/button.dart';
import 'package:todark/app/ui/widgets/text_form.dart';
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
  TextEditingController transferTodoConroller = TextEditingController();

  late final _EditingController controller;

  @override
  initState() {
    controller = _EditingController(selectedTask);
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
        transferTodoConroller.clear();
        Get.back(result: true);
      },
    );

    if (shouldPop == true && mounted) {
      Get.back();
    }
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

  void onPressed() {
    if (formKeyTransfer.currentState!.validate()) {
      if (selectedTask != null) {
        todoController.transferTodos(widget.todos, selectedTask!);
        todoController.doMultiSelectionTodoClear();
        transferTodoConroller.clear();
        Get.back();
      }
    }
  }

  @override
  void dispose() {
    transferTodoConroller.clear();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoCategory = RawAutocomplete<Tasks>(
      focusNode: focusNode,
      optionsViewOpenDirection: OptionsViewOpenDirection.up,
      textEditingController: transferTodoConroller,
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        return MyTextForm(
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          controller: transferTodoConroller,
          focusNode: focusNode,
          labelText: 'selectCategory'.tr,
          type: TextInputType.text,
          icon: const Icon(IconsaxPlusLinear.folder_2),
          iconButton: transferTodoConroller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    IconsaxPlusLinear.close_square,
                    size: 18,
                  ),
                  onPressed: () {
                    transferTodoConroller.clear();
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
        transferTodoConroller.text = selection.title;
        selectedTask = selection;
        setState(() {
          controller.task.value = selectedTask;
        });
        focusNode.unfocus();
      },
      displayStringForOption: (Tasks option) => option.title,
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<Tasks> onSelected, Iterable<Tasks> options) {
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Form(
          key: formKeyTransfer,
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
    this.initialTask,
  ) {
    task.value = initialTask;

    task.addListener(_updateCanCompose);
  }

  final Tasks? initialTask;

  final task = ValueNotifier<Tasks?>(null);

  final _canCompose = ValueNotifier(false);
  ValueListenable<bool> get canCompose => _canCompose;

  void _updateCanCompose() => _canCompose.value = (task.value != initialTask);

  @override
  void dispose() {
    task.removeListener(_updateCanCompose);
    super.dispose();
  }
}
