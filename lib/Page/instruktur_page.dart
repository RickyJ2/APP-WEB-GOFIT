import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:web_gofit/InstrukturBloc/instruktur_repository.dart';
import 'package:web_gofit/InstrukturBloc/instruktur_state.dart';
import 'package:web_gofit/InstrukturTambahEditBloc/instruktur_tambah_edit_bloc.dart';
import '../InstrukturBloc/instruktur_bloc.dart';
import '../InstrukturBloc/instruktur_data_table_source.dart';
import '../InstrukturBloc/instruktur_event.dart';
import '../StateBlocTemplate/form_submission_state.dart';
import '../StateBlocTemplate/page_fetched_data_state.dart';

class InstrukturPage extends StatelessWidget {
  const InstrukturPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InstrukturTambahEditBloc>(
          create: (context) => InstrukturTambahEditBloc(
            instrukturRepository: InstrukturRepository(),
          ),
        ),
        BlocProvider<InstrukturBloc>(
          create: (context) => InstrukturBloc(
            instrukturRepository: InstrukturRepository(),
          ),
        ),
      ],
      child: const PaginatedDataTableInstruktur(),
    );
  }
}

class PaginatedDataTableInstruktur extends StatefulWidget {
  const PaginatedDataTableInstruktur({super.key});

  @override
  State<PaginatedDataTableInstruktur> createState() =>
      _PaginatedDataTableInstrukturState();
}

class _PaginatedDataTableInstrukturState
    extends State<PaginatedDataTableInstruktur> {
  final searchController = TextEditingController();

  @override
  initState() {
    super.initState();
    BlocProvider.of<InstrukturBloc>(context).add(DataFetched());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InstrukturBloc, InstrukturState>(
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
        if (state.deleteFormSubmissionState is SubmissionSuccess) {
          BlocProvider.of<InstrukturBloc>(context).add(DataFetched());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data berhasil dihapus'),
            ),
          );
        }
        if (state.deleteFormSubmissionState is SubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  (state.deleteFormSubmissionState as SubmissionFailed)
                      .exception),
            ),
          );
        }
      },
      child: BlocBuilder<InstrukturBloc, InstrukturState>(
          builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: Center(
            child: state.pageFetchedDataState is PageFetchedDataLoading
                ? const CircularProgressIndicator()
                : PaginatedDataTable(
                    header: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            text: 'Data Instruktur Gym ',
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
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Cari data instruktur',
                              constraints: const BoxConstraints(
                                  maxHeight: 30, maxWidth: 300),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    BlocProvider.of<InstrukturBloc>(context)
                                        .add(FindDataRequested(
                                            data: searchController.text));
                                  },
                                  icon: const Icon(Icons.search)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    columns: const [
                      DataColumn(label: Text('Nama')),
                      DataColumn(label: Text('Username')),
                      DataColumn(label: Text('Alamat')),
                      DataColumn(label: Text('Tanggal Lahir')),
                      DataColumn(label: Text('No Telp')),
                      DataColumn(label: Text('Action')),
                    ],
                    source:
                        InstrukturDataTableSource(data: state.instrukturList),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          BlocProvider.of<InstrukturBloc>(context)
                              .add(DataFetched());
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          context.go('/instruktur/tambah');
                        },
                      ),
                    ],
                  ),
          ),
        );
      }),
    );
  }
}
