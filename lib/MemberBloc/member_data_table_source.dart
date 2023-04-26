import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:web_gofit/MemberBloc/member_bloc.dart';
import 'package:web_gofit/const.dart';
import '../Asset/confirmation_dialog.dart';
import '../Model/member.dart';
import '../StateBlocTemplate/form_submission_state.dart';
import 'member_event.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MemberDataTableSource extends DataTableSource {
  List<Member> data;
  MemberDataTableSource({this.data = const []});

  @override
  DataRow? getRow(int index) => DataRow(cells: [
        DataCell(Text(data[index].id.toString())),
        DataCell(Text(data[index].nama.toString())),
        DataCell(Text(data[index].username.toString())),
        DataCell(Text(data[index].alamat.toString())),
        DataCell(Text(data[index].tglLahir.toString())),
        DataCell(Text(data[index].noTelp.toString())),
        DataCell(Text(data[index].email.toString())),
        DataCell(Builder(
          builder: (context) => Row(children: [
            IconButton(
              tooltip: "Edit Data Member",
              onPressed: () {
                context.go('/member/edit', extra: data[index]);
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
            ),
            //Delete Button
            BlocProvider.of<MemberBloc>(context)
                        .state
                        .deleteFormSubmissionState ==
                    FormSubmitting()
                ? const CircularProgressIndicator()
                : IconButton(
                    tooltip: "Hapus Data Member",
                    onPressed: () {
                      void delete() {
                        BlocProvider.of<MemberBloc>(context)
                            .add(MemberDeleteDataRequested(id: data[index].id));
                      }

                      showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                          title: 'Konfirmasi',
                          message:
                              'Apakah anda yakin ingin menghapus data Member ${data[index].nama}?',
                          onYes: () {
                            Navigator.pop(context);
                            delete();
                          },
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
            //Reset Password Button
            BlocProvider.of<MemberBloc>(context)
                        .state
                        .resetPasswordFormSubmissionState ==
                    FormSubmitting()
                ? const CircularProgressIndicator()
                : IconButton(
                    tooltip: "Reset Password Member",
                    onPressed: () {
                      void resetPassword() {
                        BlocProvider.of<MemberBloc>(context).add(
                            MemberResetPasswordRequested(id: data[index].id));
                      }

                      showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                          title: 'Konfirmasi',
                          message:
                              'Apakah anda yakin ingin reset password Member ${data[index].nama}?',
                          onYes: () {
                            Navigator.pop(context);
                            resetPassword();
                          },
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.lock_reset,
                      color: primaryColor,
                    ),
                  ),
            IconButton(
              tooltip: "Cetak Kartu Member",
              onPressed: () {
                Printing.layoutPdf(onLayout: (PdfPageFormat format) {
                  return buildPdf(format, data[index]);
                });
              },
              icon: const Icon(Icons.print),
            ),
          ]),
        ))
      ]);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;

  Future<Uint8List> buildPdf(PdfPageFormat format, Member data) async {
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
                pw.Text('GoFit',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    )),
                pw.Text('Jl. Centralpark No. 10 Yogyakarta'),
                pw.SizedBox(height: 20),
                pw.Text('MEMBER CARD',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 5),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Member ID :'),
                    pw.SizedBox(width: 10),
                    pw.Text(data.id),
                  ],
                ),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Nama :'),
                    pw.SizedBox(width: 10),
                    pw.Text(data.nama),
                  ],
                ),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Alamat :'),
                    pw.SizedBox(width: 10),
                    pw.Text(data.alamat),
                  ],
                ),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Telpon :'),
                    pw.SizedBox(width: 10),
                    pw.Text(data.noTelp),
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
