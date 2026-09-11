import 'package:get/get.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../shared/model/booking_model.dart';
import '../../../../shared/model/room_model.dart';
import '../../../../shared/repo/unauthorised/room_booking/room_repo.dart';

class RoomBookingController extends GetxController {
  final RoomRepository roomRepository;

  RoomBookingController({RoomRepository? repository})
      : roomRepository = repository ?? RoomRepository() {
    loadData();
  }

  // Reactive state
  final RxList<Room> rooms = <Room>[].obs;
  final RxList<Booking> existingBookings = <Booking>[].obs;
  final Rx<Room?> selectedRoom = Rx<Room?>(null);
  final Rx<DateTime?> checkIn = Rx<DateTime?>(null);
  final Rx<DateTime?> checkOut = Rx<DateTime?>(null);
  final RxInt guestFilter = 0.obs; // 0 means All guests
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    rooms.assignAll(roomRepository.getRooms());
    existingBookings.assignAll(roomRepository.getExistingBookings());
  }

  void selectRoom(Room room) {
    selectedRoom.value = room;
    validate();
  }

  void setCheckIn(DateTime? date) {
    checkIn.value = date;
    validate();
  }

  void setCheckOut(DateTime? date) {
    checkOut.value = date;
    validate();
  }

  void setGuestFilter(int minGuests) {
    guestFilter.value = minGuests;
  }

  /// List of rooms filtered by selected minimum guest capacity.
  List<Room> get filteredRooms {
    if (guestFilter.value <= 0) return rooms;
    return rooms.where((r) => r.maxGuests >= guestFilter.value).toList();
  }

  /// Check if a room has an overlapping existing booking for selected dates.
  bool isRoomBookedForSelectedDates(Room room) {
    final start = checkIn.value;
    final end = checkOut.value;
    if (start == null || end == null || !end.isAfter(start)) return false;

    return existingBookings.any((booking) =>
        booking.roomCode == room.roomCode &&
        AppDateUtils.isDateRangeOverlapping(
          start,
          end,
          booking.checkIn,
          booking.checkOut,
        ));
  }

  /// Calculated number of nights for the selected stay duration.
  int? get nights {
    final start = checkIn.value;
    final end = checkOut.value;
    if (start == null || end == null) return null;
    if (!end.isAfter(start)) return null;
    return AppDateUtils.calculateNights(start, end);
  }

  /// Calculated total price (nights x price per night).
  double? get totalPrice {
    final n = nights;
    final room = selectedRoom.value;
    if (n == null || n <= 0 || room == null) return null;
    return n * room.pricePerNight;
  }

  /// Validation logic including double-booking overlap checks.
  bool validate() {
    if (selectedRoom.value == null) {
      errorMessage.value = 'Please select a room to calculate total price.';
      return false;
    }

    if (checkIn.value == null && checkOut.value == null) {
      errorMessage.value = 'Please select check-in and check-out dates.';
      return false;
    }

    if (checkIn.value == null) {
      errorMessage.value = 'Please select a check-in date.';
      return false;
    }

    if (checkOut.value == null) {
      errorMessage.value = 'Please select a check-out date.';
      return false;
    }

    if (AppDateUtils.isBeforeToday(checkIn.value!)) {
      errorMessage.value = 'Check-in date cannot be in the past.';
      return false;
    }

    final checkInMidnight = AppDateUtils.truncateToMidnight(checkIn.value!);
    final checkOutMidnight = AppDateUtils.truncateToMidnight(checkOut.value!);

    if (!checkOutMidnight.isAfter(checkInMidnight)) {
      if (checkOutMidnight.isAtSameMomentAs(checkInMidnight)) {
        errorMessage.value =
            'Check-out date must be after check-in date (same-day stays are not allowed).';
      } else {
        errorMessage.value =
            'Check-out date cannot be earlier than check-in date.';
      }
      return false;
    }

    // Double-booking check
    if (isRoomBookedForSelectedDates(selectedRoom.value!)) {
      errorMessage.value =
          'Selected room (${selectedRoom.value!.roomCode}) is already booked for the chosen dates.';
      return false;
    }

    // Valid
    errorMessage.value = '';
    return true;
  }
}
