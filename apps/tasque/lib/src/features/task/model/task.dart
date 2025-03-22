import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/local/model/task_entity.dart';
import 'task_priority_enum.dart';
import 'task_status_enum.dart';

part 'task.freezed.dart';

/// Task model used in presentation layer.
@freezed
abstract class Task with _$Task {
  const factory Task({
    required int id,
    required String title,
    required String? description,
    required DateTime dueDate,
    required DateTime createdAt,
    required TaskStatus status,
    required TaskPriority priority,
  }) = _Task;

  /// Converts [TaskEntity] to [Task].
  factory Task.fromEntity(TaskEntity entity) => Task(
    id: entity.id,
    title: entity.title,
    description: entity.description,
    dueDate: entity.dueDate,
    createdAt: entity.createdAt,
    status: entity.status,
    priority: entity.priority,
  );
}
