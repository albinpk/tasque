import 'package:objectbox/objectbox.dart';

import '../../../model/task_priority_enum.dart';
import '../../../model/task_status_enum.dart';

/// ObjectBox model class for a task.
@Entity()
class TaskEntity {
  TaskEntity({
    required this.title,
    required this.dueDate,
    required this.createdAt,
    this.description,
  });

  @Id()
  int id = 0;

  /// Task title.
  String title;

  /// Task description.
  String? description;

  /// Task priority level. Defaults to medium.
  @Transient()
  TaskPriority priority = TaskPriority.medium;
  String get dbPriority => priority.name;
  set dbPriority(String name) => priority = TaskPriority.fromName(name);

  /// Task status. Defaults to pending.
  @Transient()
  TaskStatus status = TaskStatus.pending;
  String get dbStatus => status.name;
  set dbStatus(String name) => status = TaskStatus.fromName(name);

  /// Task due date.
  @Property(type: PropertyType.date)
  DateTime dueDate;

  /// Time the task was created.
  @Property(type: PropertyType.dateNano)
  DateTime createdAt;
}
