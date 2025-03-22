import 'package:go_router/go_router.dart';

import 'routes.dart';

/// GoRouter instance for the app.
final router = GoRouter(
  initialLocation: TaskScreenRoute().location,
  routes: $appRoutes,
);
