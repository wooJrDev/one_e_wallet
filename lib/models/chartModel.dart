
class DailyChart {
  int timeOfDay;
  double trxAmount;

  DailyChart({this.timeOfDay, this.trxAmount});
}

class WeeklyChart {
  int day;
  double trxAmount;

  WeeklyChart({this.day, this.trxAmount});
}

class MonthlyChart {
  int week;
  double trxAmount;

  MonthlyChart({this.week, this.trxAmount});
}