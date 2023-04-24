import 'package:flutter/material.dart';

//url Utama Repository
String uri = 'http://127.0.0.1:8000/api/';

//Theme
Color primaryColor = const Color(0xFFFB8B24);
Color accentColor = const Color(0xFF131515);
Color textColor = const Color(0xFFFCF7FF);
Color textColorSecond = const Color(0xFF131515).withOpacity(0.54);
Brightness brightness = Brightness.light;

ColorScheme colorScheme = ColorScheme.fromSwatch(
  primarySwatch: MaterialColor(primaryColor.value, {
    50: Color(primaryColor.value),
    100: Color(primaryColor.value),
    200: Color(primaryColor.value),
    300: Color(primaryColor.value),
    400: Color(primaryColor.value),
    500: Color(primaryColor.value),
    600: Color(primaryColor.value),
    700: Color(primaryColor.value),
    800: Color(primaryColor.value),
    900: Color(primaryColor.value),
  }),
  accentColor: accentColor,
  brightness: brightness,
);

//Logo GoFit
Text goFit = Text(
  'GoFit',
  style: TextStyle(
    fontFamily: 'SchibstedGrotesk',
    color: textColor,
    fontWeight: FontWeight.bold,
  ),
);

//Shared pref key list
final sharedPrefKey = {'token': 'tokenKey'};

//Sidebar List
const sideBarList = [
  //Manajer Operasional
  [
    NavigationRailDestination(
      icon: Icon(Icons.schedule),
      label: Text('Jadwal Umum'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.calendar_month),
      label: Text('Jadwal Harian'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.supervisor_account),
      label: Text('Izin Instruktur'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.summarize),
      label: Text('Laporan'),
    ),
  ],
//Admin
  [
    NavigationRailDestination(
      icon: Icon(Icons.supervisor_account),
      label: Text('Instruktur'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.supervisor_account),
      label: Text('Instruktur'),
    ),
  ],
//Kasir
  [
    NavigationRailDestination(
      icon: Icon(Icons.person),
      label: Text('Member'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.fitness_center),
      label: Text('Presensi Gym'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.sports_gymnastics),
      label: Text('Presensi Kelas'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.point_of_sale),
      label: Text('Transaksi'),
    ),
  ],
];

//enum
enum TambahEdit { tambah, edit }
