import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_gofit/Bloc/IzinInstrukturBloc/izin_instruktur_bloc.dart';
import 'package:web_gofit/Bloc/IzinInstrukturBloc/izin_instruktur_data_table_source.dart';
import 'package:web_gofit/Bloc/IzinInstrukturBloc/izin_instruktur_state.dart';
import 'package:web_gofit/const.dart';

import '../Bloc/IzinInstrukturBloc/izin_instruktur_event.dart';
import '../Repository/izin_instruktur_repository.dart';
import '../StateBlocTemplate/form_submission_state.dart';
import '../StateBlocTemplate/page_fetched_data_state.dart';

class IzinInstrukturPage extends StatelessWidget {
  const IzinInstrukturPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<IzinInstrukturBloc>(
      create: (context) => IzinInstrukturBloc(
        izinInstrukturRepository: IzinInstrukturRepository(),
      ),
      child: const PaginatedDataTableIzinInstruktur(),
    );
  }
}

class PaginatedDataTableIzinInstruktur extends StatefulWidget {
  const PaginatedDataTableIzinInstruktur({super.key});

  @override
  State<PaginatedDataTableIzinInstruktur> createState() =>
      _PaginatedDataTableIzinInstrukturState();
}

class _PaginatedDataTableIzinInstrukturState
    extends State<PaginatedDataTableIzinInstruktur> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<IzinInstrukturBloc>(context)
        .add(IzinInstrukturDataFetched());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IzinInstrukturBloc, IzinInstrukturState>(
      listener: (context, state) {
        if (state.pageFetchedDataState is PageFetchedDataFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  (state.pageFetchedDataState as PageFetchedDataFailed)
                      .exception),
            ),
          );
        }
        if (state.confirmedFormSubmissionState is SubmissionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Izin instruktur berhasil dikonfirmasi'),
            ),
          );
        }
        if (state.confirmedFormSubmissionState is SubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  (state.confirmedFormSubmissionState as SubmissionFailed)
                      .exception),
            ),
          );
        }
      },
      child: BlocBuilder<IzinInstrukturBloc, IzinInstrukturState>(
        builder: (context, state) {
          return state.pageFetchedDataState is PageFetchedDataLoading
              ? const Center(child: CircularProgressIndicator())
              : Scrollbar(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                text: 'Data Izin Instuktur Gym ',
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
                            tooltip: "Refresh Data Izin Instruktur",
                            icon: const Icon(Icons.refresh, color: Colors.grey),
                            onPressed: () {
                              context
                                  .read<IzinInstrukturBloc>()
                                  .add(IzinInstrukturDataFetched());
                            },
                          ),
                          const SizedBox(width: 15),
                          ToggleButtons(
                            onPressed: (int index) {
                              context.read<IzinInstrukturBloc>().add(
                                  IzinInstrukturToogleChanged(
                                      toogleState: index));
                            },
                            isSelected: state.toogleState,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                            selectedColor: textColor,
                            fillColor: primaryColor,
                            color: accentColor,
                            constraints: const BoxConstraints(
                              minWidth: 100,
                              minHeight: 40,
                            ),
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Semua'),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Belum Dikonfirmasi'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      PaginatedDataTable(
                        rowsPerPage: state.izinInstrukturListDisplay.isEmpty
                            ? 1
                            : state.izinInstrukturListDisplay.length < 10
                                ? state.izinInstrukturListDisplay.length
                                : 10,
                        columns: const [
                          DataColumn(label: Text('Tanggal Mengajukan')),
                          DataColumn(label: Text('Tanggal Izin')),
                          DataColumn(label: Text('Jam Kelas')),
                          DataColumn(label: Text('Nama Kelas')),
                          DataColumn(label: Text('Instruktur Pengaju')),
                          DataColumn(label: Text('Instruktur Penganti')),
                          DataColumn(label: Text('Keterangan')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Action')),
                        ],
                        source: IzinInstrukturDataTableSource(
                            data: state.izinInstrukturListDisplay),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
