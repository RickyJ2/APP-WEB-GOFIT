import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Asset/thousands_formater.dart';
import '../../Model/booking_kelas.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../Model/informasi_umum.dart';
import '../../const.dart';
import '../AppBloc/app_bloc.dart';

class BookingKelasDataTableSource extends DataTableSource {
  List<BookingKelas> data;
  BookingKelasDataTableSource({this.data = const []});

  @override
  DataRow? getRow(int index) => DataRow(cells: [
        DataCell(Text(data[index].createdAt)),
        DataCell(Text(data[index].noStruk)),
        DataCell(Text(data[index].member.id)),
        DataCell(Text(data[index].member.nama)),
        DataCell(Text(data[index].jadwalHarian.jadwalUmum.kelas.nama)),
        DataCell(Text(data[index].jadwalHarian.instrukturPenganti == ''
            ? data[index].jadwalHarian.jadwalUmum.instruktur.nama
            : data[index].jadwalHarian.instrukturPenganti)),
        DataCell(Text(data[index].jadwalHarian.tanggal)),
        DataCell(Text(data[index].jadwalHarian.jadwalUmum.jamMulai)),
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
          builder: (context) => IconButton(
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
        )),
      ]);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;

  Future<Uint8List> buildPdf(PdfPageFormat format, BookingKelas data,
      InformasiUmum informasiUmum) async {
    final pw.Document doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(10),
            constraints: const pw.BoxConstraints(maxWidth: 300, maxHeight: 190),
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
                pw.Text(
                    'STRUK PRESENSI KELAS ${data.jenisPembayaran == jenisTransaksi[3] ? 'PAKET' : ''}',
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
                          pw.Text('Kelas'),
                          pw.Text('Instruktur'),
                          data.jenisPembayaran == jenisTransaksi[2]
                              ? pw.Text('Tariff')
                              : pw.SizedBox(),
                          pw.Text('Sisa Deposit'),
                          data.jenisPembayaran == jenisTransaksi[3]
                              ? pw.Text('berlaku Sampai')
                              : pw.SizedBox(),
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
                              ': ${data.jadwalHarian.jadwalUmum.kelas.nama}'),
                          pw.Text(
                              ': ${data.jadwalHarian.instrukturPenganti == '' ? data.jadwalHarian.jadwalUmum.instruktur.nama : data.jadwalHarian.instrukturPenganti}'),
                          data.jenisPembayaran == jenisTransaksi[2]
                              ? pw.Text(
                                  ': Rp ${ThousandsFormatterString.format(data.jadwalHarian.jadwalUmum.kelas.harga)}')
                              : pw.SizedBox(),
                          data.jenisPembayaran == jenisTransaksi[2]
                              ? pw.Text(
                                  ': Rp ${ThousandsFormatterString.format(data.sisaDeposit)}')
                              : pw.Text(': ${data.sisaDeposit}x'),
                          data.jenisPembayaran == jenisTransaksi[3]
                              ? pw.Text(': ${data.masaBerlakuDeposit}')
                              : pw.SizedBox(),
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
