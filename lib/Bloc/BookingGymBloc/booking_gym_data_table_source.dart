import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_gofit/Bloc/BookingGymBloc/booking_gym_bloc.dart';
import 'package:web_gofit/Bloc/BookingGymBloc/booking_gym_event.dart';
import 'package:web_gofit/Model/booking_gym.dart';
import 'package:web_gofit/const.dart';

import '../../Asset/confirmation_dialog.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../Model/informasi_umum.dart';
import '../AppBloc/app_bloc.dart';

class BookingGymDataTableSource extends DataTableSource {
  List<BookingGym> data;
  BookingGymDataTableSource({this.data = const []});

  @override
  DataRow? getRow(int index) => DataRow(cells: [
        DataCell(Text(data[index].createdAt)),
        DataCell(Text(data[index].noStruk)),
        DataCell(Text(data[index].member.id)),
        DataCell(Text(data[index].member.nama)),
        DataCell(Text(data[index].tanggal)),
        DataCell(Text(
            'Sesi ${data[index].sesiGym.id} ${data[index].sesiGym.jamMulai} - ${data[index].sesiGym.jamSelesai}')),
        DataCell(data[index].isCanceled
            ? Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), color: Colors.red),
                child: const Text('Dibatalkan',
                    style: TextStyle(color: Colors.white)))
            : Text(data[index].presentAt)),
        DataCell(Builder(
          builder: (context) => Row(
            children: [
              IconButton(
                tooltip: "Presensi Member",
                color: Colors.blue,
                onPressed: data[index].presentAt != ''
                    ? null
                    : () {
                        void update() {
                          BlocProvider.of<BookingGymBloc>(context).add(
                              BookingGymUpdateRequested(
                                  bookingGym: data[index]));
                        }

                        showDialog(
                          context: context,
                          builder: (context) => ConfirmationDialog(
                            title: 'Konfirmasi',
                            message:
                                'Apakah anda yakin ingin mempresensi Member ${data[index].member.nama}?',
                            onYes: () {
                              Navigator.pop(context);
                              update();
                            },
                          ),
                        );
                      },
                icon: const Icon(
                  Icons.present_to_all,
                ),
              ),
              IconButton(
                tooltip: "Cetak Struk Presensi Gym",
                color: primaryColor,
                onPressed: data[index].presentAt == ''
                    ? null
                    : () {
                        Printing.layoutPdf(onLayout: (PdfPageFormat format) {
                          return buildPdf(
                              format,
                              data[index],
                              BlocProvider.of<AppBloc>(context)
                                  .state
                                  .informasiUmum);
                        });
                      },
                icon: const Icon(Icons.print),
              ),
            ],
          ),
        )),
      ]);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;

  Future<Uint8List> buildPdf(PdfPageFormat format, BookingGym data,
      InformasiUmum informasiUmum) async {
    final pw.Document doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(10),
            constraints: const pw.BoxConstraints(maxWidth: 300, maxHeight: 170),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(informasiUmum.nama,
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    )),
                pw.Text(informasiUmum.alamat),
                pw.SizedBox(height: 14),
                pw.Text('STRUK PRESENSI GYM',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Row(
                  children: [
                    pw.Flexible(
                      flex: 1,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('No Struk'),
                          pw.Text('Tanggal'),
                          pw.SizedBox(height: 10),
                          pw.Text('Member',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text('Slot Waktu'),
                        ],
                      ),
                    ),
                    pw.SizedBox(width: 10),
                    pw.Flexible(
                      flex: 3,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(': ${data.noStruk}'),
                          pw.Text(': ${data.presentAt}'),
                          pw.SizedBox(height: 10),
                          pw.Text(': ${data.member.id} / ${data.member.nama}'),
                          pw.Text(
                              ': ${data.sesiGym.jamMulai.substring(0, 2)} - ${data.sesiGym.jamSelesai.substring(0, 2)}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    // Build and return the final Pdf file data
    return await doc.save();
  }
}
