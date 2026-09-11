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

      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options.map((opt) {
          final int val = opt['value'] as int;
          final String label = opt['label'] as String;
          final bool isSelected = activeFilter == val;

          return ChoiceChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                controller.setGuestFilter(val);
              }
            },
            selectedColor: Theme.of(context).colorScheme.primaryContainer,
            labelStyle: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : const Color(0xFF475569),
            ),
          );
        }).toList(),
      );
    });
  }
}
