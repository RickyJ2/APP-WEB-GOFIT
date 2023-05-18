import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_gofit/Bloc/BookingGymBloc/booking_gym_bloc.dart';
import 'package:web_gofit/Bloc/BookingGymBloc/booking_gym_state.dart';
import 'package:web_gofit/Repository/booking_gym_repository.dart';
import 'package:web_gofit/StateBlocTemplate/form_submission_state.dart';
import 'package:web_gofit/StateBlocTemplate/page_fetched_data_state.dart';

import '../Bloc/BookingGymBloc/booking_gym_data_table_source.dart';
import '../Bloc/BookingGymBloc/booking_gym_event.dart';

class BookingGymPage extends StatelessWidget {
  const BookingGymPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingGymBloc>(
      create: (context) =>
          BookingGymBloc(bookingGymRepository: BookingGymRepository()),
      child: const PaginatedDataTableBookingGym(),
    );
  }
}

class PaginatedDataTableBookingGym extends StatefulWidget {
  const PaginatedDataTableBookingGym({super.key});

  @override
  State<PaginatedDataTableBookingGym> createState() =>
      _PaginatedDataTableBookingGymState();
}

class _PaginatedDataTableBookingGymState
    extends State<PaginatedDataTableBookingGym> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BookingGymBloc>(context).add(BookingGymDataFetched());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingGymBloc, BookingGymState>(
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
        if (state.updateFormSubmissionState is SubmissionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Presensi booking gym berhasil'),
            ),
          );
          context.read<BookingGymBloc>().add(BookingGymDataFetched());
        }
        if (state.updateFormSubmissionState is SubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  (state.updateFormSubmissionState as SubmissionFailed)
                      .exception),
            ),
          );
        }
      },
      child: BlocBuilder<BookingGymBloc, BookingGymState>(
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
                              text: 'Data Booking Gym ',
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
                                .read<BookingGymBloc>()
                                .add(BookingGymDataFetched());
                          },
                        ),
                      ],
                    ),
                    PaginatedDataTable(
                      rowsPerPage: state.bookinGGymList.isEmpty
                          ? 1
                          : state.bookinGGymList.length < 10
                              ? state.bookinGGymList.length
                              : 10,
                      columns: const [
                        DataColumn(label: Text('Tanggal')),
                        DataColumn(label: Text('Nomor Struk')),
                        DataColumn(label: Text('ID Member')),
                        DataColumn(label: Text('Nama Member')),
                        DataColumn(label: Text('Tanggal Booking')),
                        DataColumn(label: Text('Sesi')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Action')),
                      ],
                      source:
                          BookingGymDataTableSource(data: state.bookinGGymList),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
