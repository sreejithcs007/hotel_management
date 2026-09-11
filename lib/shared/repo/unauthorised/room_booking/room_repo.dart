import '../../../model/booking_model.dart';
import '../../../model/room_model.dart';

class RoomRepository {
  /// Returns the hardcoded list of available rooms matching the design specification.
  List<Room> getRooms() {
    return const [
      Room(
        roomCode: 'R101',
        roomType: 'Deluxe Room',
        pricePerNight: 3500,
        maxGuests: 2,
        bedType: 'King Bed',
        roomSize: '32 m²',
        description: 'Elegant and spacious room with modern amenities',
        imageBadgeText: 'Most Popular',
        amenities: ['Free Wi-Fi', 'Breakfast included', 'Air Conditioning'],
        imageUrl:
            'https://images.unsplash.com/photo-1611892440504-42a792e24d32?auto=format&fit=crop&w=500&q=80',
      ),
      Room(
        roomCode: 'R102',
        roomType: 'Deluxe Room',
        pricePerNight: 3500,
        maxGuests: 2,
        bedType: 'King Bed',
        roomSize: '32 m²',
        description: 'Relax in style with a cozy and modern ambiance',
        amenities: ['Free Wi-Fi', 'Breakfast included', 'Air Conditioning'],
        imageUrl:
            'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=500&q=80',
      ),
      Room(
        roomCode: 'R201',
        roomType: 'Executive Suite',
        pricePerNight: 5800,
        maxGuests: 3,
        bedType: 'Queen Bed',
        roomSize: '45 m²',
        description: 'A premium stay with extra space and luxury',
        badgeText: 'Best Value',
        amenities: ['Free Wi-Fi', 'Breakfast included', 'Air Conditioning'],
        imageUrl:
            'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?auto=format&fit=crop&w=500&q=80',
      ),
      Room(
        roomCode: 'R202',
        roomType: 'Executive Suite',
        pricePerNight: 5800,
        maxGuests: 3,
        bedType: 'Queen Bed',
        roomSize: '45 m²',
        description: 'Spacious suite designed for executive comfort',
        amenities: ['Free Wi-Fi', 'Breakfast included', 'Air Conditioning'],
        imageUrl:
            'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=500&q=80',
      ),
      Room(
        roomCode: 'R301',
        roomType: 'Family Room',
        pricePerNight: 4200,
        maxGuests: 4,
        bedType: '2 Queen Beds',
        roomSize: '50 m²',
        description: 'Perfect for families, with ample space and comfort',
        amenities: ['Free Wi-Fi', 'Breakfast included', 'Air Conditioning'],
        imageUrl:
            'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=500&q=80',
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
