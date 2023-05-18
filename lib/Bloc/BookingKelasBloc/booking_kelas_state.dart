import 'package:web_gofit/Model/booking_kelas.dart';
import 'package:web_gofit/StateBlocTemplate/page_fetched_data_state.dart';

class BookingKelasState {
  final List<BookingKelas> bookingKelasList;
  final PageFetchedDataState pageFetchedDataState;

  BookingKelasState({
    this.bookingKelasList = const [],
    this.pageFetchedDataState = const InitialPageFetchedDataState(),
  });

  BookingKelasState copyWith({
    List<BookingKelas>? bookingKelasList,
    PageFetchedDataState? pageFetchedDataState,
  }) {
    return BookingKelasState(
      bookingKelasList: bookingKelasList ?? this.bookingKelasList,
      pageFetchedDataState: pageFetchedDataState ?? this.pageFetchedDataState,
    );
  }
}
