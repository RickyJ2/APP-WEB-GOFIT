import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:web_gofit/MemberBloc/member_bloc.dart';
import '../Asset/confirmation_dialog.dart';
import '../Model/member.dart';
import '../StateBlocTemplate/form_submission_state.dart';
import 'member_event.dart';

class MemberDataTableSource extends DataTableSource {
  List<Member> data;
  MemberDataTableSource({this.data = const []});

  @override
  DataRow? getRow(int index) => DataRow(cells: [
        DataCell(Text(data[index].nama.toString())),
        DataCell(Text(data[index].username.toString())),
        DataCell(Text(data[index].alamat.toString())),
        DataCell(Text(data[index].tglLahir.toString())),
        DataCell(Text(data[index].noTelp.toString())),
        DataCell(Text(data[index].email.toString())),
        DataCell(Builder(
          builder: (context) => Row(children: [
            IconButton(
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
                    onPressed: () {
                      void delete() {
                        BlocProvider.of<MemberBloc>(context).add(
                            MemberDeleteDataRequested(
                                id: int.parse(data[index].id)));
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
          ]),
        ))
      ]);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
