import '../main.dart';
import 'core/router/router.dart';
import 'core/themes/app_theme.dart';
import 'features/auth/repository/auth_repository.dart';
import 'features/task/data/local/task_local_repository.dart';
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
          create: (_) => TaskLocalRepository(taskBox: objectbox.store.box()),
        ),
        RepositoryProvider(create: (_) => AuthRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) => TaskCubit(
                  taskRepository: context.read<TaskLocalRepository>(),
                )..loadTasks(),
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
