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
    return BlocListener<AppBloc, AppState>(
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
              content: Text((state.logoutState as AppLoadedFailed).exception),
            ),
          );
        }
      },
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
                      goFit,
                      const SizedBox(width: 30),
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
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.logout,
                        color: textColor,
                      ),
                      onPressed: () => context
                          .read<AppBloc>()
                          .add(const AppLogoutRequested()),
                    ),
                  ],
                ),
                body: Row(
                  children: [
                    NavigationRail(
                      backgroundColor: accentColor,
                      selectedLabelTextStyle: TextStyle(color: primaryColor),
                      unselectedIconTheme: IconThemeData(color: textColor),
                      unselectedLabelTextStyle: TextStyle(color: textColor),
                      labelType: NavigationRailLabelType.selected,
                      groupAlignment: 0,
                      selectedIndex: state.selectedIndex,
                      destinations: sideBarList[state.user.jabatan - 1],
                      onDestinationSelected: (value) {
                        context
                            .read<AppBloc>()
                            .add(ChangedSelectedIndex(selectedIndex: value));
                        switch (state.user.jabatan) {
                          //MO
                          case 1:
                            {
                              switch (value) {
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
                              switch (value) {
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
                              switch (value) {
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
                    const VerticalDivider(thickness: 1, width: 1),
                    Expanded(
                      child: SingleChildScrollView(
                          child: Container(
                              padding: const EdgeInsets.all(20),
                              constraints: BoxConstraints(
                                  minHeight:
                                      MediaQuery.of(context).size.height - 100),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: widget.mainPageContent)),
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
