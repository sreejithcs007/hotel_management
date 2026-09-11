import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../shared/model/room_model.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final bool isSelected;
  final bool isBooked;
  final VoidCallback onTap;

  const RoomCard({
    super.key,
    required this.room,
    required this.isSelected,
    this.isBooked = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    final borderColor = isBooked
        ? const Color(0xFFFDA4AF)
        : isSelected
            ? const Color(0xFF1D61E7)
            : const Color(0xFFE2E8F0);

    final bgColor = isBooked
        ? const Color(0xFFFFF1F2)
        : isSelected
            ? const Color(0xFFF4F8FF)
            : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF1D61E7).withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Radio button indicator
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1D61E7)
                      : const Color(0xFF94A3B8),
                  width: isSelected ? 6 : 2,
                ),
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 14),

            // Thumbnail Image with optional Overlay Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    room.imageUrl,
                    width: 120,
                    height: 85,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 120,
                      height: 85,
                      color: const Color(0xFFE2E8F0),
                      child: const Icon(
                        Icons.king_bed_outlined,
                        color: Color(0xFF94A3B8),
                        size: 36,
                      ),
                    ),
                  ),
                ),
                if (room.imageBadgeText != null) ...[
                  Positioned(
                    bottom: 6,
                    left: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7).withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFFCD34D)),
                      ),
                      child: Center(
                        child: Text(
                          room.imageBadgeText!,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB45309),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(width: 16),

            // Middle Room Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text(
                        room.roomCode,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),

                      // Room Type Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          room.roomType,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ),

                      if (isSelected) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1D61E7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Selected',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ] else if (room.badgeText != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            room.badgeText!,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF15803D),
                            ),
                          ),
                        ),
                      ],

                      if (isBooked) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE4E6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Booked for dates',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE11D48),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),

                  // Room Description
                  Text(
                    room.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Bed, Size, Max Guests row
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      const Icon(Icons.bed_outlined,
                          size: 14, color: Color(0xFF64748B)),
                      Text(
                        room.bedType,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF475569)),
                      ),
                      const Text('  •  ',
                          style: TextStyle(color: Color(0xFFCBD5E1))),
                      const Icon(Icons.group_outlined,
                          size: 14, color: Color(0xFF64748B)),
                      Text(
                        'Max ${room.maxGuests} guests',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF475569)),
                      ),
                      const Text('  •  ',
                          style: TextStyle(color: Color(0xFFCBD5E1))),
                      const Icon(Icons.square_foot,
                          size: 14, color: Color(0xFF64748B)),
                      Text(
                        room.roomSize,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF475569)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Amenities row
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      _buildAmenity(Icons.wifi, 'Free Wi-Fi'),
                      _buildAmenity(Icons.coffee_outlined, 'Breakfast included'),
                      _buildAmenity(Icons.ac_unit, 'Air Conditioning'),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // View Details action link
                  Row(
                    children: const [
                      Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D61E7),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(Icons.arrow_forward,
                          size: 12, color: Color(0xFF1D61E7)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Price column
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currencyFormat.format(room.pricePerNight),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const Text(
                  '/ night',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenity(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: const Color(0xFF64748B)),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
