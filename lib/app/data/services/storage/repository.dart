import 'package:dark_todo/app/data/models/task.dart';
import 'package:dark_todo/app/data/providers/task/provider.dart';

class TaskRepository {
  TaskProvider taskProvider;
  TaskRepository({required this.taskProvider});

  List<Task> readTasks() => taskProvider.readTask();
  void writeTasks(List<Task> tasks) => taskProvider.writeTask(tasks);
}
