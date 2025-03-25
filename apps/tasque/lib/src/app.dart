import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart';
import 'core/notifications/notification_service.dart';
import 'core/router/router.dart';
import 'core/themes/app_theme.dart';
import 'features/auth/repository/auth_repository.dart';
import 'features/task/data/local/task_local_repository.dart';
import 'features/task/data/local/task_repository.dart';
import 'features/task/data/sync/firebase_task_sync_repository.dart';
import 'features/task/data/sync/task_sync_repository.dart';
import 'features/task/presentation/cubit/task_cubit.dart';
import 'shared/common_export.dart';

/// The main entry point for the application.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => AuthRepository(taskBox: objectbox.store.box()),
        ),
        RepositoryProvider<TaskSyncRepository>(
          create:
              (context) => FirebaseTaskSyncRepository(
                db: FirebaseFirestore.instance,
                authRepo: context.read(),
              ),
        ),
        RepositoryProvider<TaskRepository>(
          create: (_) => TaskLocalRepository(taskBox: objectbox.store.box()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              return TaskCubit(
                taskRepository: context.read(),
                syncRepository: context.read(),
                notificationService: NotificationService.i,
              )..loadTasks();
            },
          ),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          themeMode: ThemeMode.light,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
        ),
      ),
    );
  }
}
