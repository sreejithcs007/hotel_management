import 'package:intl/intl.dart';

class AppDateUtils {
  /// Truncate a DateTime to midnight (00:00:00) for accurate date-only comparisons.
  static DateTime truncateToMidnight(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Calculates the number of nights between checkIn and checkOut.
  /// Standard hotel logic: checkOut day minus checkIn day.
  static int calculateNights(DateTime checkIn, DateTime checkOut) {
    final start = truncateToMidnight(checkIn);
    final end = truncateToMidnight(checkOut);
    return end.difference(start).inDays;
  }

  /// Formats a DateTime into a readable string format (e.g., '15 Sep 2026').
  static String formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Check if checkIn is before today (today is allowed).
  static bool isBeforeToday(DateTime checkIn) {
    final today = truncateToMidnight(DateTime.now());
    final checkInMidnight = truncateToMidnight(checkIn);
    return checkInMidnight.isBefore(today);
  }

  /// Checks if two date ranges [startA, endA) and [startB, endB) overlap.
  static bool isDateRangeOverlapping(
    DateTime startA,
    DateTime endA,
    DateTime startB,
    DateTime endB,
  ) {
    final sA = truncateToMidnight(startA);
    final eA = truncateToMidnight(endA);
    final sB = truncateToMidnight(startB);
    final eB = truncateToMidnight(endB);

    return sA.isBefore(eB) && sB.isBefore(eA);
  }
}
