import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_gofit/AppBloc/app_bloc.dart';
import 'package:web_gofit/Page/instruktur_page.dart';
import 'package:web_gofit/Page/main_page.dart';
import 'package:web_gofit/Page/member_tambah_edit_page.dart';
import 'Model/instruktur.dart';
import 'Model/member.dart';
import 'Page/instruktur_tambah_edit_page.dart';
import 'Page/login_page.dart';
import 'Page/member_page.dart';
import 'Page/side_bar_page.dart';

import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/home',
      builder: (context, state) =>
          const SideBarPage(mainPageContent: MainPage()),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/instruktur',
      builder: (context, state) =>
          const SideBarPage(mainPageContent: InstrukturPage()),
      routes: [
        GoRoute(
          path: ':tambahEdit',
          builder: (context, state) => SideBarPage(
            mainPageContent: InstrukturTambahEditPage(
                tambahEdit: state.params['tambahEdit']!,
                instruktur: (state.extra ?? const Instruktur()) as Instruktur),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/member',
      builder: (context, state) =>
          const SideBarPage(mainPageContent: MemberPage()),
      routes: [
        GoRoute(
          path: ':tambahEdit',
          builder: (context, state) => SideBarPage(
            mainPageContent: MemberTambahEditPage(
                tambahEdit: state.params['tambahEdit']!,
                member: (state.extra ?? const Member()) as Member),
          ),
        ),
      ],
    ),
  ],
  initialLocation: '/home',
  redirect: (context, state) {
    if (!context.read<AppBloc>().state.authenticated) {
      return '/login';
    } else {
      return null;
    }
  },
);
