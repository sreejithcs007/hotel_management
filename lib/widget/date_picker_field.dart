import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/utils/date_utils.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool isError;
  final ValueChanged<DateTime?> onDateSelected;

  const DatePickerField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.firstDate,
    required this.lastDate,
    this.isError = false,
    required this.onDateSelected,
  });

  Future<void> _pickDate(BuildContext context) async {
    final DateTime initial =
        selectedDate ??
        (firstDate.isAfter(DateTime.now()) ? firstDate : DateTime.now());

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(firstDate) ? firstDate : initial,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  String? get _dayOfWeek {
    if (selectedDate == null) return null;
    return DateFormat('EEE').format(selectedDate!);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasValue = selectedDate != null;

    final borderColor = isError
        ? const Color(0xFFFDA4AF)
        : const Color(0xFFE2E8F0);

    final bgColor = isError
        ? const Color(0xFFFFF1F2)
        : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isError ? const Color(0xFFE11D48) : const Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () => _pickDate(context),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: borderColor,
                width: isError ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: isError
                      ? const Color(0xFFE11D48)
                      : hasValue
                          ? const Color(0xFF0F3C78)
                          : const Color(0xFF94A3B8),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    AppDateUtils.formatDate(selectedDate),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: hasValue
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: hasValue
                          ? const Color(0xFF0F172A)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
                if (hasValue && _dayOfWeek != null) ...[
                  Text(
                    _dayOfWeek!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
