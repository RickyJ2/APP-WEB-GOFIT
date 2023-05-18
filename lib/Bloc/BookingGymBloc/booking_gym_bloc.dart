import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_gofit/Bloc/BookingGymBloc/booking_gym_event.dart';
import 'package:web_gofit/Bloc/BookingGymBloc/booking_gym_state.dart';
import 'package:web_gofit/Model/booking_gym.dart';
import 'package:web_gofit/Repository/booking_gym_repository.dart';

import '../../StateBlocTemplate/form_submission_state.dart';
import '../../StateBlocTemplate/page_fetched_data_state.dart';

class BookingGymBloc extends Bloc<BookingGymEvent, BookingGymState> {
  final BookingGymRepository bookingGymRepository;

  BookingGymBloc({required this.bookingGymRepository})
      : super(BookingGymState()) {
    on<BookingGymDataFetched>((event, emit) => _onDataFetched(event, emit));
    on<BookingGymUpdateRequested>(
        (event, emit) => _onUpdateRequested(event, emit));
  }

  void _onDataFetched(
      BookingGymDataFetched event, Emitter<BookingGymState> emit) async {
    emit(state.copyWith(
      pageFetchedDataState: PageFetchedDataLoading(),
      updateFormSubmissionState: const InitialFormState(),
    ));
    try {
      List<BookingGym> bookingGymList = await bookingGymRepository.index();
      emit(state.copyWith(
        bookinGGymList: bookingGymList,
        pageFetchedDataState: PageFetchedDataSuccess(bookingGymList),
      ));
    } catch (e) {
      emit(state.copyWith(
        pageFetchedDataState: PageFetchedDataFailed(e.toString()),
      ));
    }
  }

  void _onUpdateRequested(
      BookingGymUpdateRequested event, Emitter<BookingGymState> emit) async {
    emit(state.copyWith(
      pageFetchedDataState: const InitialPageFetchedDataState(),
      updateFormSubmissionState: FormSubmitting(),
    ));
    try {
      await bookingGymRepository.updatePresent(event.bookingGym);
      emit(state.copyWith(
        updateFormSubmissionState: SubmissionSuccess(),
      ));
    } catch (e) {
      emit(state.copyWith(
        updateFormSubmissionState: SubmissionFailed(e.toString()),
      ));
    }
  }
}
