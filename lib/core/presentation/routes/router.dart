import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/presentation/pages/login.dart';
import '../../../features/auth/presentation/pages/register.dart';
import '../../../features/auth/presentation/pages/splash_screen.dart';
import '../../../features/chat/domain/entities/chat.dart';
import '../../../features/chat/presentation/bloc/message/message_bloc.dart';
import '../../../features/chat/presentation/pages/inbox.dart';
import '../../../features/chat/presentation/pages/my_chats.dart';
import '../../../features/chat/presentation/pages/start_chat.dart';
import '../../../features/product/domain/entities/product.dart';
import '../../../features/product/presentation/pages/pages.dart';
import '../../../injection_container.dart' as di;

import 'app_routes.dart';

final router = GoRouter(
  routes: <RouteBase>[
    //! Auth -------------------------------------------------------------------
    GoRoute(
      path: Routes.splashScreen,
      builder: (context, state) => const SplashScreen(),
    ),

    GoRoute(path: Routes.login, builder: (context, state) => const LoginPage()),

    GoRoute(
      path: Routes.register,
      builder: (context, state) => const RegisterPage(),
    ),

    //! Product ----------------------------------------------------------------
    GoRoute(path: Routes.home, builder: (context, state) => const HomePage()),

    GoRoute(
      path: Routes.productDetail,
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductDetailPage(product: product);
      },
    ),

    GoRoute(
      path: Routes.addProduct,
      builder: (context, state) => const AddProductPage(),
    ),

    GoRoute(
      path: Routes.updateProduct,
      builder: (context, state) {
        final product = state.extra as Product;
        return UpdateProductPage(product: product);
      },
    ),

    //! Chat -------------------------------------------------------------------
    GoRoute(
      path: Routes.chatInbox,
      builder: (context, state) {
        final chat = state.extra as Chat;
        return BlocProvider(
          create: (context) => di.serviceLocator<MessageBloc>(),
          child: ChatInboxPage(chat: chat),
        );
      },
    ),
    GoRoute(path: Routes.chats, builder: (context, state) => const ChatsPage()),
    GoRoute(
      path: Routes.startChat,
      builder: (context, state) => const StartChatPage(),
    ),
  ],
);
