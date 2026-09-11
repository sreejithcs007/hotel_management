class Room {
  final String roomCode;
  final String roomType;
  final double pricePerNight;
  final int maxGuests;
  final String bedType;
  final String roomSize;
  final String description;
  final List<String> amenities;
  final String? badgeText;
  final String? imageBadgeText;
  final String imageUrl;

  const Room({
    required this.roomCode,
    required this.roomType,
    required this.pricePerNight,
    required this.maxGuests,
    required this.bedType,
    required this.roomSize,
    required this.description,
    required this.amenities,
    this.badgeText,
    this.imageBadgeText,
    required this.imageUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Room &&
          runtimeType == other.runtimeType &&
          roomCode == other.roomCode;

  @override
  int get hashCode => roomCode.hashCode;
}
