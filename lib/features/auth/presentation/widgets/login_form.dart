import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/button.dart';
import '../../../../core/presentation/widgets/input.dart';
import '../bloc/auth_bloc.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Input(
            label: 'Email',
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          Input(
            label: 'Password',
            controller: _passwordController,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),

          // Error message display
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoginFailure) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    state.message,
                    style: TextStyle(color: Colors.red.shade700, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Login button
          SizedBox(
            width: double.infinity,
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoginInProgress) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 8),
                          Text('Logging in...'),
                        ],
                      ),
                    ),
                  );
                }

                return Button(
                  text: 'Login',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _login(context);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _login(BuildContext context) {
    context.read<AuthBloc>().add(
      AuthLoginRequested(_emailController.text, _passwordController.text),
    );
  }
}
