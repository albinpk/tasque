import 'dart:developer';

import 'package:lottie/lottie.dart';

import '../../../../assets.dart';
import '../../../shared/common_export.dart';
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
            children: [
              const SizedBox(height: 20),
              Text('Get Started with \nTasque', style: context.displaySmall),
              const SizedBox(height: 10),

              const Text(
                'Sign up to manage your tasks effortlessly, even offline',
              ),

              Expanded(child: Lottie.asset(Assets.lottie.loginPlanningJSON)),

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
    try {
      setState(() => _isLoading = true);
      await context.read<AuthRepository>().signInWithGoogle();
      if (mounted) TaskSummaryRoute().go(context);
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
