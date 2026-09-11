import 'package:go_router/go_router.dart';
import '../widget/not_found_screen.dart';
import '../modules/unauthorised/room_booking/screen/room_booking_screen.dart';
import 'app_route_paths.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutePaths.roomBooking,
  routes: [
    GoRoute(
      path: AppRoutePaths.roomBooking,
      name: AppRouteNames.roomBooking,
      builder: (context, state) => const RoomBookingScreen(),
    ),
  ],
  errorBuilder: (context, state) => const NotFoundScreen(),
);
