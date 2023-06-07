import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:web_gofit/Bloc/JadwalUmumBloc/jadwal_umum_bloc.dart';
import 'package:web_gofit/Bloc/JadwalUmumBloc/jadwal_umum_state.dart';
import 'package:web_gofit/Repository/jadwal_umum_repository.dart';
import 'package:web_gofit/StateBlocTemplate/form_submission_state.dart';
import 'package:web_gofit/StateBlocTemplate/page_fetched_data_state.dart';
import 'package:web_gofit/const.dart';

import '../Asset/confirmation_dialog.dart';
import '../Bloc/JadwalUmumBloc/jadwal_umum_event.dart';

class JadwalUmumPage extends StatelessWidget {
  const JadwalUmumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<JadwalUmumBloc>(
        create: (context) =>
            JadwalUmumBloc(jadwalUmumRepository: JadwalUmumRepository()),
        child: const JadwalUmumView());
  }
}

class JadwalUmumView extends StatefulWidget {
  const JadwalUmumView({super.key});

  @override
  State<JadwalUmumView> createState() => _JadwalUmumViewState();
}

class _JadwalUmumViewState extends State<JadwalUmumView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<JadwalUmumBloc>(context).add(JadwalUmumDataFetched());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JadwalUmumBloc, JadwalUmumState>(
      listener: (context, state) {
        if (state.pageFetchedDataState is PageFetchedDataFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  (state.pageFetchedDataState as PageFetchedDataFailed)
                      .exception)));
        }
        if (state.deleteFormSubmissionState is SubmissionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Data berhasil dihapus')));
          BlocProvider.of<JadwalUmumBloc>(context).add(JadwalUmumDataFetched());
        }
        if (state.deleteFormSubmissionState is SubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  (state.deleteFormSubmissionState as SubmissionFailed)
                      .exception)));
        }
      },
      child: BlocBuilder<JadwalUmumBloc, JadwalUmumState>(
        builder: (context, state) {
          return state.pageFetchedDataState is PageFetchedDataLoading ||
                  state.jadwalUmumList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              text: 'Jadwal Umum Gym ',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 24,
                              ),
                              children: [
                                TextSpan(
                                  text: 'GoFit',
                                  style: TextStyle(
                                    fontFamily: 'SchibstedGrotesk',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: "Refresh Data Jadwal Umum",
                          onPressed: () {
                            BlocProvider.of<JadwalUmumBloc>(context)
                                .add(JadwalUmumDataFetched());
                          },
                          icon: const Icon(Icons.refresh, color: Colors.grey),
                        ),
                        IconButton(
                          tooltip: "Tambah Data Jadwal Umum",
                          icon: const Icon(Icons.add, color: Colors.grey),
                          onPressed: () {
                            context.go('/jadwal-umum/tambah');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    DataTable(
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => primaryColor),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: textColor,
                        ),
                      ),
                      dataRowMinHeight: 100,
                      dataRowMaxHeight: 140,
                      columns: [
                        const DataColumn(
                          label: Expanded(
                              child: Center(
                                  child: Text('Hari',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      )))),
                        ),
                        for (int i = 1; i <= state.lengthColumn; i++)
                          DataColumn(
                            label: Expanded(
                                child: Center(
                                    child: Text('Sesi $i',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        )))),
                          ),
                      ],
                      rows: [
                        for (var jadwalUmum in state.jadwalUmumList)
                          DataRow(
                            cells: [
                              DataCell(
                                Center(
                                    child: Text(jadwalUmum.hari,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ))),
                              ),
                              for (var item in jadwalUmum.jadwalUmumList)
                                DataCell(
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 20),
                                        Text(item.jamMulai),
                                        const SizedBox(height: 5),
                                        Text(item.kelas.nama),
                                        const SizedBox(height: 5),
                                        Text(item.instruktur.nama),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              tooltip: "Edit Data Jadwal Umum",
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                context.go('/jadwal-umum/edit',
                                                    extra: item);
                                              },
                                            ),
                                            IconButton(
                                              tooltip: "Hapus Data Jadwal Umum",
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                void delete() {
                                                  BlocProvider.of<
                                                              JadwalUmumBloc>(
                                                          context)
                                                      .add(
                                                          JadwalUmumDeleteDataRequested(
                                                              id: int.parse(
                                                                  item.id)));
                                                }

                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      ConfirmationDialog(
                                                    title: 'Konfirmasi',
                                                    message:
                                                        'Apakah anda yakin ingin menghapus data Jadwal Umum kelas ${item.kelas.nama} pada hari ${item.hari} jam ${item.jamMulai} oleh Instruktur ${item.instruktur.nama}?',
                                                    onYes: () {
                                                      Navigator.pop(context);
                                                      delete();
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              for (int i = jadwalUmum.jadwalUmumList.length;
                                  i < state.lengthColumn;
                                  i++)
                                const DataCell(Text('')),
                            ],
                          ),
                      ],
                    ),
                  ],
                );
        },
      ),
    );
  }
}
