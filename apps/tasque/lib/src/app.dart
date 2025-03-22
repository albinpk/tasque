import 'core/router/router.dart';
import 'core/themes/app_theme.dart';
import 'shared/common_export.dart';

/// The main entry point for the application.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      themeMode: ThemeMode.light,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
    );
  }
}
