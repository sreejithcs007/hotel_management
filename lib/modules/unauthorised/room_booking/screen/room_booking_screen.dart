import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.hotel_outlined, color: Color(0xFF1E88E5)),
            SizedBox(width: 10),
            Text('Hotel Room Booking'),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 800;

          final Widget leftPanel = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Available Rooms',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              GuestFilterChips(controller: controller),
              const SizedBox(height: 16),
              Obx(() {
                final rooms = controller.filteredRooms;
                final selected = controller.selectedRoom.value;

                if (rooms.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
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
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    final isSelected = selected?.roomCode == room.roomCode;
                    final isBooked = controller.isRoomBookedForSelectedDates(room);

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
              const Text(
                'Select Stay Dates',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              Obx(() => Row(
                    children: [
                      Expanded(
                        child: DatePickerField(
                          label: 'Check-in Date',
                          selectedDate: controller.checkIn.value,
                          firstDate: firstDate,
                          lastDate: lastDate,
                          onDateSelected: (date) => controller.setCheckIn(date),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DatePickerField(
                          label: 'Check-out Date',
                          selectedDate: controller.checkOut.value,
                          firstDate: firstDate,
                          lastDate: lastDate,
                          onDateSelected: (date) => controller.setCheckOut(date),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 24),
              BookingSummaryCard(controller: controller),
            ],
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: isWideScreen
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
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
