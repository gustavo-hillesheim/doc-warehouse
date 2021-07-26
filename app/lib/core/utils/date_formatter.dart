class DateFormatter {
  String formatDDMMYYYY(DateTime date) {
    final day = date.day >= 10 ? date.day.toString() : '0${date.day}';
    final month = date.month >= 10 ? date.month.toString() : '0${date.month}';
    return '$day/$month/${date.year}';
  }
}