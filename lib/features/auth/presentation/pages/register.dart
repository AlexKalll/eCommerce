import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/routes/app_routes.dart';
import '../../../../core/presentation/widgets/snackbar.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccess) {
          context.go(Routes.login);
          showInfo(context, 'Registered successfully');
        } else if (state is AuthRegisterFailure) {
          showError(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          actions: [
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: () {
                context.go(Routes.login);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: SingleChildScrollView(child: RegisterForm()),
        ),
      ),
    );
  }
}