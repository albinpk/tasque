import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';

/// GoRouter instance for the app.
final router = GoRouter(
  initialLocation: TaskSummaryRoute().location,
  debugLogDiagnostics: kDebugMode,
  routes: $appRoutes,
);
