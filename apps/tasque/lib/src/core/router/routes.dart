import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/task/presentation/search_screen.dart';
import '../../features/task/presentation/task_details_screen.dart';
import '../../features/task/presentation/task_summary_screen.dart';

part 'routes.g.dart';

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
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TaskListScreen();
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
