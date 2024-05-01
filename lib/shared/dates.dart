String getWeekdayName(int weekdayNumber) {
  final weekdayNameMap = <int, String>{
    1: "M",
    2: "T",
    3: "W",
    4: "Th",
    5: "F",
    6: "S",
    7: "Su"
  };

  if (weekdayNameMap.containsKey(weekdayNumber)) {
    return weekdayNameMap[weekdayNumber]!;
  } else {
    throw Exception("The given weekday number was not valid");
  }
}

bool sameDay(DateTime date1, DateTime date2) {
  return date1.day == date2.day &&
      date1.month == date2.month &&
      date1.year == date2.year;
}
