import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_gofit/Bloc/IzinInstrukturBloc/izin_instruktur_bloc.dart';
import 'package:web_gofit/Bloc/IzinInstrukturBloc/izin_instruktur_event.dart';
import 'package:web_gofit/Model/izin_instruktur.dart';

import '../../Asset/confirmation_dialog.dart';
import '../../const.dart';

class IzinInstrukturDataTableSource extends DataTableSource {
  List<IzinInstruktur> data;
  IzinInstrukturDataTableSource({this.data = const []});

  @override
  DataRow? getRow(int index) => DataRow(cells: [
        DataCell(Text(data[index].tanggalMengajukan.toString())),
        DataCell(Text(data[index].tanggalIzin.toString())),
        DataCell(Text(data[index].jadwalUmum.jamMulai.toString())),
        DataCell(Text(data[index].kelas.nama.toString())),
        DataCell(Text(data[index].instrukturPengaju.nama.toString())),
        DataCell(Text(data[index].instrukturPenganti.nama.toString())),
        DataCell(Text(data[index].keterangan.toString())),
        DataCell(Center(
          child: data[index].isConfirmed == 2
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green),
                  child: const Text('Disetujui',
                      style: TextStyle(color: Colors.white)))
              : data[index].isConfirmed == 1
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.red),
                      child: const Text('Ditolak',
                          style: TextStyle(color: Colors.white)))
                  : Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: neutralYellowColor),
                      child: const Text('Menunggu',
                          style: TextStyle(color: Colors.white))),
        )),
        DataCell(
          Builder(builder: (context) {
            return Row(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey; // Disabled button color
                        }
                        return Colors.green; // Default button color
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.black
                              .withOpacity(0.5); // Disabled button text color
                        }
                        return Colors.white; // Default button text color
                      },
                    ),
                  ),
                  onPressed: data[index].isConfirmed == 0
                      ? () {
                          void konfirmasi() {
                            BlocProvider.of<IzinInstrukturBloc>(context).add(
                                IzinInstrukturConfirmedDataRequested(
                                    id: data[index].id));
                          }

                          showDialog(
                            context: context,
                            builder: (context) => ConfirmationDialog(
                              title: 'Konfirmasi',
                              message:
                                  'Apakah anda yakin ingin memberikan izin instruktur untuk kelas ${data[index].kelas.nama} pada tanggal ${data[index].tanggalIzin} yang diajukan oleh ${data[index].instrukturPengaju.nama} ?',
                              onYes: () {
                                Navigator.pop(context);
                                konfirmasi();
                              },
                            ),
                          );
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      'Setuju',
                      style: TextStyle(
                        fontFamily: 'SchibstedGrotesk',
                        color: textColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey; // Disabled button color
                        }
                        return Colors.red; // Default button color
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.black
                              .withOpacity(0.5); // Disabled button text color
                        }
                        return Colors.white; // Default button text color
                      },
                    ),
                  ),
                  onPressed: data[index].isConfirmed == 0
                      ? () {
                          void konfirmasi() {
                            BlocProvider.of<IzinInstrukturBloc>(context).add(
                                IzinInstrukturCancelConfirmedDataRequested(
                                    id: data[index].id));
                          }

                          showDialog(
                            context: context,
                            builder: (context) => ConfirmationDialog(
                              title: 'Konfirmasi',
                              message:
                                  'Apakah anda yakin ingin menolak izin instruktur untuk kelas ${data[index].kelas.nama} pada tanggal ${data[index].tanggalIzin} yang diajukan oleh ${data[index].instrukturPengaju.nama} ?',
                              onYes: () {
                                Navigator.pop(context);
                                konfirmasi();
                              },
                            ),
                          );
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      'Tolak',
                      style: TextStyle(
                        fontFamily: 'SchibstedGrotesk',
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ]);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
