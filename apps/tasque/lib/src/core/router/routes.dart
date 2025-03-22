import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/task/presentation/task_screen.dart';

part 'routes.g.dart';

/// Home screen route.
@TypedGoRoute<TaskScreenRoute>(path: '/tasks')
class TaskScreenRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TaskScreen();
  }
}
