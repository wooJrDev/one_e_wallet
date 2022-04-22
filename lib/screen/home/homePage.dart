import 'package:flutter/material.dart';
import 'package:one_e_sample/firebase/database.dart';
import 'package:one_e_sample/models/chartModel.dart';
import 'package:one_e_sample/models/sales_card.dart';
import 'package:one_e_sample/models/trx_cardModel.dart';
import 'package:one_e_sample/screen/home/home_ewalletCard.dart';
import 'package:one_e_sample/screen/home/home_topCard.dart';
import 'package:one_e_sample/screen/sales_and_promotions/indvSalesPage.dart';
import 'package:one_e_sample/screen/sales_and_promotions/salesAndPromoPage.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';
import 'package:one_e_sample/screen/expenditure_report/customMonthlyLineChart.dart';
import 'package:one_e_sample/screen/expenditure_report/customWeeklyLineChart.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class HomePage  extends StatefulWidget {
  @override
 _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _salesCardCount;

  Future _refreshPage() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    

    return Scaffold(
      backgroundColor: ColourTheme.lightBackground,
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: Container(
          child: ListView(
            physics: ClampingScrollPhysics(),
            children: [
              HomeTopCard(), //* UE-wallet Top Menu Interface
              SizedBox(height: GeneralPositioning.homePage_spaceSections),
              EwalletServiceSection(), //* Ewallet cards with basic E-wallet info
              SizedBox(height: GeneralPositioning.homePage_spaceSections),
              ExpenditureChartSection(), //*Display total expenditure with weekly and monthly toggle switch
              SizedBox(height: GeneralPositioning.homePage_spaceSections),
              SalesPromoSection(), //* Display the lists of E-wallet sales and promotions
              SizedBox(height: GeneralPositioning.homePage_spaceSections),
            ],
          ),
        ),
      ),
    );
  }
}

class EwalletServiceSection extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: GeneralPositioning.mainPadding),
              child: Text(
                'Your E-wallet Accounts',
                style: TextFontStyle.customFontStyle(TextFontStyle.sectionTitle, color: ColourTheme.fontBlue),
              ),
            ),
            SizedBox(height: GeneralPositioning.homePage_spaceBetween_CardAndTitle),
            SizedBox(
              height: 180,
              // color: Colors.purple[100],
              child: StreamProvider.value(
                value: DatabaseService().getEwalletUsers(),
                child: HomeEwalletCard(),
              ),
            ),
          ],
        ),
      );
    }
}

class ExpenditureChartSection extends StatefulWidget {
  @override
  _ExpenditureChartSectionState createState() => _ExpenditureChartSectionState();
}

class _ExpenditureChartSectionState extends State<ExpenditureChartSection> {
  int chartPage = 0; 
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start, //? QUES: Doesn't do anything?
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: GeneralPositioning.mainPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Total Expenditure',
                  style: TextFontStyle.customFontStyle(TextFontStyle.sectionTitle, color: ColourTheme.fontBlue),
                ),
                ToggleSwitch( 
                  //* UPGRADE: Consider using the flutter_switch 0.3.1 instead, current design doesn't fit
                  initialLabelIndex: chartPage,
                  changeOnTap: false,
                  minWidth: 71.0,
                  minHeight: 30,
                  cornerRadius: 20.0,
                  fontSize: 14,
                  inactiveFgColor: Colors.white,
                  labels: ['Weekly', 'Monthly'],
                  // labels: ['Wk', 'Mth'],
                  onToggle: (index) => setState(() {chartPage = index;}),
                ),
              ],
            ),
          ),
          SizedBox(height: GeneralPositioning.homePage_spaceBetween_CardAndTitle),
          Container(
            margin: EdgeInsets.symmetric(horizontal: GeneralPositioning.mainPadding),
            width: double.infinity,
            // height: 300,
            decoration: BoxDecoration(
              color: ColourTheme.ewallet_Grab,
              borderRadius: BorderRadius.circular(ShapeBorderRadius.homeCardRadius),
            ),
            child: chartPage == 0 ? DisplayWeeklyChart() : DisplayMonthlyChart(),
          ) 
          
        ],
      ),
    );
  }
}

class DisplayWeeklyChart extends StatelessWidget {

  double totalWeeklyTrxAmount;
  List<WeeklyChart> wkTrx;
  TrxCardModel trxCardModel = TrxCardModel();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseService().getWeeklyTrx().asBroadcastStream(),
      builder: (context, snapshot) {

        if (snapshot.hasData) {
          List<TrxCardModel> wkTrxLst = snapshot.data;
          totalWeeklyTrxAmount = trxCardModel.getTotalTrx(wkTrxLst);
          wkTrx =  trxCardModel.getWeeklyTrxAmount(wkTrxLst);
        }
        return CustomWeeklyLineChart(wkTrx: wkTrx);
      },
    );
  }
}

class DisplayMonthlyChart extends StatelessWidget {
  double totalMonthlyTrxAmount;
  List<MonthlyChart> mthTrx;
  TrxCardModel trxCardModel = TrxCardModel();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseService().getMonthlyTrx().asBroadcastStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<TrxCardModel> mthTrxLst = snapshot.data;
          totalMonthlyTrxAmount = trxCardModel.getTotalTrx(mthTrxLst);
          mthTrx =  trxCardModel.getMonthlyTrxAmount(mthTrxLst);
        }
        return CustomMonthlyLineChart(mthTrx: mthTrx);
      },
    );
  }
}

class SalesPromoCard extends StatelessWidget {
  final int index;

  SalesPromoCard({this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: GeneralPositioning.mainPadding),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ShapeBorderRadius.homeCardRadius),
      ),
      child: Stack(
        children: <Widget>[
          Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                color: Colors.red[300],
                child: Image(
                  alignment: Alignment.center,
                  image: AssetImage(salesCards[index].salesImg),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: GeneralPositioning.salesCard_TextPadding_horz, vertical: GeneralPositioning.salesCard_TextPadding_vert),
                width: double.infinity,
                height: double.infinity,
                color: salesCards[index].salesDescBgColour,
                child: Text(
                  '${salesCards[index].salesTitle}',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                  style: TextFontStyle.customFontStyle(TextFontStyle.salesCard_salesTitle),
                ),
              ),
            )
          ],
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(40),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => IndvSalesPage(salesDetail: salesCards[index],))),
            ),
          ),
        )
        ],
      ),
    );
  }
}

class SalesPromoSection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: GeneralPositioning.mainPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Sales and Promotions',
                  style: TextFontStyle.customFontStyle(TextFontStyle.sectionTitle, color: ColourTheme.fontBlue),
                ),
                TextButton(
                  child: Text('See All', style: TextStyle(fontSize: TextFontStyle.seeAllButton)),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SalesAndPromoPage())),
                ),
              ],
            ),
          ),
          Container(
            // width: double.infinity, //?QUES: Is this really needed?
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ShapeBorderRadius.homeCardRadius),
            ),
            child: ListView.builder(
              padding: EdgeInsets.only(left: GeneralPositioning.mainPadding),
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                return SalesPromoCard(index: index,);
              },
            ),
          ),
        ],
      ),
    );
  }
}
