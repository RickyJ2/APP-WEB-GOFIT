import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_gofit/AppBloc/app_bloc.dart';
import 'Page/login_page.dart';
import 'Page/main_page.dart';

import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const MainPage(),
    ),
  ],
  initialLocation: '/',
  redirect: (context, state) {
    if (!context.read<AppBloc>().state.authenticated) {
      return '/login';
    } else {
      return null;
    }
  },
);
