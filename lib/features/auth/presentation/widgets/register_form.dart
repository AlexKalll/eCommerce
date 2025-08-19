import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/button.dart';
import '../../../../core/presentation/widgets/input.dart';
import '../bloc/auth_bloc.dart';

class RegisterForm extends StatelessWidget {
  RegisterForm({super.key});

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Input(
            label: 'Name',
            controller: _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name is required';
              }
              if (value.length < 3) {
                return 'Name must be at least 3 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          Input(
            label: 'Email',
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!value.contains('@') || !value.contains('.')) {
                return 'Please enter a valid email';
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
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),

          // Error message display
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthRegisterFailure) {
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

          // Register button
          SizedBox(
            width: double.infinity,
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthRegisterInProgress) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 8),
                          Text('Creating account...'),
                        ],
                      ),
                    ),
                  );
                }

                return Button(
                  text: 'Register',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _register(context);
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

  void _register(BuildContext context) {
    context.read<AuthBloc>().add(
      AuthRegisterRequested(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      ),
    );
  }
}
