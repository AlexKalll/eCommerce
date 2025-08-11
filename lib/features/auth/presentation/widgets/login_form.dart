import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/button.dart';
import '../../../../core/presentation/widgets/input.dart';
import '../bloc/auth_bloc.dart';

class LoginForm extends StatelessWidget {
  LoginForm({
    super.key,
  });

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
                return 'Email';
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
                return 'Password';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),

          //
          SizedBox(
            width: double.infinity,
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoginInProgress) {
                  return const Center(child: CircularProgressIndicator());
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
          )
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