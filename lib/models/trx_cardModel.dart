import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:one_e_sample/firebase/dateManagement.dart';
import 'package:one_e_sample/models/chartModel.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';

class TrxCardModel {
  String ?trxType;
  String ?trxMethod;
  String ?trxRecipient; //May be null if it's a reload transaction
  double ?trxAmount;
  String ?trxDateTime;
  String ?trxId;

  var cardIcon;
  var cardTraillingColour;

  TrxCardModel({
    this.trxType,
    this.trxMethod,
    this.trxRecipient,
    this.trxAmount,
    this.trxDateTime,
    this.trxId,
  });

  getTrxCardStyle(TrxCardModel trxCard, {String ?dataType}) {
    if (trxCard.trxType == 'Reload') {
      if (dataType == 'Icon')
        return FontAwesomeIcons.moneyBillWaveAlt;
      else if (dataType == 'Colour')
        return ColourTheme.cashIn;
      else if (dataType == "priceLabel")
        return "+";
      else if (dataType == "title")
        return trxCard.trxRecipient;
    }else if (trxCard.trxType == 'Payment') {
      if (dataType == 'Icon')
        return FontAwesomeIcons.tags;
      else if (dataType == 'Colour')
        return ColourTheme.cashOut;
      else if (dataType == "priceLabel")
        return "-";
      else if (dataType == "title")
        return trxCard.trxMethod;
    }
  }

  DateTime getDateTimeFormat({required String dateTime}) {
    return DateTime.parse( DateFormat("dd/MM/y hh:mm a").parse( dateTime ).toString() );
  }

  String getTrxDate({required String dateTime}) {
    return DateFormat("dd/MM/y").format( DateFormat("dd/MM/y hh:mm a").parse( dateTime ) );
    //DateFormat('hh:mm a').format(DateFormat("HH:mm").parse(trxCard.trxDateTime))
  }

  String getTrxTime({required String dateTime}) {
    return DateFormat('hh:mm a').format( DateFormat( "dd/MM/y hh:mm a" ).parse( dateTime ) );
  }

  List<TrxCardModel> getTrxReloadLst(List<TrxCardModel> trxLst) {
    List<TrxCardModel> newLst = trxLst.where((indvTrx) => indvTrx.trxType == "Reload").toList();
    newLst.forEach((indv) { 
      print('Id: ${indv.trxId}, Type: ${indv.trxType}, Method: ${indv.trxMethod}, Recipient: ${indv.trxRecipient}, Amount: ${indv.trxAmount}, Date: ${indv.trxDateTime}');
    });

    return newLst;
  } 

  List<TrxCardModel> getTrxExpenseLst(List<TrxCardModel> trxLst) => trxLst.where((indvTrx) => indvTrx.trxType == "Payment").toList();

  double getTotalTrx(List<TrxCardModel> trxLst ) {
    trxLst = trxLst.where((indvTrx) => indvTrx.trxType == "Payment").toList();
    double totalTrxAmount = trxLst.fold(0, (total, item) => total.toDouble() + item.trxAmount! );
    return totalTrxAmount;
  }

  List<DailyChart> getDailyTrxAmount(List<TrxCardModel> trxLst) {
    List<DailyChart> dailyTrxLst = [];
    Date date = Date();
    // trxLst.forEach((singleTrx) {
    //   var dateTimeTrx = date.stringToOriDateTime(inputDate: singleTrx.trxDateTime);
    //   print('Current Time: ${dateTimeTrx} Get TimeOfDay: ${date.currentTimeOfDay(inputTime: dateTimeTrx)}');
    //  });
    //* 12-6:59 Midnight, 7-1259: morning 1-6:59 noon 7-11:59 Evening
    for (var index = 0; index <= 3; index++) {
      // var dateTimeTrx = date.stringToOriDateTime(inputDate: trxLst);
      double sumOfTheHour = trxLst
        .where((item) => date.currentTimeOfDay(inputTime: date.stringToOriDateTime(inputDate: item.trxDateTime) )  == index)
        .fold(0, (previousValue, item) => previousValue.toDouble() + item.trxAmount!);

      dailyTrxLst.add( DailyChart(timeOfDay: index, trxAmount: sumOfTheHour) );
    }

    return dailyTrxLst;
  }


  List<WeeklyChart> getWeeklyTrxAmount(List<TrxCardModel> trxLst) {

    List<WeeklyChart> wkTrxLst = [];

    for (var index = 0; index <= 6; index++) {
      double sumOfTheDay = trxLst
        .where((item) => Date().stringToDateTime(inputDate: item.trxDateTime).weekday - 1 == index)
        .fold(0, (previousValue, item) => previousValue.toDouble() + item.trxAmount!);

      wkTrxLst.add( WeeklyChart(day: index, trxAmount: sumOfTheDay) );
    }

     return wkTrxLst;
  }

  List<MonthlyChart> getMonthlyTrxAmount(List<TrxCardModel> trxLst) {
    List<MonthlyChart> mthTrxLst = [];

  // This will generate the time and date for first day of month
    // String firstDay = Date().startOfMonth().toString();
    // String firstDay = date.substring(0, 8) + '01' + date.substring(10);

  // week day for the first day of the month
    // int weekDay = DateTime.parse(firstDay).weekday;
    // int currentWeekDay = DateTime.now().weekday;
    // print('day of the week:$weekDay');
    // print('current day of the week:$currentWeekDay');

    // DateTime inputDate = DateTime.now();
    // DateTime inputDate = DateTime(2021, 6, 20);

  // //  If your calender starts from Monday
  //   weekOfMonth = ((inputDate.day + (weekDay - 1) ) / 7).ceil();
  //   print('Week of the month: $weekOfMonth');
  //   weekDay++;
    // String testDate = trxLst[3].trxDateTime;
    // int testWeek = Date().currentWeekNumber(inputDate: Date().convertStringToDateTime(inputDate: testDate) );
    // print('Test Date: $testDate, Test Week: $testWeek');

    //*Follow index sequence: Week 1 = 0, Week 2 = 1, Week 4,5,6 = 3
    for (int index=0; index <=3; index++ ) {
      // int testWeek = Date().currentWeekNumber(inputDate: Date().convertStringToDateTime(inputDate: ) );
      // print('Test Date: $testDate, Test Week: $testWeek');
      double sumOfTheWeek;
      if (index == 3) { //*If its week 4 and beyond, combine all remaining trx under a single week
        sumOfTheWeek = trxLst
        .where((item) => Date().currentWeekNumber(inputDate: Date().stringToDateTime(inputDate: item.trxDateTime) ) >= 4)
        .fold(0, (previousValue, item) => previousValue.toDouble() + item.trxAmount!);
      } else {
        sumOfTheWeek = trxLst
        .where((item) => Date().currentWeekNumber(inputDate: Date().stringToDateTime(inputDate: item.trxDateTime) ) - 1 == index)
        .fold(0, (previousValue, item) => previousValue.toDouble() + item.trxAmount!);
      }

      mthTrxLst.add( MonthlyChart(week: index, trxAmount: sumOfTheWeek) );
    }
    return mthTrxLst;
  }

}

var trxCardData = [
  {
    "trxType": "Reload",
    "trxMethod": "Visa 1906",
    "trxRecipient": "UE Wallet",
    "trxAmount": 500.00,
    "trxDate": "04/03/2020",
    "trxTime": "14:44",
    "trxId": "uksHRMrX",
  },
  {
    "trxType": "Reload",
    "trxMethod": "UE Wallet",
    "trxRecipient": "TnG",
    "trxAmount": 80.00,
    "trxDate": "05/03/2020",
    "trxTime": "12:44",
    "trxId": "TrxId002",
  },
  {
    "trxTitle": "Payment: Boost",
    "trxType": "Payment",
    "trxMethod": "Boost",
    "trxRecipient": "Mr DIY Mid Valley",
    "trxAmount": 120.00,
    "trxDate": "06/03/2020",
    "trxTime": "14:48",
    "trxId": "TrxId003",
  },
  {
    "trxTitle": "Payment: Boost",
    "trxType": "Payment",
    "trxMethod": "Boost",
    "trxRecipient": "Mr DIY Mid Valley",
    "trxAmount": 93.00,
    "trxDate": "06/03/2020",
    "trxTime": "14:48",
    "trxId": "TrxId003",
  },
  {
    "trxTitle": "Payment: Grab",
    "trxType": "Payment",
    "trxMethod": "Grab",
    "trxRecipient": "Mercarto SuperMart",
    "trxAmount": 150.00,
    "trxDate": "06/03/2020",
    "trxTime": "14:48",
    "trxId": "TrxId003",
  },
];
