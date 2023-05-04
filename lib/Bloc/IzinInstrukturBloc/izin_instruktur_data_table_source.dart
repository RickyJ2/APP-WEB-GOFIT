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
          child: data[index].isConfirmed
              ? Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green),
                  child: const Text('Terkonfirmasi',
                      style: TextStyle(color: Colors.white)))
              : Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.red),
                  child: const Text('Menunggu',
                      style: TextStyle(color: Colors.white))),
        )),
        DataCell(
          Builder(builder: (context) {
            return ElevatedButton(
              onPressed: data[index].isConfirmed
                  ? null
                  : () {
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
                              'Apakah anda yakin ingin mengonfirmasi izin instruktur untuk kelas ${data[index].kelas.nama} pada tanggal ${data[index].tanggalIzin} yang diajukan oleh ${data[index].instrukturPengaju.nama} ?',
                          onYes: () {
                            Navigator.pop(context);
                            konfirmasi();
                          },
                        ),
                      );
                    },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  'Konfirmasi',
                  style: TextStyle(
                    fontFamily: 'SchibstedGrotesk',
                    color: textColor,
                  ),
                ),
              ),
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
