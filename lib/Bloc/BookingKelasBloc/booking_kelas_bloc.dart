import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_gofit/Bloc/BookingKelasBloc/booking_kelas_event.dart';
import 'package:web_gofit/Bloc/BookingKelasBloc/booking_kelas_state.dart';
import 'package:web_gofit/Repository/booking_kelas_repository.dart';

import '../../Model/booking_kelas.dart';
import '../../StateBlocTemplate/page_fetched_data_state.dart';

class BookingKelasBloc extends Bloc<BookingKelasEvent, BookingKelasState> {
  final BookingKelasRepository bookingKelasRepository;

  BookingKelasBloc({required this.bookingKelasRepository})
      : super(BookingKelasState()) {
    on<BookingKelasDataFetched>(
        (event, emit) => _onBookingKelasDataFetched(event, emit));
  }

  void _onBookingKelasDataFetched(
      BookingKelasDataFetched event, Emitter<BookingKelasState> emit) async {
    emit(state.copyWith(
      pageFetchedDataState: PageFetchedDataLoading(),
    ));
    try {
      List<BookingKelas> bookingKelasList = await bookingKelasRepository.show();
      emit(state.copyWith(
        bookingKelasList: bookingKelasList,
        pageFetchedDataState: PageFetchedDataSuccess(bookingKelasList),
      ));
    } catch (e) {
      emit(state.copyWith(
        pageFetchedDataState: PageFetchedDataFailed(e.toString()),
      ));
    }
  }
}
