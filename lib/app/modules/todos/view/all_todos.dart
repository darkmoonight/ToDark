import 'package:iconsax/iconsax.dart';
import 'package:todark/app/controller/todo_controller.dart';
import 'package:todark/app/modules/todos/widgets/todos_list.dart';
import 'package:todark/app/widgets/my_delegate.dart';
import 'package:todark/app/widgets/text_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllTodos extends StatefulWidget {
  const AllTodos({super.key});

  @override
  State<AllTodos> createState() => _AllTodosState();
}

class _AllTodosState extends State<AllTodos> {
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
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }

          if (todoController.isMultiSelectionTodo.isTrue) {
            todoController.doMultiSelectionTodoClear();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: todoController.isMultiSelectionTodo.isTrue
                ? IconButton(
                    onPressed: () => todoController.doMultiSelectionTodoClear(),
                    icon: const Icon(
                      Iconsax.close_square,
                      size: 20,
                    ),
                  )
                : null,
            title: Text(
              'allTodos'.tr,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              Visibility(
                visible: todoController.selectedTodo.isNotEmpty,
                child: IconButton(
                  icon: const Icon(
                    Iconsax.trush_square,
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
          body: DefaultTabController(
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
                        Iconsax.search_normal_1,
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
                                Iconsax.close_circle,
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
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
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
                    calendare: false,
                    allTodos: true,
                    done: false,
                    searchTodo: filter,
                  ),
                  TodosList(
                    calendare: false,
                    allTodos: true,
                    done: true,
                    searchTodo: filter,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
