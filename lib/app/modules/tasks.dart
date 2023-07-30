import 'package:todark/app/data/schema.dart';
import 'package:todark/app/services/controller.dart';
import 'package:todark/app/widgets/my_delegate.dart';
import 'package:todark/app/widgets/task_type_cu.dart';
import 'package:todark/app/widgets/text_form.dart';
import 'package:todark/app/widgets/todos_ce.dart';
import 'package:todark/app/widgets/todos_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({
    super.key,
    required this.task,
  });
  final Tasks task;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final todoController = Get.put(TodoController());
  int countTotalTodos = 0;
  int countDoneTodos = 0;

  @override
  void initState() {
    getCountTodos();
    super.initState();
  }

  getCountTodos() async {
    countTotalTodos = await todoController.getCountTotalTodosTask(widget.task);
    countDoneTodos = await todoController.getCountDoneTodosTask(widget.task);
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
            widget.task.title!,
            style: context.theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: widget.task.description!.isEmpty
              ? null
              : Text(
                  widget.task.description!,
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
                  return TaskTypeCu(
                    text: 'editing'.tr,
                    edit: true,
                    task: widget.task,
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
                    controller: TextEditingController(),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                  allTask: false,
                  calendare: false,
                  done: false,
                  task: widget.task,
                ),
                TodosList(
                  allTask: false,
                  calendare: false,
                  done: true,
                  task: widget.task,
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
              return TodosCe(
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
