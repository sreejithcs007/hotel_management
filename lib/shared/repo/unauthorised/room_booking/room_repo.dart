import '../../../model/booking_model.dart';
import '../../../model/room_model.dart';

class RoomRepository {
  /// Returns the hardcoded list of available rooms as specified in the test requirement.
  List<Room> getRooms() {
    return const [
      Room(
        roomCode: 'R101',
        roomType: 'Deluxe Room',
        pricePerNight: 3500,
        maxGuests: 2,
      ),
      Room(
        roomCode: 'R102',
        roomType: 'Deluxe Room',
        pricePerNight: 3500,
        maxGuests: 2,
      ),
      Room(
        roomCode: 'R201',
        roomType: 'Executive Suite',
        pricePerNight: 5800,
        maxGuests: 3,
      ),
      Room(
        roomCode: 'R202',
        roomType: 'Executive Suite',
        pricePerNight: 5800,
        maxGuests: 3,
      ),
      Room(
        roomCode: 'R301',
        roomType: 'Family Room',
        pricePerNight: 4200,
        maxGuests: 4,
      ),
    ];
  }

  /// Returns existing mock bookings for double-booking testing.
  List<Booking> getExistingBookings() {
    final now = DateTime.now();
    return [
      Booking(
        roomCode: 'R101',
        checkIn: DateTime(now.year, now.month, now.day + 2),
        checkOut: DateTime(now.year, now.month, now.day + 5),
      ),
      Booking(
        roomCode: 'R201',
        checkIn: DateTime(now.year, now.month, now.day + 10),
        checkOut: DateTime(now.year, now.month, now.day + 14),
      ),
    ];
  }
}
