import 'dart:async';

import '../model/task.dart';
import '../model/task_priority_enum.dart';
import '../model/task_status_enum.dart';

/// Interface for task repository.
abstract interface class TaskRepository {
  FutureOr<List<Task>> getTasks();

  FutureOr<Task?> getTask(int id);

  FutureOr<Task> createTask({
    required String title,
    required String? description,
    required DateTime dueDate,
    required TaskStatus status,
    required TaskPriority priority,
  });
}
