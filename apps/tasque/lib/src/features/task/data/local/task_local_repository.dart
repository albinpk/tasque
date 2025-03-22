import 'dart:async';

import '../../../../../objectbox.g.dart';
import '../../model/task.dart';
import '../../model/task_priority_enum.dart';
import '../../model/task_status_enum.dart';
import '../task_repository.dart';
import 'model/task_entity.dart';

/// Implementation of [TaskRepository] using ObjectBox.
class TaskLocalRepository implements TaskRepository {
  const TaskLocalRepository({required Box<TaskEntity> taskBox})
    : _taskBox = taskBox;

  final Box<TaskEntity> _taskBox;

  @override
  FutureOr<List<Task>> getTasks() =>
      _taskBox.getAll().map(Task.fromEntity).toList();

  @override
  FutureOr<Task?> getTask(int id) {
    final task = _taskBox.get(id);
    return task == null ? null : Task.fromEntity(task);
  }

  @override
  Future<Task> createTask({
    required String title,
    required String? description,
    required DateTime dueDate,
    required TaskStatus status,
    required TaskPriority priority,
  }) async {
    final task =
        TaskEntity(
            title: title,
            description: description,
            dueDate: dueDate,
            createdAt: DateTime.now(),
          )
          ..priority = priority
          ..status = status;
    final id = _taskBox.put(task);
    return (await getTask(id))!;
  }

  @override
  FutureOr<void> updateTask(Task task) {
    _taskBox.put(task.toEntity());
  }
}
