import 'dart:async';

import 'package:flutter/material.dart';
import 'package:one_e_sample/firebase/database.dart';
import 'package:one_e_sample/models/chartModel.dart';
import 'package:one_e_sample/models/trx_cardModel.dart';
import 'package:one_e_sample/screen/expenditure_report/customDailyLineChart.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';
import 'package:one_e_sample/shared_objects/shared_appBar.dart';
import 'package:one_e_sample/screen/expenditure_report/customMonthlyLineChart.dart';
import 'package:one_e_sample/screen/expenditure_report/customWeeklyLineChart.dart';

class ExpenditureReportPage extends StatefulWidget {
  @override
  _ExpenditureReportPageState createState() => _ExpenditureReportPageState();
}

class _ExpenditureReportPageState extends State<ExpenditureReportPage> {
  
  double totalDailyTrxAmount;
  double totalWeeklyTrxAmount;
  double totalMonthlyTrxAmount;

  List<DailyChart> dailyTrx;
  List<WeeklyChart> wkTrx;
  List<MonthlyChart> mthTrx;

  TrxCardModel trxCardModel = TrxCardModel();

  Future _refreshPage() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourTheme.lightBackground,
      appBar: backButtonAppBar(context: context, title: 'Expenditure Report'),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: Container(
          child: ListView(
            children: <Widget>[
              
              StreamBuilder(
                stream: DatabaseService().getDailyTrx().asBroadcastStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print('got daily data');

                    List<TrxCardModel> dailyTrxLst = snapshot.data;

                    totalDailyTrxAmount = trxCardModel.getTotalTrx(dailyTrxLst);

                    dailyTrx =  trxCardModel.getDailyTrxAmount(dailyTrxLst);

                  } else {
                    print('No data from daily trx');
                  }

                  return Column(
                    children: <Widget>[
                      expenditureCard(
                        expenditureTitle: 'Daily', 
                        expenditureAmount: '${totalDailyTrxAmount == null ? "0.00" : totalDailyTrxAmount.toStringAsFixed(2)}'
                      ),

                      Container(
                        // height: 450,
                        margin: EdgeInsets.only(top: GeneralPositioning.mainPadding),
                        padding: EdgeInsets.all(15),
                        child: CustomDailyLineChart(dailyTrx: dailyTrx)
                      ),
                    ],
                  );
                },
              ),

              StreamBuilder(
                stream: DatabaseService().getWeeklyTrx().asBroadcastStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {

                    List<TrxCardModel> wkTrxLst = snapshot.data;

                    // trxLst.forEach((element) { 
                    //   print('Weekly Trx Id: ${element.trxId}, Trx Type: ${element.trxType}, Trx Method: ${element.trxMethod}, Trx Recipient: ${element.trxRecipient}, Trx Amount: ${element.trxAmount.toString()}, Trx DateTime: ${element.trxDateTime.toString()},');
                    // });

                    totalWeeklyTrxAmount = trxCardModel.getTotalTrx(wkTrxLst);

                    wkTrx =  trxCardModel.getWeeklyTrxAmount(wkTrxLst);
                    // print('wkTrx Length: ${wkTrx.length}');
                    // wkTrx.forEach((element) { print('Smth: ${element.trxAmount}'); });

                    // print('Total Weekly Amount: $totalWeeklyTrxAmount');

                  }

                  return Column(
                    children: <Widget>[
                      expenditureCard(
                        expenditureTitle: 'Weekly', 
                        expenditureAmount: '${totalWeeklyTrxAmount == null ? "0.00" : totalWeeklyTrxAmount.toStringAsFixed(2)}'
                      ),

                      Container(
                        // height: 450,
                        margin: EdgeInsets.only(top: GeneralPositioning.mainPadding),
                        padding: EdgeInsets.all(15),
                        child: CustomWeeklyLineChart(wkTrx: wkTrx),
                      ),
                    ],
                  );
                },
              ),

              StreamBuilder(
                stream: DatabaseService().getMonthlyTrx().asBroadcastStream(),
                builder: (context, snapshot) {

                  if (snapshot.hasData) {

                    List<TrxCardModel> trxLst = snapshot.data;

                    //* A method to extract Monthly trx grouped by weeks

                    // testLst.forEach((element) { 
                    //   print('''Monthly Trx Id: ${element.trxId}, Trx Type: ${element.trxType},
                    //   Trx Method: ${element.trxMethod}, Trx Recipient: ${element.trxRecipient}, 
                    //   Trx Amount: ${element.trxAmount.toString()}, Trx DateTime: ${element.trxDateTime.toString()},''');
                    // });

                    totalMonthlyTrxAmount = trxCardModel.getTotalTrx(trxLst);

                    mthTrx = trxCardModel.getMonthlyTrxAmount(trxLst);

                    // mthTrx.forEach((item) { 
                    //   print('Week: ${item.week}, TrxAmount: ${item.trxAmount}');
                    // });

                  //   mthTrx.forEach((element) { 
                  //   print('Weekly Trx Id: ${element.trxId}, Trx Type: ${element.trxType}, Trx Method: ${element.trxMethod}, Trx Recipient: ${element.trxRecipient}, Trx Amount: ${element.trxAmount.toString()}, Trx DateTime: ${element.trxDateTime.toString()},');
                  // });

                  } else {
                    print('No data from monthly trx');
                  }

                  return Column(
                    children: <Widget>[
                      expenditureCard(
                        expenditureTitle: 'Monthly', 
                        expenditureAmount: '${totalMonthlyTrxAmount == null ? "0.00" : totalMonthlyTrxAmount.toStringAsFixed(2)}'
                      ),

                      Container(
                        // height: 450,
                        margin: EdgeInsets.only(top: GeneralPositioning.mainPadding),
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: <Widget>[
                            CustomMonthlyLineChart(mthTrx: mthTrx),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget expenditureCard({String expenditureTitle, String expenditureAmount}) {
    return Container(
      margin: EdgeInsets.only(top: GeneralPositioning.mainPadding, left: GeneralPositioning.mainPadding, right: GeneralPositioning.mainPadding),
      // color: Colors.purpleAccent[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$expenditureTitle Expenditure',
            style: TextFontStyle.customFontStyle(TextFontStyle.reportPage_expenditureTitle, color: ColourTheme.fontBlue),
          ),
          SizedBox(height: 5,),
          Container(
            width: MediaQuery.of(context).size.width,
            // width: 300,
            padding: EdgeInsets.symmetric(horizontal: GeneralPositioning.mainPadding, vertical: GeneralPositioning.mainSmallPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular( ShapeBorderRadius.reportAmountCard ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black,
                    blurRadius: 4.0,
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 2.0), // shadow direction: bottom right
                )
              ],
            ),
            child: Stack(
              children: <Widget>[
                Visibility(
                  visible: expenditureAmount == null ? false : true,
                  replacement: CircularProgressIndicator(),
                  child: Text(
                    'RM$expenditureAmount',
                    style: TextFontStyle.customFontStyle(TextFontStyle.reportPage_expenditureAmount, color: ColourTheme.fontBlue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // List<chart.Series<dynamic, dynamic>> lol = [];
}