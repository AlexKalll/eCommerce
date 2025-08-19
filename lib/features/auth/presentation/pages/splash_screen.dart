import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/routes/routes.dart';
import '../bloc/auth_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoadSuccess) {
                context.push(Routes.home);
              } else if (state is AuthLoadFailure) {
                context.push(Routes.login);
              }
            },
            child: const CircularProgressIndicator()),
      ),
    );
  }
}