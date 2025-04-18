import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/task/model/task_priority_enum.dart';
import '../../features/task/model/task_status_enum.dart';
import '../../features/task/presentation/task_details_screen.dart';
import '../../features/task/presentation/task_list_screen.dart';
import '../../features/task/presentation/task_summary_screen.dart';

part 'routes.g.dart';

/// Login screen route.
@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginScreen();
  }
}

/// Home screen route.
@TypedGoRoute<TaskSummaryRoute>(
  path: '/',
  routes: [
    TypedGoRoute<TaskListRoute>(path: 'tasks'),
    TypedGoRoute<TaskDetailsRoute>(path: 'tasks/:taskId'),
  ],
)
class TaskSummaryRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TaskSummaryScreen();
  }
}

/// Full task list and search screen route.
class TaskListRoute extends GoRouteData {
  const TaskListRoute({this.searchQuery, this.status, this.priority});

  /// Initial search query.
  final String? searchQuery;

  /// Initial task status filter.
  final TaskStatus? status;

  /// Initial task priority filter.
  final TaskPriority? priority;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TaskListScreen(
      searchQuery: searchQuery,
      status: status,
      priority: priority,
    );
  }
}

/// Task details & edit screen route.
class TaskDetailsRoute extends GoRouteData {
  const TaskDetailsRoute({required this.taskId});

  final int taskId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TaskDetailsScreen(taskId: taskId);
  }
}
