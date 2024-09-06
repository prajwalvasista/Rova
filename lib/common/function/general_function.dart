import 'package:intl/intl.dart';

class GernalFunction {
  static formatDate(selectedDate) {
    int year = selectedDate.year;
    print(year);
    int month = selectedDate.month;
    int date = selectedDate.day;
    DateTime dateObject = DateTime(year, month, date);
    // Format the date as "Tue, Oct 23"
    String formattedDate = DateFormat('E, MMM dd').format(dateObject);
    return formattedDate;
  }

  static formatDayMonthYear(selectedDate, dateFormate) {
    int year = selectedDate.year;
    int month = selectedDate.month;
    int date = selectedDate.day;
    DateTime dateObject = DateTime(year, month, date);
    // Format the date as "Tue, Oct 23"
    String formattedDate = DateFormat(dateFormate).format(dateObject);
    return formattedDate;
  }

  static formatTime(selectedTime) {
    // Convert input string to DateTime
    DateTime time = DateFormat('HH:mm').parse(selectedTime);

    // Format the DateTime to the desired format
    String formattedTime = DateFormat('hh:mm a').format(time);

    return formattedTime;
  }

  static calculatePercentage(double value, double totalValue) {
    double discount = totalValue - value;
    double percentageValue = (discount / totalValue) * 100;
    return percentageValue;
  }
}
