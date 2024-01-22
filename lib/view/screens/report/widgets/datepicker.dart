import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final void Function(DateTime) onDateSelected;
  final int? selectedMonth;
  final int? selectedYear;
  final void Function(int, int) onMonthYearSelected;

  DatePicker({
    required this.selectedDate,
    required this.onDateSelected,
    required this.selectedMonth,
    required this.selectedYear,
    required this.onMonthYearSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Date picker
        ElevatedButton(
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2025),
            );
            if (pickedDate != null && pickedDate != selectedDate) {
              onDateSelected(pickedDate);
            }
          },
          child: Text("Select Date"),
        ),
        // Month and year picker
        DropdownButton<int>(
          value: selectedMonth,
          onChanged: (int? month) {
            if (month != null && month != selectedMonth) {
              onMonthYearSelected(month, selectedYear ?? DateTime.now().year);
            }
          },
          items: List.generate(12, (index) {
            return DropdownMenuItem<int>(
              value: index + 1,
              child: Text("Month ${index + 1}"),
            );
          }),
        ),
        DropdownButton<int>(
          value: selectedYear,
          onChanged: (int? year) {
            if (year != null && year != selectedYear) {
              onMonthYearSelected(selectedMonth ?? DateTime.now().month, year);
            }
          },
          items: List.generate(5, (index) {
            return DropdownMenuItem<int>(
              value: DateTime.now().year + index,
              child: Text("${DateTime.now().year + index}"),
            );
          }),
        ),
      ],
    );
  }
}