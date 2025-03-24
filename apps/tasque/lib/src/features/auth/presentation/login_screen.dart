import 'dart:async';
import 'dart:developer';

import 'package:lottie/lottie.dart';

import '../../../../assets.dart';
import '../../../shared/common_export.dart';
import '../../task/presentation/cubit/task_cubit.dart';
import '../repository/auth_repository.dart';

/// The login screen of the app.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text('Welcome to Tasque', style: context.displaySmall),
              const SizedBox(height: 10),
              const Text(
                'Organize your tasks, sync seamlessly, '
                'and stay on track—anytime, anywhere',
              ),

              const SizedBox(height: 30),
              Flexible(child: Lottie.asset(Assets.lottie.loginPlanningJSON)),
              const SizedBox(height: 30),

              FilledButton(
                onPressed: _onSignInWithGoogle,
                child:
                    _isLoading
                        ? SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            color: context.colorScheme.onPrimary,
                            strokeWidth: 2,
                          ),
                        )
                        : const Text('Sign in with Google'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSignInWithGoogle() async {
    if (_isLoading) return;
    try {
      setState(() => _isLoading = true);
      await context.read<AuthRepository>().signInWithGoogle();
      if (mounted) {
        if (context.read<TaskCubit>().state is TaskStateInitial) {
          // in case of logout and login
          unawaited(context.read<TaskCubit>().loadTasks());
        }
        TaskSummaryRoute().go(context);
      }
    } catch (e) {
      log(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong, please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
