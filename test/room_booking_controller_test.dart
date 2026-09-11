import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_management/modules/unauthorised/room_booking/controller/room_booking_controller.dart';
import 'package:hotel_management/shared/model/room_model.dart';
import 'package:hotel_management/shared/repo/unauthorised/room_booking/room_repo.dart';

void main() {
  group('RoomBookingController Core & Bonus Tests', () {
    late RoomBookingController controller;
    late Room testRoom;

    setUp(() {
      controller = RoomBookingController(repository: RoomRepository());
      testRoom = const Room(
        roomCode: 'R101',
        roomType: 'Deluxe Room',
        pricePerNight: 3500,
        maxGuests: 2,
      );
    });

    test('Loads hardcoded rooms and existing bookings correctly', () {
      expect(controller.rooms.length, equals(5));
      expect(controller.rooms.first.roomCode, equals('R101'));
      expect(controller.existingBookings, isNotEmpty);
    });

    test('Validates room selection requirement', () {
      final today = DateTime.now();
      controller.setCheckIn(today);
      controller.setCheckOut(today.add(const Duration(days: 2)));

      final isValid = controller.validate();
      expect(isValid, isFalse);
      expect(controller.errorMessage.value, contains('Please select a room'));
    });

    test('Validates date selection requirement', () {
      controller.selectRoom(testRoom);

      final isValid = controller.validate();
      expect(isValid, isFalse);
      expect(controller.errorMessage.value, contains('check-in and check-out dates'));
    });

    test('Calculates nights and total price correctly for valid range', () {
      final today = DateTime.now();
      final checkIn = DateTime(today.year, today.month, today.day + 15);
      final checkOut = DateTime(today.year, today.month, today.day + 18); // 3 nights

      controller.selectRoom(testRoom);
      controller.setCheckIn(checkIn);
      controller.setCheckOut(checkOut);

      expect(controller.validate(), isTrue);
      expect(controller.errorMessage.value, isEmpty);
      expect(controller.nights, equals(3));
      expect(controller.totalPrice, equals(10500.0)); // 3 * 3500
    });

    test('Rejects check-in date in the past', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 2));
      final futureDate = DateTime.now().add(const Duration(days: 2));

      controller.selectRoom(testRoom);
      controller.setCheckIn(pastDate);
      controller.setCheckOut(futureDate);

      expect(controller.validate(), isFalse);
      expect(controller.errorMessage.value, contains('cannot be in the past'));
    });

    test('Rejects same-day check-in and check-out', () {
      final today = DateTime.now().add(const Duration(days: 1));

      controller.selectRoom(testRoom);
      controller.setCheckIn(today);
      controller.setCheckOut(today);

      expect(controller.validate(), isFalse);
      expect(controller.errorMessage.value, contains('same-day stays are not allowed'));
    });

    test('Rejects check-out date earlier than check-in date', () {
      final checkIn = DateTime.now().add(const Duration(days: 5));
      final checkOut = DateTime.now().add(const Duration(days: 2));

      controller.selectRoom(testRoom);
      controller.setCheckIn(checkIn);
      controller.setCheckOut(checkOut);

      expect(controller.validate(), isFalse);
      expect(controller.errorMessage.value, contains('cannot be earlier than check-in date'));
    });

    test('Bonus: Rejects overlapping double-booking for room R101', () {
      final now = DateTime.now();
      // Room R101 is booked for now+2 to now+5
      final checkIn = DateTime(now.year, now.month, now.day + 3);
      final checkOut = DateTime(now.year, now.month, now.day + 6);

      controller.selectRoom(testRoom);
      controller.setCheckIn(checkIn);
      controller.setCheckOut(checkOut);

      expect(controller.isRoomBookedForSelectedDates(testRoom), isTrue);
      expect(controller.validate(), isFalse);
      expect(controller.errorMessage.value, contains('already booked for the chosen dates'));
    });

    test('Bonus: Guest filter filters rooms by capacity', () {
      controller.setGuestFilter(0); // All
      expect(controller.filteredRooms.length, equals(5));

      controller.setGuestFilter(3); // 3+ Guests
      expect(controller.filteredRooms.length, equals(3)); // R201 (3), R202 (3), R301 (4)

      controller.setGuestFilter(4); // 4+ Guests
      expect(controller.filteredRooms.length, equals(1)); // R301 (4)
    });
  });
}
