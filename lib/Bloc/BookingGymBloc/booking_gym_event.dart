import '../../Model/booking_gym.dart';

abstract class BookingGymEvent {}

class BookingGymDataFetched extends BookingGymEvent {}

class BookingGymUpdateRequested extends BookingGymEvent {
  final BookingGym bookingGym;
  BookingGymUpdateRequested({required this.bookingGym});
}
