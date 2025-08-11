import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/button.dart';
import '../../../../core/presentation/widgets/input.dart';
import '../bloc/auth_bloc.dart';

class RegisterForm extends StatelessWidget {
  RegisterForm({
    super.key,
  });

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
                return 'Name';
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
                  text: 'Register',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _register(context);
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

  void _register(BuildContext context) {
    context.read<AuthBloc>().add(
          AuthRegisterRequested(_nameController.text, _emailController.text,
              _passwordController.text),
        );
  }
}