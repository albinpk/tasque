import 'dart:async';

import '../model/task.dart';
import '../model/task_priority_enum.dart';
import '../model/task_status_enum.dart';

/// Interface for task repository.
abstract interface class TaskRepository {
  /// Returns a list of all tasks.
  FutureOr<List<Task>> getTasks();

  /// Returns a task by id.
  FutureOr<Task?> getTask(int id);

  /// Creates a new task.
  FutureOr<Task> createTask({
    required String title,
    required String? description,
    required DateTime dueDate,
    required TaskStatus status,
    required TaskPriority priority,
  });

  /// Updates a task.
  FutureOr<void> updateTask(Task task);

  /// Deletes a task.
  FutureOr<void> deleteTask(Task task);
}
