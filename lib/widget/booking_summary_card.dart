import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/modules/unauthorised/room_booking/controller/room_booking_controller.dart';
import 'package:intl/intl.dart';

class BookingSummaryCard extends StatelessWidget {
  final RoomBookingController controller;

  const BookingSummaryCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return Obx(() {
      final error = controller.errorMessage.value;
      final nights = controller.nights;
      final totalPrice = controller.totalPrice;
      final room = controller.selectedRoom.value;
      final bool isValid =
          error.isEmpty && room != null && nights != null && totalPrice != null;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Booking Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Review your selection before proceeding.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 16),

            if (room != null) ...[
              // Room Header Preview with Thumbnail
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        room.imageUrl,
                        width: 56,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 56,
                          height: 44,
                          color: const Color(0xFFE2E8F0),
                          child: const Icon(Icons.king_bed_outlined,
                              size: 20, color: Color(0xFF94A3B8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                room.roomCode,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                room.roomType,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF475569),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${room.bedType}  •  Max ${room.maxGuests} guests  •  ${room.roomSize}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 24),

              _buildSummaryRow(
                  'Rate / Night', currencyFormat.format(room.pricePerNight)),
              const SizedBox(height: 8),

              if (error.isNotEmpty) ...[
                _buildSummaryRow('Total Stay Duration', '—'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F5FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Total Price',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F3C78),
                        ),
                      ),
                      Text(
                        '—',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F3C78),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (nights != null && totalPrice != null) ...[
                _buildSummaryRow(
                    'Total Stay Duration', '$nights ${nights == 1 ? "night" : "nights"}'),
                const SizedBox(height: 16),

                // Total Price Blue Highlight Banner
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F5FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Price',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F3C78),
                        ),
                      ),
                      Text(
                        currencyFormat.format(totalPrice),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F3C78),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ] else ...[
              // Empty State Placeholder
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Select a room and dates above to view your booking summary.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Continue to Booking Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: null, // Intentionally non-functional demo button
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: isValid
                      ? const Color(0xFF0F3C78)
                      : const Color(0xFFA0AEC0),
                  disabledForegroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Flexible(
                      child: Text(
                        'Continue to Booking',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Trust Badges
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildTrustBadge(
                  Icons.calendar_today_outlined,
                  const Color(0xFF0F3C78),
                  'Free cancellation',
                  'Up to 24 hours',
                ),
                _buildTrustBadge(
                  Icons.shield_outlined,
                  const Color(0xFF0F3C78),
                  'Secure booking',
                  'Your data is safe',
                ),
                _buildTrustBadge(
                  Icons.credit_card_outlined,
                  const Color(0xFF0F3C78),
                  'No payment',
                  'Required now',
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildTrustBadge(
      IconData icon, Color iconColor, String title, String subtitle) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
