import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_gofit/const.dart';

import '../Bloc/AppBloc/app_bloc.dart';
import '../Bloc/AppBloc/app_event.dart';
import '../Bloc/AppBloc/app_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: 'Dashboard ',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                color: accentColor,
              ),
              children: [
                TextSpan(
                  text: 'GoFit',
                  style: TextStyle(
                    fontFamily: 'SchibstedGrotesk',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 50,
                  ),
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/interior_gym.jpg'),
                      colorFilter: ColorFilter.mode(
                        Colors.black54,
                        BlendMode.darken,
                      ),
                      fit: BoxFit.cover,
                      repeat: ImageRepeat.noRepeat,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(-4, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selamat Datang, ${BlocProvider.of<AppBloc>(context).state.user.nama} !",
                        style: TextStyle(
                          fontFamily: 'SchibstedGrotesk',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Anda login sebagai ${jabatanList[BlocProvider.of<AppBloc>(context).state.user.jabatan - 1]}',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4 > 200
                            ? 200
                            : MediaQuery.of(context).size.width * 0.4,
                        child: Divider(
                          color: primaryColor,
                          thickness: 3.0,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Selamat datang di website Sistem Informasi Gym GoFit. Silahkan pilih menu yang tersedia di samping kiri atau bawah layar anda.',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: sideBarList[state.user.jabatan - 1]
                .skip(1)
                .toList()
                .asMap()
                .entries
                .map(
                  (e) => Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => context.read<AppBloc>().add(
                                    ChangedSelectedIndex(
                                        selectedIndex: e.key + 1),
                                  ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: const CircleBorder(),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 30,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: accentColor.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(-4, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          e.value['icon'] as IconData,
                                          color: primaryColor,
                                          size: 30,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          e.value['label'].toString(),
                                          style: TextStyle(
                                            fontFamily: 'SchibstedGrotesk',
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                                  0.4 >
                                              200
                                          ? 200
                                          : MediaQuery.of(context).size.width *
                                              0.4,
                                      child: Divider(
                                        color: primaryColor,
                                        thickness: 3.0,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      e.value['deskripsi'].toString(),
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: accentColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      );
    });
  }
}
