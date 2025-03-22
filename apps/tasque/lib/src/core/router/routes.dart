import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/task/presentation/task_details_screen.dart';
import '../../features/task/presentation/task_screen.dart';

part 'routes.g.dart';

/// Home screen route.
@TypedGoRoute<TaskScreenRoute>(
  path: '/tasks',
  routes: [TypedGoRoute<TaskDetailsRoute>(path: ':taskId')],
)
class TaskScreenRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TaskScreen();
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
