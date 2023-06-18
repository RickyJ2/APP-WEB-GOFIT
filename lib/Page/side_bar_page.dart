import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../Bloc/AppBloc/app_bloc.dart';
import '../Bloc/AppBloc/app_event.dart';
import '../Bloc/AppBloc/app_state.dart';
import '../StateBlocTemplate/form_submission_state.dart';
import '../StateBlocTemplate/load_app_state.dart';
import '../const.dart';

class SideBarPage extends StatefulWidget {
  final Widget mainPageContent;
  final int selectedIndex;
  const SideBarPage(
      {super.key, required this.mainPageContent, required this.selectedIndex});

  @override
  State<SideBarPage> createState() => _SideBarPageState();
}

class _SideBarPageState extends State<SideBarPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<AppBloc>()
        .add(ChangedSelectedIndex(selectedIndex: widget.selectedIndex));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppBloc, AppState>(
          listenWhen: (previous, current) =>
              previous.authState != current.authState ||
              previous.logoutState != current.logoutState,
          listener: (context, state) {
            if (state.authenticated == false &&
                state.authState is AppLoadedFailed) {
              context.go('/login');
            }
            if (state.logoutState is AppLoadedSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Berhasil Logout'),
                ),
              );
              context.read<AppBloc>().add(const AppLogouted());
              context.go('/login');
            }
            if (state.logoutState is AppLoadedFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text((state.logoutState as AppLoadedFailed).exception),
                ),
              );
            }
          },
        ),
        BlocListener<AppBloc, AppState>(
          listenWhen: (previous, current) =>
              previous.selectedIndex != current.selectedIndex,
          listener: (context, state) {
            switch (state.user.jabatan) {
              //MO
              case 1:
                {
                  switch (state.selectedIndex) {
                    case 0:
                      {
                        context.go('/home');
                        break;
                      }
                    case 1:
                      {
                        context.go('/jadwal-umum');
                        break;
                      }
                    case 2:
                      {
                        context.go('/jadwal-harian');
                        break;
                      }
                    case 3:
                      {
                        context.go('/izin-instruktur');
                        break;
                      }
                    case 4:
                      {
                        context.go('/laporan');
                        break;
                      }
                  }
                  break;
                }
              //Admin
              case 2:
                {
                  switch (state.selectedIndex) {
                    case 0:
                      {
                        context.go('/home');
                        break;
                      }
                    case 1:
                      {
                        context.go('/instruktur');
                        break;
                      }
                  }
                  break;
                }
              //Kasir
              case 3:
                {
                  switch (state.selectedIndex) {
                    case 0:
                      {
                        context.go('/home');
                        break;
                      }
                    case 1:
                      {
                        context.go('/member');
                        break;
                      }
                    case 2:
                      {
                        context.go('/booking-gym');
                        break;
                      }
                    case 3:
                      {
                        context.go('/booking-kelas');
                        break;
                      }
                    case 4:
                      {
                        context.go('/transaksi');
                        break;
                      }
                  }
                  break;
                }
            }
          },
        ),
      ],
      child: BlocBuilder<AppBloc, AppState>(builder: (context, state) {
        return state.authState is FormSubmitting ||
                state.authState is InitialFormState
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      MediaQuery.of(context).size.width > 700
                          ? goFit
                          : Container(),
                      MediaQuery.of(context).size.width > 700
                          ? const SizedBox(width: 30)
                          : Container(),
                      Text(
                        "Selamat Datang, ${BlocProvider.of<AppBloc>(context).state.user.nama} !",
                        style: TextStyle(
                          color: textColor,
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: accentColor,
                  elevation: 0,
                  actions: MediaQuery.of(context).size.width > 700
                      ? [
                          IconButton(
                            icon: Icon(
                              Icons.logout,
                              color: textColor,
                            ),
                            onPressed: () => context
                                .read<AppBloc>()
                                .add(const AppLogoutRequested()),
                          ),
                        ]
                      : [
                          IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: textColor,
                            ),
                            onPressed: () => context
                                .read<AppBloc>()
                                .add(NavigationRailShowChanged()),
                          ),
                        ],
                ),
                body: Row(
                  children: [
                    MediaQuery.of(context).size.width > 700 ||
                            state.showNavigationRail
                        ? const NavigationRailSideBar()
                        : Container(),
                    MainBody(widget: widget),
                  ],
                ),
              );
      }),
    );
  }
}

class NavigationRailSideBar extends StatelessWidget {
  const NavigationRailSideBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      return NavigationRail(
        backgroundColor: accentColor,
        selectedLabelTextStyle: TextStyle(color: primaryColor),
        unselectedIconTheme: IconThemeData(color: textColor),
        unselectedLabelTextStyle: TextStyle(color: textColor),
        labelType: NavigationRailLabelType.selected,
        groupAlignment: 0,
        selectedIndex: state.selectedIndex,
        destinations: sideBarList[state.user.jabatan - 1]
            .map(
              (e) => NavigationRailDestination(
                icon: Icon(e['icon'] as IconData),
                label: Text(
                  e['label'].toString(),
                ),
              ),
            )
            .toList(),
        trailing: MediaQuery.of(context).size.width < 700
            ? IconButton(
                icon: Icon(
                  Icons.logout,
                  color: textColor,
                ),
                onPressed: () =>
                    context.read<AppBloc>().add(const AppLogoutRequested()),
              )
            : null,
        onDestinationSelected: (value) {
          context
              .read<AppBloc>()
              .add(ChangedSelectedIndex(selectedIndex: value));
        },
      );
    });
  }
}

class MainBody extends StatelessWidget {
  const MainBody({
    super.key,
    required this.widget,
  });

  final SideBarPage widget;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      return Expanded(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 100),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 249, 243),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: widget.mainPageContent,
            ),
          ),
        ),
      );
    });
  }
}
