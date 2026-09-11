import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hotel_management/core/theme/app_theme.dart';
import 'package:hotel_management/modules/unauthorised/room_booking/controller/room_booking_controller.dart';
import 'package:hotel_management/routes/app_router.dart';

void main() {
  setUp(() {
    Get.reset();
    Get.put(RoomBookingController());
  });

  testWidgets('App router builds successfully and initial route resolves to RoomBookingScreen', (tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hotel Room Booking'), findsOneWidget);
    expect(find.text('Available Rooms'), findsOneWidget);
  });
}
