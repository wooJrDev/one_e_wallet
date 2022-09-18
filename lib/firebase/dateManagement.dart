import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Date {
    DateTime now = DateTime.now().add( Duration( hours: 8 ) );
    int ?presentDay;

    DateTime get startOfDay {
      return DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    }

    DateTime get endOfDay {
      return DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
    }

    DateTime get startOfWeek {
      presentDay = now.weekday;
      DateTime startOfWeek = now.subtract( Duration( days: presentDay! - 1 ) ); //Minus 1 when day starts on monday
      startOfWeek = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day );
      
      return startOfWeek;
    }

    DateTime get endOfWeek {
      presentDay = now.weekday;

      DateTime endOfWeek = now.add( Duration( days: DateTime.daysPerWeek - presentDay! ) );
      endOfWeek = DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 11, 59, 59, 999);

      return endOfWeek;
    }

    DateTime startOfMonth({int ?month}) {
      DateTime startOfMonth = DateTime(now.year, month ?? now.month);
      return startOfMonth;
    }

    DateTime get endOfMonth {
      DateTime endOfMonth = DateTime(now.year, now.month + 1, 0, 11, 59, 59, 999);
      return endOfMonth;
    }

    int currentWeekNumber({required DateTime inputDate}) {
      int ?weekDay = DateTime.parse( startOfMonth().toString() ).weekday; //Get first day of the month
      int weekOfMonth = ((inputDate.day + (weekDay - 1) ) / 7).ceil();
      return weekOfMonth;
    }

    int currentTimeOfDay({required DateTime ?inputTime}) {
      var currentHour = inputTime?.hour;

      if (currentHour! >= 0 && currentHour <= 6) 
        return 0;
      else if (currentHour > 6 && currentHour <= 12)
        return 1;
      else if (currentHour > 12 && currentHour <= 18)
        return 2;
      else if (currentHour > 18 && currentHour <= 23)
        return 3;
      return null!;
    }

    ///Converts a date in String into DateTime format
    DateTime stringToDateTime({required String ?inputDate}) {
      return DateTime.parse( DateFormat("dd/MM/yyyy").parse( inputDate! ).toString() );
    }

    ///Converts a date in String into DateTime format with hours
    DateTime stringToOriDateTime({required String ?inputDate}) {
      return DateTime.parse( DateFormat("dd/MM/yyyy hh:mm a").parse( inputDate! ).toString() );
    }


}