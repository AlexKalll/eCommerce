import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/routes/app_routes.dart';
import '../../../../core/presentation/widgets/snackbar.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginSuccess) {
          context.go(Routes.home);
          showInfo(context, 'Logged in successfully');
        } else if (state is AuthLoginFailure) {
          showError(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () {
                context.go(Routes.register);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: SingleChildScrollView(child: LoginForm()),
        ),
      ),
    );
  }
}