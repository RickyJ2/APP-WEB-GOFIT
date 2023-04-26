import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../Bloc/AppBloc/app_bloc.dart';
import '../Bloc/AppBloc/app_event.dart';
import '../Bloc/AppBloc/app_state.dart';
import '../const.dart';

class SideBarPage extends StatelessWidget {
  final Widget mainPageContent;
  const SideBarPage({super.key, required this.mainPageContent});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listenWhen: (previous, current) =>
          previous.authenticated != current.authenticated ||
          previous.selectedIndex != current.selectedIndex,
      listener: (context, state) {
        if (state.authenticated == false) context.go('/login');
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
                    break;
                  }
                case 2:
                  {
                    break;
                  }
                case 3:
                  {
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
                    break;
                  }
                case 3:
                  {
                    break;
                  }
              }
              break;
            }
        }
      },
      child: BlocBuilder<AppBloc, AppState>(builder: (context, state) {
        return Scaffold(
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
                onPressed: () =>
                    context.read<AppBloc>().add(const AppLogoutRequested()),
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
                labelType: NavigationRailLabelType.all,
                groupAlignment: 0,
                selectedIndex: state.selectedIndex,
                destinations: sideBarList[state.user.jabatan - 1],
                onDestinationSelected: (value) =>
                    context.read<AppBloc>().add(ChangedSelectedIndex(value)),
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
                        child: mainPageContent)),
              ),
            ],
          ),
        );
      }),
    );
  }
}
