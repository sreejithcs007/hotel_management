import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/core/utils/date_utils.dart';
import 'package:hotel_management/widget/booking_summary_card.dart';
import 'package:hotel_management/widget/date_picker_field.dart';
import 'package:hotel_management/widget/guest_filter_chips.dart';
import 'package:hotel_management/widget/room_card.dart';
import '../controller/room_booking_controller.dart';

class RoomBookingScreen extends StatelessWidget {
  const RoomBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RoomBookingController>();

    final today = DateTime.now();
    final firstDate = DateTime(today.year, today.month, today.day);
    final lastDate = firstDate.add(const Duration(days: 365));

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Soft slate background
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Navigation Bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 950;
                  return isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            _LogoHeader(),
                            SizedBox(height: 12),
                            _TopUtilityMenu(),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            _LogoHeader(),
                            _TopUtilityMenu(),
                          ],
                        );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Main Content Area inside a floating White Shell Container
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1240),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWideScreen = constraints.maxWidth >= 850;

                      final Widget leftPanel = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 12,
                            runSpacing: 6,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Available Rooms',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'serif',
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Choose from our curated rooms designed for comfort and style.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                              Obx(() => Text(
                                    '${controller.filteredRooms.length} rooms available',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF64748B),
                                    ),
                                  )),
                            ],
                          ),
                          const SizedBox(height: 16),
                          GuestFilterChips(controller: controller),
                          const SizedBox(height: 20),
                          Obx(() {
                            final rooms = controller.filteredRooms;
                            final selected = controller.selectedRoom.value;

                            if (rooms.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.all(40),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Center(
                                  child: Text(
                                    'No rooms available for the selected guest filter.',
                                    style: TextStyle(color: Color(0xFF64748B)),
                                  ),
                                ),
                              );
                            }

                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: rooms.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 14),
                              itemBuilder: (context, index) {
                                final room = rooms[index];
                                final isSelected =
                                    selected?.roomCode == room.roomCode;
                                final isBooked = controller
                                    .isRoomBookedForSelectedDates(room);

                                return RoomCard(
                                  room: room,
                                  isSelected: isSelected,
                                  isBooked: isBooked,
                                  onTap: () => controller.selectRoom(room),
                                );
                              },
                            );
                          }),
                        ],
                      );

                      final Widget rightPanel = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card 1: Select Your Stay Dates
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border:
                                  Border.all(color: const Color(0xFFE2E8F0)),
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
                              children: [
                                const Text(
                                  'Select Your Stay Dates',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Choose your dates to see availability and pricing.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Obx(() {
                                  final checkInVal = controller.checkIn.value;
                                  final checkOutMinDate = checkInVal != null
                                      ? AppDateUtils.truncateToMidnight(
                                              checkInVal)
                                          .add(const Duration(days: 1))
                                      : firstDate;
                                  final error = controller.errorMessage.value;
                                  final nights = controller.nights;
                                  final bool isDateError = error.isNotEmpty &&
                                      (error.contains('Check-out') ||
                                          error.contains('check-in') ||
                                          error.contains('past') ||
                                          error.contains('dates'));

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: DatePickerField(
                                              label: 'Check-in Date',
                                              selectedDate:
                                                  controller.checkIn.value,
                                              firstDate: firstDate,
                                              lastDate: lastDate,
                                              isError: isDateError,
                                              onDateSelected: (date) =>
                                                  controller.setCheckIn(date),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: DatePickerField(
                                              label: 'Check-out Date',
                                              selectedDate:
                                                  controller.checkOut.value,
                                              firstDate: checkOutMinDate,
                                              lastDate: lastDate,
                                              isError: isDateError,
                                              onDateSelected: (date) =>
                                                  controller.setCheckOut(date),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (isDateError) ...[
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.error_outline,
                                              color: Color(0xFFE11D48),
                                              size: 16,
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                error,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFFE11D48),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ] else if (nights != null &&
                                          nights > 0) ...[
                                        const SizedBox(height: 12),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF0F5FF),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.nightlight_round,
                                                size: 16,
                                                color: Color(0xFF0F3C78),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '$nights ${nights == 1 ? "night" : "nights"}',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF0F3C78),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Card 2: Booking Summary Card
                          BookingSummaryCard(controller: controller),

                          const SizedBox(height: 20),

                          // Card 3: Luxury Hotel Promo Banner
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Stack(
                              children: [
                                Container(
                                  height: 120,
                                  color: const Color(0xFF1E293B),
                                  child: Image.network(
                                    'https://images.unsplash.com/photo-1571896349842-33c89424de2d?auto=format&fit=crop&w=800&q=80',
                                    width: double.infinity,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Container(
                                      color: const Color(0xFF0F294A),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.white.withValues(alpha: 0.95),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'More than a stay,',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                        Text(
                                          'a better tomorrow.',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          'LUXURY • COMFORT • ALWAYS',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2,
                                            color: Color(0xFFD97706),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );

                      return isWideScreen
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 3, child: leftPanel),
                                const SizedBox(width: 24),
                                Expanded(flex: 2, child: rightPanel),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                rightPanel,
                                const SizedBox(height: 24),
                                leftPanel,
                              ],
                            );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _LogoHeader extends StatelessWidget {
  const _LogoHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.hotel_sharp, color: Color(0xFF0F3C78), size: 28),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Hotel Room Booking',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'serif',
                color: Color(0xFF0F172A),
              ),
            ),
            Text(
              'Find your perfect stay, make it memorable.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TopUtilityMenu extends StatelessWidget {
  const _TopUtilityMenu();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: const [
        _TopUtilityItem(
          icon: Icons.verified_user_outlined,
          label: 'Secure Booking',
        ),
        _TopUtilityItem(
          icon: Icons.headset_mic_outlined,
          label: '24/7 Support',
        ),
        _TopUtilityItem(
          icon: Icons.person_outline,
          label: 'My Account',
        ),
        Text(
          'Good Stays\nBrighter Tomorrows',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 11,
            fontStyle: FontStyle.italic,
            color: Color(0xFFD97706),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _TopUtilityItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TopUtilityItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF475569)),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF334155),
          ),
        ),
      ],
    );
  }
}
