import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_gofit/Bloc/BookingKelasBloc/booking_kelas_bloc.dart';
import 'package:web_gofit/Bloc/BookingKelasBloc/booking_kelas_event.dart';
import 'package:web_gofit/Bloc/BookingKelasBloc/booking_kelas_state.dart';
import 'package:web_gofit/Repository/booking_kelas_repository.dart';

import '../Bloc/BookingKelasBloc/booking_kelas_data_table_source.dart';
import '../StateBlocTemplate/page_fetched_data_state.dart';

class BookingKelasPage extends StatelessWidget {
  const BookingKelasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BookingKelasBloc(bookingKelasRepository: BookingKelasRepository()),
      child: const PaginatedDataTableBookingKelas(),
    );
  }
}

class PaginatedDataTableBookingKelas extends StatefulWidget {
  const PaginatedDataTableBookingKelas({super.key});

  @override
  State<PaginatedDataTableBookingKelas> createState() =>
      _PaginatedDataTableBookingKelasState();
}

class _PaginatedDataTableBookingKelasState
    extends State<PaginatedDataTableBookingKelas> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BookingKelasBloc>(context).add(BookingKelasDataFetched());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingKelasBloc, BookingKelasState>(
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
      },
      child: BlocBuilder<BookingKelasBloc, BookingKelasState>(
        builder: (context, state) {
          return state.pageFetchedDataState is PageFetchedDataLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              text: 'Data Booking Kelas ',
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
                          tooltip: "Refresh Data Booking Gym",
                          icon: const Icon(Icons.refresh, color: Colors.grey),
                          onPressed: () {
                            context
                                .read<BookingKelasBloc>()
                                .add(BookingKelasDataFetched());
                          },
                        ),
                      ],
                    ),
                    PaginatedDataTable(
                      rowsPerPage: state.bookingKelasList.isEmpty
                          ? 1
                          : state.bookingKelasList.length < 10
                              ? state.bookingKelasList.length
                              : 10,
                      columns: const [
                        DataColumn(label: Text('Tanggal')),
                        DataColumn(label: Text('Nomor Struk')),
                        DataColumn(label: Text('ID Member')),
                        DataColumn(label: Text('Nama Member')),
                        DataColumn(label: Text('Kelas')),
                        DataColumn(label: Text('Instruktur')),
                        DataColumn(label: Text('Tanggal Booking')),
                        DataColumn(label: Text('Jam Mulai')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Action')),
                      ],
                      source: BookingKelasDataTableSource(
                          data: state.bookingKelasList),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
