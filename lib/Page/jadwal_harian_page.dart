import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_gofit/Bloc/JadwalHarianBloc/jadwal_harian_bloc.dart';
import 'package:web_gofit/Bloc/JadwalHarianBloc/jadwal_harian_state.dart';
import 'package:web_gofit/StateBlocTemplate/form_submission_state.dart';
import 'package:web_gofit/StateBlocTemplate/page_fetched_data_state.dart';
import 'package:web_gofit/const.dart';

import '../Asset/confirmation_dialog.dart';
import '../Bloc/JadwalHarianBloc/jadwal_harian_event.dart';
import '../Repository/jadwal_harian_repository.dart';

class JadwalHarianPage extends StatelessWidget {
  const JadwalHarianPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<JadwalHarianBloc>(
      create: (context) =>
          JadwalHarianBloc(jadwalHarianRepository: JadwalHarianRepository()),
      child: const JadwalHarianView(),
    );
  }
}

class JadwalHarianView extends StatefulWidget {
  const JadwalHarianView({super.key});

  @override
  State<JadwalHarianView> createState() => _JadwalHarianViewState();
}

class _JadwalHarianViewState extends State<JadwalHarianView> {
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<JadwalHarianBloc>(context).add(JadwalHarianDataFetched());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JadwalHarianBloc, JadwalHarianState>(
      listener: (context, state) {
        if (state.pageFetchedDataState is PageFetchedDataFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  (state.pageFetchedDataState as PageFetchedDataFailed)
                      .exception)));
        }
        if (state.findPageFetchedDataState is PageFetchedDataFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  (state.findPageFetchedDataState as PageFetchedDataFailed)
                      .exception)));
        }
        if (state.liburUpdateState is SubmissionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Berhasil mengubah status libur')));
          BlocProvider.of<JadwalHarianBloc>(context)
              .add(JadwalHarianDataFetched());
        }
        if (state.liburUpdateState is SubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  (state.liburUpdateState as SubmissionFailed).exception)));
        }
        if (state.generateState is SubmissionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Berhasil menggenerate jadwal Harian')));
          BlocProvider.of<JadwalHarianBloc>(context)
              .add(JadwalHarianDataFetched());
        }
        if (state.generateState is SubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text((state.generateState as SubmissionFailed).exception)));
        }
      },
      child: BlocBuilder<JadwalHarianBloc, JadwalHarianState>(
        builder: (context, state) {
          return state.pageFetchedDataState is PageFetchedDataLoading ||
                  state.findPageFetchedDataState is PageFetchedDataLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: const TextSpan(
                                  text: 'Jadwal Harian Gym ',
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
                              const SizedBox(height: 10),
                              TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  hintText: 'Cari data jadwal harian',
                                  constraints: const BoxConstraints(
                                      maxHeight: 30, maxWidth: 300),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        BlocProvider.of<JadwalHarianBloc>(
                                                context)
                                            .add(JadwalHarianFindDataRequested(
                                                data: searchController.text));
                                      },
                                      icon: const Icon(Icons.search)),
                                ),
                              )
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: "Refresh Data Jadwal Harian",
                          onPressed: () {
                            BlocProvider.of<JadwalHarianBloc>(context)
                                .add(JadwalHarianDataFetched());
                          },
                          icon: const Icon(Icons.refresh, color: Colors.grey),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<JadwalHarianBloc>(context)
                                .add(JadwalHarianGenerateRequested());
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 8),
                            child: Text(
                              'Generate Jadwal Harian',
                              style: TextStyle(
                                fontFamily: 'SchibstedGrotesk',
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    state.jadwalHarianList.isEmpty
                        ? const Center(child: Text('Data tidak ditemukan'))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                            child: Text('Tanggal',
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
                                  for (var jadwalHarian in state
                                      .jadwalHarianList[
                                          state.jadwalHarianList.length -
                                              state.currentPage]
                                      .jadwalHarianFormatedList)
                                    DataRow(
                                      cells: [
                                        DataCell(
                                          Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  jadwalHarian
                                                      .jadwalHarianList[0]
                                                      .jadwalUmum
                                                      .hari,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  jadwalHarian.tanggal,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        for (var item
                                            in jadwalHarian.jadwalHarianList)
                                          DataCell(
                                            Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      item.jadwalUmum.jamMulai),
                                                  const SizedBox(height: 5),
                                                  Text(item
                                                      .jadwalUmum.kelas.nama),
                                                  const SizedBox(height: 5),
                                                  item.instrukturPenganti == ''
                                                      ? Text(item.jadwalUmum
                                                          .instruktur.nama)
                                                      : Text(item
                                                          .instrukturPenganti),
                                                  const SizedBox(height: 5),
                                                  item.instrukturPenganti != ''
                                                      ? Text(
                                                          '(${item.status} ${item.jadwalUmum.instruktur.nama})')
                                                      : (item.status != ''
                                                          ? Text(
                                                              '(${item.status})')
                                                          : const SizedBox
                                                              .shrink()),
                                                  const SizedBox(height: 5),
                                                  ElevatedButton(
                                                    onPressed: item.status ==
                                                            'libur'
                                                        ? null
                                                        : () {
                                                            void libur() {
                                                              BlocProvider.of<
                                                                          JadwalHarianBloc>(
                                                                      context)
                                                                  .add(JadwalHarianUpdateLiburRequested(
                                                                      id: item
                                                                          .id));
                                                            }

                                                            showDialog(
                                                              context: context,
                                                              builder: (context) =>
                                                                  ConfirmationDialog(
                                                                title:
                                                                    'Konfirmasi',
                                                                message:
                                                                    'Apakah anda yakin ingin meliburkan data Jadwal Harian kelas ${item.jadwalUmum.kelas.nama} pada tanggal ${item.tanggal} jam ${item.jadwalUmum.jamMulai} oleh Instruktur ${item.instrukturPenganti == '' ? item.jadwalUmum.instruktur.nama : item.instrukturPenganti}?',
                                                                onYes: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  libur();
                                                                },
                                                              ),
                                                            );
                                                          },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 5),
                                                      child: Text(
                                                        'Libur',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'SchibstedGrotesk',
                                                          fontSize: 12,
                                                          color: textColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        for (int i = jadwalHarian
                                                .jadwalHarianList.length;
                                            i < state.lengthColumn;
                                            i++)
                                          const DataCell(Text('')),
                                      ],
                                    ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Halaman ${state.currentPage} dari ${state.jadwalHarianList.length}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: accentColor,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  IconButton(
                                    onPressed: state.currentPage == 1
                                        ? null
                                        : () {
                                            BlocProvider.of<JadwalHarianBloc>(
                                                    context)
                                                .add(CurrentPageChanged(
                                                    currentPage:
                                                        state.currentPage - 1));
                                          },
                                    icon: const Icon(
                                      Icons.arrow_back_ios,
                                      size: 15,
                                    ),
                                    color: accentColor,
                                  ),
                                  IconButton(
                                    onPressed: state.currentPage ==
                                            state.jadwalHarianList.length
                                        ? null
                                        : () {
                                            BlocProvider.of<JadwalHarianBloc>(
                                                    context)
                                                .add(CurrentPageChanged(
                                                    currentPage:
                                                        state.currentPage + 1));
                                          },
                                    icon: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                    ),
                                    color: accentColor,
                                  ),
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
