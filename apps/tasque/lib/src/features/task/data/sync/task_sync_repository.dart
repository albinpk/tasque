import '../../model/task.dart';

/// Interface for remote sync service.
abstract interface class TaskSyncRepository {
  /// Get all tasks from remote server.
  Future<List<Task>> getAllTasks();

  /// Add task to remote server.
  Future<void> addTask(Task task);

  /// Update an existing task on remote server.
  Future<void> updateTask(Task task);

  /// Delete task from remote server.
  Future<void> deleteTask(Task task);
}
