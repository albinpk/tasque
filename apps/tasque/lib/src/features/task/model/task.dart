import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/common_export.dart';
import '../data/local/model/task_entity.dart';
import 'task_priority_enum.dart';
import 'task_status_enum.dart';

part 'task.freezed.dart';
part 'task.g.dart';

/// Task model used in presentation layer.
@freezed
abstract class Task with _$Task {
  const factory Task({
    required int id,
    required String uid,
    required String title,
    required String? description,
    @JsonKey(fromJson: _dateTimeFromJson) required DateTime dueDate,
    @JsonKey(fromJson: _dateTimeFromJson) required DateTime createdAt,
    required TaskStatus status,
    required TaskPriority priority,
  }) = _Task;

  const Task._();

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  /// Converts [TaskEntity] to [Task].
  factory Task.fromEntity(TaskEntity entity) => Task(
    id: entity.id,
    uid: entity.uid,
    title: entity.title,
    description: entity.description,
    dueDate: entity.dueDate,
    createdAt: entity.createdAt,
    status: entity.status,
    priority: entity.priority,
  );

  /// Converts [Task] to [TaskEntity].
  TaskEntity toEntity() =>
      TaskEntity(
          uid: uid,
          title: title,
          description: description,
          dueDate: dueDate,
          createdAt: createdAt,
        )
        ..id = id
        ..priority = priority
        ..status = status;

  /// Task json for firestore. Converts [DateTime] to [Timestamp].
  Map<String, dynamic> toFirestoreJson() => {
    ...toJson(),
    'dueDate': Timestamp.fromDate(dueDate),
    'createdAt': Timestamp.fromDate(createdAt),
  };

  /// Returns the number of days left as a string.
  String get relativeDueDate {
    if (dueDate.isToday) return 'Due today';
    if (dueDate.isBefore(DateTime.now())) return 'Overdue';
    return dueDate.daysLeft();
  }
}

/// DateTime converter for [Task] that converts
/// both [String] and [Timestamp] to [DateTime].
DateTime _dateTimeFromJson(Object value) {
  if (value is Timestamp) return value.toDate();
  return DateTime.parse(value as String);
}
