import 'package:todark/app/data/schema.dart';
import 'package:todark/app/controller/controller.dart';
import 'package:todark/app/modules/tasks/widgets/tasks_action.dart';
import 'package:todark/app/modules/todos/widgets/todos_action.dart';
import 'package:todark/app/modules/todos/widgets/todos_list.dart';
import 'package:todark/app/widgets/my_delegate.dart';
import 'package:todark/app/widgets/text_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

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
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          horizontalTitleGap: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Iconsax.arrow_left_1,
              size: 20,
            ),
          ),
          title: Text(
            widget.task.title,
            style: context.theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: widget.task.description.isEmpty
              ? null
              : Text(
                  widget.task.description,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
          trailing: IconButton(
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
              Iconsax.edit,
              size: 20,
            ),
          ),
        ),
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
                      Iconsax.search_normal_1,
                      size: 20,
                    ),
                    controller: searchTodos,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverPersistentHeader(
                    delegate: MyDelegate(
                      TabBar(
                        isScrollable: true,
                        dividerColor: Colors.transparent,
                        splashFactory: NoSplash.splashFactory,
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
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
        child: const Icon(Iconsax.add),
      ),
    );
  }
}
