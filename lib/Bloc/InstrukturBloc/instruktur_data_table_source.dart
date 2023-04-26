import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../Asset/confirmation_dialog.dart';
import '../../Model/instruktur.dart';
import '../../StateBlocTemplate/form_submission_state.dart';
import 'instruktur_bloc.dart';
import 'instruktur_event.dart';

class InstrukturDataTableSource extends DataTableSource {
  List<Instruktur> data;

  InstrukturDataTableSource({this.data = const []});

  @override
  DataRow? getRow(int index) => DataRow(cells: [
        DataCell(Text(data[index].nama.toString())),
        DataCell(Text(data[index].username.toString())),
        DataCell(Text(data[index].alamat.toString())),
        DataCell(Text(data[index].tglLahir.toString())),
        DataCell(Text(data[index].noTelp.toString())),
        DataCell(Builder(
          builder: (context) => Row(children: [
            IconButton(
              tooltip: "Edit Data Instruktur",
              onPressed: () {
                context.go('/instruktur/edit', extra: data[index]);
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
            ),
            //Delete Button
            BlocProvider.of<InstrukturBloc>(context)
                        .state
                        .deleteFormSubmissionState ==
                    FormSubmitting()
                ? const CircularProgressIndicator()
                : IconButton(
                    tooltip: "Hapus Data Instruktur",
                    onPressed: () {
                      void delete() {
                        BlocProvider.of<InstrukturBloc>(context).add(
                            InstrukturDeleteDataRequested(
                                id: int.parse(data[index].id)));
                      }

                      showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                          title: 'Konfirmasi',
                          message:
                              'Apakah anda yakin ingin menghapus data Instruktur ${data[index].nama}?',
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
                    )),
          ]),
        )),
      ]);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
