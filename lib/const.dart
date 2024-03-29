import 'package:flutter/material.dart';

//url Utama Repository
String uri = 'https://restapi-web-gofit-production.up.railway.app/api/';

//Theme
Color primaryColor = const Color(0xFFFB8B24);
Color accentColor = const Color(0xFF131515);
Color textColor = const Color(0xFFFCF7FF);
Color textColorSecond = const Color(0xFF131515).withOpacity(0.54);
Color errorTextColor = const Color(0xFFE30224);
Color disabledColor = const Color(0xFFF0F0F0);
Color disabledBorderColor = const Color(0xFFD1D1D1);
Color neutralYellowColor = const Color(0xFFFFC107);
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

//nama Jabatan
const jabatanList = ['Manajer Operasional', 'Admin', 'Kasir'];
//Sidebar List
const sideBarList = [
  //Manajer Operasional
  [
    {
      'icon': Icons.home,
      'label': 'Home',
    },
    {
      'icon': Icons.schedule,
      'label': 'Jadwal Umum',
      'deskripsi':
          'Menu untuk menampilkan, menambah, dan mengubah data Jadwal Umum',
    },
    {
      'icon': Icons.calendar_month,
      'label': 'Jadwal Harian',
      'deskripsi': 'Menu untuk menampilkan dan meliburkan data Jadwal Harian',
    },
    {
      'icon': Icons.supervisor_account,
      'label': 'Izin Instruktur',
      'deskripsi':
          'Menu untuk menampilkan, menambah, dan mengubah data Izin Instruktur',
    },
    {
      'icon': Icons.summarize,
      'label': 'Laporan',
      'deskripsi':
          'Menu untuk mencetak Laporan Pendapatan, Laporan Aktivitas Gym, Laporan Aktivitas Kelas, dan Laporan Aktivitas Instruktur',
    },
  ],
//Admin
  [
    {
      'icon': Icons.home,
      'label': 'Home',
    },
    {
      'icon': Icons.supervisor_account,
      'label': 'Instruktur',
      'deskripsi':
          'Menu untuk menampilkan, menambah, dan mengubah data Instruktur',
    },
  ],
//Kasir
  [
    {
      'icon': Icons.home,
      'label': 'Home',
    },
    {
      'icon': Icons.person,
      'label': 'Member',
      'deskripsi': 'Menu untuk menampilkan, menambah, dan mengubah data Member',
    },
    {
      'icon': Icons.fitness_center,
      'label': 'Presensi Gym',
      'deskripsi':
          'Menu untuk menampilkan, mempresensi, dan mencetak struk Presensi Gym',
    },
    {
      'icon': Icons.sports_gymnastics,
      'label': 'Presensi Kelas',
      'deskripsi': 'Menu untuk menampilkan dan mencetak struk Presensi Kelas',
    },
    {
      'icon': Icons.point_of_sale,
      'label': 'Transaksi',
      'deskripsi': 'Menu untuk melakukan Transaksi',
    },
  ],
];
// const sideBarList = [
//   //Manajer Operasional
//   [
//     NavigationRailDestination(
//       icon: Icon(Icons.home),
//       label: Text('Home'),
//     ),
//     NavigationRailDestination(
//       icon: Icon(Icons.schedule),
//       label: Text('Jadwal Umum'),
//     ),
//     NavigationRailDestination(
//       icon: Icon(Icons.calendar_month),
//       label: Text('Jadwal Harian'),
//     ),
//     NavigationRailDestination(
//       icon: Icon(Icons.supervisor_account),
//       label: Text('Izin Instruktur'),
//     ),
//     NavigationRailDestination(
//       icon: Icon(Icons.summarize),
//       label: Text('Laporan'),
//     ),
//   ],
// //Admin
//   [
//     NavigationRailDestination(
//       icon: Icon(Icons.home),
//       label: Text('Home'),
//     ),
//     NavigationRailDestination(
//       icon: Icon(Icons.supervisor_account),
//       label: Text('Instruktur'),
//     ),
//   ],
// //Kasir
//   [
//     NavigationRailDestination(
//       icon: Icon(Icons.home),
//       label: Text('Home'),
//     ),
//     NavigationRailDestination(
//       icon: Icon(Icons.person),
//       label: Text('Member'),
//     ),
//     NavigationRailDestination(
//       icon: Icon(Icons.fitness_center),
//       label: Text('Presensi Gym'),
//     ),
//     NavigationRailDestination(
//       icon: Icon(Icons.sports_gymnastics),
//       label: Text('Presensi Kelas'),
//     ),
//     NavigationRailDestination(
//       icon: Icon(Icons.point_of_sale),
//       label: Text('Transaksi'),
//     ),
//   ],
// ];

//enum
enum TambahEdit { tambah, edit }

//List
final List<String> day = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

final List<String> jenisTransaksi = [
  '',
  'Aktivasi',
  'Deposit Reguler',
  'Deposit Kelas',
];

final List<String> laporanTypeList = [
  'LAPORAN PENDAPATAN BULANAN',
  'LAPORAN AKTIVITAS KELAS BULANAN',
  'LAPORAN AKTIVITAS GYM BULANAN',
  'LAPORAN KINERJA INSTRUKTUR BULANAN',
];

final List<String> bulan = [
  '',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8 ',
  '9',
  '10',
  '11',
  '12',
];

int currentYear = DateTime.now().year;
List<String> yearList = List.generate(currentYear - 2021, (index) {
  if (index == 0) {
    return '';
  }
  return (2022 + index).toString();
});
