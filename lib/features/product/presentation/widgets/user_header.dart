import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/presentation/routes/app_routes.dart';
import '../../../../core/presentation/widgets/snackbar.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // box
              Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                  color: Colors.black12,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthLogoutSuccess) {
                      context.push(Routes.login);
                    } else if (state is AuthFailure) {
                      showError(context, 'Unable to logout. Please try again.');
                    }
                  },
                  child: IconButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLogoutRequested());
                    },
                    icon: const Icon(
                      Icons.logout,
                      size: 30,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Greetings
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('July 14, 2024',
                      style: TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Text('Hello, ',
                          style: TextStyle(
                            fontSize: 18,
                          )),
                      BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                        if (state is AuthLoadSuccess) {
                          return Text(
                            state.user.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          return const Text('',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ));
                        }
                      }),
                    ],
                  )
                ],
              ),
            ],
          ),

          // Notification
          IconButton(
            onPressed: () {
              context.push(Routes.chats);
            },
            icon: Icon(
              Icons.notifications_active,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
    );
  }
}