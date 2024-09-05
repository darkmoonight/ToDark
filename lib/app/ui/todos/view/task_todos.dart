import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:todark/app/data/db.dart';
import 'package:todark/app/controller/todo_controller.dart';
import 'package:todark/app/ui/tasks/widgets/tasks_action.dart';
import 'package:todark/app/ui/todos/widgets/todos_action.dart';
import 'package:todark/app/ui/todos/widgets/todos_list.dart';
import 'package:todark/app/ui/todos/widgets/todos_transfer.dart';
import 'package:todark/app/ui/widgets/my_delegate.dart';
import 'package:todark/app/ui/widgets/text_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TodosTask extends StatefulWidget {
  const TodosTask({
    super.key,
    required this.task,
  });
  final Tasks task;

  @override
  State<TodosTask> createState() => _TodosTaskState();
}

class _TodosTaskState extends State<TodosTask> {
  final todoController = Get.put(TodoController());
  TextEditingController searchTodos = TextEditingController();
  String filter = '';

  applyFilter(String value) async {
    filter = value.toLowerCase();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    applyFilter('');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: todoController.isPop.value,
        onPopInvokedWithResult: (didPop, value) {
          if (didPop) {
            return;
          }

          if (todoController.isMultiSelectionTodo.isTrue) {
            todoController.doMultiSelectionTodoClear();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: todoController.isMultiSelectionTodo.isTrue
                ? IconButton(
                    onPressed: () => todoController.doMultiSelectionTodoClear(),
                    icon: const Icon(
                      IconsaxPlusLinear.close_square,
                      size: 20,
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      IconsaxPlusLinear.arrow_left_3,
                      size: 20,
                    ),
                  ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.task.title,
                  style: context.theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                widget.task.description.isEmpty
                    ? const Offstage()
                    : Text(
                        widget.task.description,
                        style: context.textTheme.labelLarge?.copyWith(
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
              ],
            ),
            actions: [
              Visibility(
                visible: todoController.selectedTodo.isNotEmpty,
                replacement: const Offstage(),
                child: IconButton(
                  icon: const Icon(
                    IconsaxPlusLinear.arrange_square,
                    size: 20,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      enableDrag: false,
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return TodosTransfer(
                          text: 'editing'.tr,
                          todos: todoController.selectedTodo,
                        );
                      },
                    );
                  },
                ),
              ),
              Visibility(
                visible: todoController.selectedTodo.isNotEmpty,
                replacement: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      enableDrag: false,
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return TasksAction(
                          text: 'editing'.tr,
                          edit: true,
                          task: widget.task,
                          updateTaskName: () => setState(() {}),
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    IconsaxPlusLinear.edit,
                    size: 20,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(
                    IconsaxPlusLinear.trash_square,
                    size: 20,
                  ),
                  onPressed: () async {
                    await showAdaptiveDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog.adaptive(
                          title: Text(
                            'deletedTodo'.tr,
                            style: context.textTheme.titleLarge,
                          ),
                          content: Text(
                            'deletedTodoQuery'.tr,
                            style: context.textTheme.titleMedium,
                          ),
                          actions: [
                            TextButton(
                                onPressed: () => Get.back(),
                                child: Text('cancel'.tr,
                                    style: context.textTheme.titleMedium
                                        ?.copyWith(color: Colors.blueAccent))),
                            TextButton(
                                onPressed: () {
                                  todoController
                                      .deleteTodo(todoController.selectedTodo);
                                  todoController.doMultiSelectionTodoClear();
                                  Get.back();
                                },
                                child: Text('delete'.tr,
                                    style: context.textTheme.titleMedium
                                        ?.copyWith(color: Colors.red))),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: DefaultTabController(
              length: 2,
              child: NestedScrollView(
                physics: const NeverScrollableScrollPhysics(),
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: MyTextForm(
                        labelText: 'searchTodo'.tr,
                        type: TextInputType.text,
                        icon: const Icon(
                          IconsaxPlusLinear.search_normal_1,
                          size: 20,
                        ),
                        controller: searchTodos,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        onChanged: applyFilter,
                        iconButton: searchTodos.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  searchTodos.clear();
                                  applyFilter('');
                                },
                                icon: const Icon(
                                  IconsaxPlusLinear.close_square,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              )
                            : null,
                      ),
                    ),
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                      sliver: SliverPersistentHeader(
                        delegate: MyDelegate(
                          TabBar(
                            tabAlignment: TabAlignment.start,
                            isScrollable: true,
                            dividerColor: Colors.transparent,
                            splashFactory: NoSplash.splashFactory,
                            overlayColor:
                                WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) {
                                return Colors.transparent;
                              },
                            ),
                            tabs: [
                              Tab(text: 'doing'.tr),
                              Tab(text: 'done'.tr),
                            ],
                          ),
                        ),
                        floating: true,
                        pinned: true,
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  children: [
                    TodosList(
                      allTodos: false,
                      calendare: false,
                      done: false,
                      task: widget.task,
                      searchTodo: filter,
                    ),
                    TodosList(
                      allTodos: false,
                      calendare: false,
                      done: true,
                      task: widget.task,
                      searchTodo: filter,
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                enableDrag: false,
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return TodosAction(
                    text: 'create'.tr,
                    edit: false,
                    task: widget.task,
                    category: false,
                  );
                },
              );
            },
            child: const Icon(IconsaxPlusLinear.add),
          ),
        ),
      ),
    );
  }
}
