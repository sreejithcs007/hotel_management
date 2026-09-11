import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/modules/unauthorised/room_booking/controller/room_booking_controller.dart';

class GuestFilterChips extends StatelessWidget {
  final RoomBookingController controller;

  const GuestFilterChips({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final options = [
      {'label': 'All Rooms', 'value': 0},
      {'label': '2+ Guests', 'value': 2},
      {'label': '3+ Guests', 'value': 3},
      {'label': '4+ Guests', 'value': 4},
    ];

    return Obx(() {
      final activeFilter = controller.guestFilter.value;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: options.map((opt) {
            final int val = opt['value'] as int;
            final String baseLabel = opt['label'] as String;
            final int count = controller.countForMinGuests(val);
            final String displayLabel = '$baseLabel ($count)';
            final bool isSelected = activeFilter == val;

            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: () => controller.setGuestFilter(val),
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1D61E7) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF1D61E7)
                          : const Color(0xFFD0D5DD),
                    ),
                  ),
                  child: Text(
                    displayLabel,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? Colors.white : const Color(0xFF344054),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}
