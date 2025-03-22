/// Status of a task.
enum TaskStatus {
  pending,
  completed;

  bool get isPending => this == pending;
  bool get isCompleted => this == completed;

  /// Get status enum from name.
  static TaskStatus fromName(String name) =>
      TaskStatus.values.firstWhere((e) => e.name == name);
}
