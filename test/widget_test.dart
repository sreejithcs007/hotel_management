import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hotel_management/main.dart';
import 'package:hotel_management/modules/unauthorised/room_booking/controller/room_booking_controller.dart';

void main() {
  setUp(() {
    Get.reset();
    Get.put(RoomBookingController());
  });

  testWidgets('App starts without crashing', (tester) async {
    await tester.pumpWidget(const HotelBookingApp());
    await tester.pumpAndSettle();
    expect(find.byType(HotelBookingApp), findsOneWidget);
  });
}
