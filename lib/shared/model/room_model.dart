class Room {
  final String roomCode;
  final String roomType;
  final double pricePerNight;
  final int maxGuests;

  const Room({
    required this.roomCode,
    required this.roomType,
    required this.pricePerNight,
    required this.maxGuests,
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
