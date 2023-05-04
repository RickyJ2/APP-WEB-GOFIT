import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_gofit/Model/jadwal_umum.dart';
import 'package:web_gofit/Page/home_page.dart';

import 'package:web_gofit/Page/instruktur_page.dart';
import 'package:web_gofit/Page/izin_instruktur_page.dart';
import 'package:web_gofit/Page/jadwal_harian_page.dart';
import 'package:web_gofit/Page/jadwal_umum_page.dart';
import 'package:web_gofit/Page/jadwal_umum_tambah_edit_page.dart';
import 'package:web_gofit/Page/member_tambah_edit_page.dart';
import 'package:web_gofit/Page/transaksi_page.dart';
import 'Bloc/AppBloc/app_bloc.dart';
import 'Model/instruktur.dart';
import 'Model/member.dart';
import 'Page/instruktur_tambah_edit_page.dart';
import 'Page/login_page.dart';
import 'Page/member_page.dart';
import 'Page/side_bar_page.dart';

import 'package:go_router/go_router.dart';

import 'StateBlocTemplate/form_submission_state.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/home',
      builder: (context, state) =>
          const SideBarPage(mainPageContent: HomePage(), selectedIndex: 0),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/instruktur',
      builder: (context, state) => const SideBarPage(
          mainPageContent: InstrukturPage(), selectedIndex: 1),
      routes: [
        GoRoute(
          path: ':tambahEdit',
          builder: (context, state) => SideBarPage(
            mainPageContent: InstrukturTambahEditPage(
                tambahEdit: state.params['tambahEdit']!,
                instruktur: (state.extra ?? const Instruktur()) as Instruktur),
            selectedIndex: 1,
          ),
        ),
      ],
      redirect: (context, state) {
        if (context.read<AppBloc>().state.user.jabatan != 2) {
          return '/home';
        } else {
          return null;
        }
      },
    ),
    GoRoute(
      path: '/member',
      builder: (context, state) => const SideBarPage(
        mainPageContent: MemberPage(),
        selectedIndex: 1,
      ),
      routes: [
        GoRoute(
          path: ':tambahEdit',
          builder: (context, state) => SideBarPage(
            mainPageContent: MemberTambahEditPage(
                tambahEdit: state.params['tambahEdit']!,
                member: (state.extra ?? const Member()) as Member),
            selectedIndex: 1,
          ),
        ),
      ],
      redirect: (context, state) {
        if (context.read<AppBloc>().state.user.jabatan != 3) {
          return '/home';
        } else {
          return null;
        }
      },
    ),
    GoRoute(
      path: '/transaksi',
      builder: (context, state) => const SideBarPage(
        mainPageContent: TransaksiPage(),
        selectedIndex: 4,
      ),
      redirect: (context, state) {
        if (context.read<AppBloc>().state.user.jabatan != 3) {
          return '/home';
        } else {
          return null;
        }
      },
    ),
    GoRoute(
      path: '/jadwal-umum',
      builder: (context, state) => const SideBarPage(
        mainPageContent: JadwalUmumPage(),
        selectedIndex: 1,
      ),
      routes: [
        GoRoute(
          path: ':tambahEdit',
          builder: (context, state) => SideBarPage(
            mainPageContent: JadwalUmumTambahEditPage(
                tambahEdit: state.params['tambahEdit']!,
                jadwalUmum: (state.extra ?? const JadwalUmum()) as JadwalUmum),
            selectedIndex: 1,
          ),
        ),
      ],
      redirect: (context, state) {
        if (context.read<AppBloc>().state.user.jabatan != 1) {
          return '/home';
        } else {
          return null;
        }
      },
    ),
    GoRoute(
      path: '/jadwal-harian',
      builder: (context, state) => const SideBarPage(
        mainPageContent: JadwalHarianPage(),
        selectedIndex: 2,
      ),
      redirect: (context, state) {
        if (context.read<AppBloc>().state.user.jabatan != 1) {
          return '/home';
        } else {
          return null;
        }
      },
    ),
    GoRoute(
      path: '/izin-instruktur',
      builder: (context, state) => const SideBarPage(
        mainPageContent: IzinInstrukturPage(),
        selectedIndex: 3,
      ),
      redirect: (context, state) {
        if (context.read<AppBloc>().state.user.jabatan != 1) {
          return '/home';
        } else {
          return null;
        }
      },
    ),
  ],
  initialLocation: '/home',
  redirect: (context, state) {
    if (!context.read<AppBloc>().state.authenticated &&
        context.read<AppBloc>().state.authState is SubmissionFailed &&
        state.path != '/login') {
      return '/login';
    } else {
      return null;
    }
  },
);
