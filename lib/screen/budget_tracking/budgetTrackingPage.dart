import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_e_sample/firebase/database.dart';
import 'package:one_e_sample/models/trx_cardModel.dart';
import 'package:one_e_sample/models/userModel.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';
import 'package:one_e_sample/shared_objects/shared_appBar.dart';
import 'package:one_e_sample/shared_objects/shared_appBehaviour.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BudgetTrackingPage extends StatefulWidget {
  @override
  _BudgetTrackingPageState createState() => _BudgetTrackingPageState();
}

class _BudgetTrackingPageState extends State<BudgetTrackingPage> {

  double _currentSpent = 150;
  double ?_currentBudget = 200;
  int ?budgetPercentage;
  int ?budgetPercentageValue;
  String ?_budgetAmount;
  String _budgetErrorMsg = "";

  
  var budgetAmountControl = TextEditingController();


  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: () => removeFocus(),
      child: Scaffold(
        backgroundColor: ColourTheme.lightBackground,
        appBar: BackButtonAppBar(context: context, title: "Budget Tracking"),
        body: StreamBuilder(
          stream: DatabaseService().getMonthlyTrx(),
          builder: (context, snapshot) {

            if (!snapshot.hasData) {
              _currentSpent = 0.00;
            } else {
              List<TrxCardModel>? resultLst = snapshot.data as List<TrxCardModel>?;
              double totalAmount = resultLst!.fold(0, (total, item) => total.toDouble() + item.trxAmount! );
              _currentSpent = totalAmount;
            } 

            return StreamBuilder(
              stream: DatabaseService().getUserDetail,
              builder: (context, snapshot) {

                if (snapshot.hasData) {
                  UserModel? user = snapshot.data as UserModel?;
                  _currentBudget = user!.userBudgetLimit;
                  getBudgetPercentage();
                  return body();

                } else {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  getBudgetPercentage() {
    try {
      //* Will produce Infinity or NaN toInt error when [currentBudget] is null
      int result = ( ( _currentSpent * 100 ) /  _currentBudget! ).round(); 
      // int result = ( ( _currentSpent ?? 55 * 100 ) / _currentBudget ?? 155 ).round(); 
      budgetPercentage = result > 100 ? 100 : result;
      budgetPercentageValue = 100 - budgetPercentage!;
    } catch(e) {
      budgetPercentage = 0;
      budgetPercentageValue = null;
    }
    return true; //? What is this for?
  }

  bool budgetAmountValidation({required double budgetAmountInput}) {
    if (budgetAmountInput == null) {
      setState(() {
        _budgetErrorMsg = "The budget limit cannot be empty";
      });
      return false;
    } else if (budgetAmountInput > 9000) {
      setState(() {
        _budgetErrorMsg = "The budget limit cannot be more than RM9000";
      });
      return false;
    } 

    setState(() {
        _budgetErrorMsg = "";
      });
    return true;
  }

  Widget budgetCardInfo({required String title, String ?amount, Color ?titleColor, Color ?amountColor}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(14),
        // width: 170,
        decoration: BoxDecoration(
          color: ColourTheme.fontWhite,
          borderRadius: BorderRadius.circular(ShapeBorderRadius.budgetTrackingInfo)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('$title', style: TextFontStyle.customFontStyle( TextFontStyle.budgetTrackingPage_budgetInfoTitle, color: titleColor!) ),
            Text('$amount', style: TextFontStyle.customFontStyle( TextFontStyle.budgetTrackingPage_budgetInfoAmount, color: amountColor!, fontWeight: FontWeight.w900 ) ),
          ],
        )
      ),
    );
  }

  Widget budgetLimitForm() {
    return Container(
      // height: 200,
      padding: EdgeInsets.all(GeneralPositioning.mainMediumPadding),
      margin: EdgeInsets.only(top: GeneralPositioning.mainPadding),
      decoration: BoxDecoration(
        color: ColourTheme.orange,
        borderRadius: BorderRadius.circular(ShapeBorderRadius.budgetTrackingUpdateCard)
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Budget Limit:',
                style: TextFontStyle.customFontStyle(TextFontStyle.budgetTrackingPage_budgetLimitTitle),
              ),
              Container(
                width: 160,
                child: TextFormField(
                  controller: budgetAmountControl,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly,],
                  keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                  style: TextFontStyle.customFontStyle(TextFontStyle.ewalletReloadPage_ewalletReloadAmount, color: ColourTheme.fontBlue),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(ShapeBorderRadius.textFormField),
                    ),
                    prefixIcon: Padding(
                      padding:  EdgeInsets.only(left: 15.0),
                      child: Text('RM', style: TextFontStyle.customFontStyle(TextFontStyle.ewalletReloadPage_ewalletReloadAmount, color: ColourTheme.fontBlue),),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  // onChanged: (value) => setState(() => _budgetAmount = value),
                ),
              ),
            ],
          ),
          Visibility(
            visible: _budgetErrorMsg == "" ? false : true,
            child: Container(
              margin: EdgeInsets.only(top: GeneralPositioning.ewalletReloadPage_spaceBetween_title), 
              child: Text(
                '$_budgetErrorMsg', 
                style: TextFontStyle.customFontStyle(TextFontStyle.ewalletReloadPage_errorMessage, color: ColourTheme.fontRed),
              )
            ),
          ),
        ],
      ),
    );
  }

  Widget budgetCircleProgressIndicator() {
    return Container(
      margin: EdgeInsets.only(top: GeneralPositioning.mainPadding),
      // height: 400,
      child: CircularPercentIndicator(
        radius: 280,
        lineWidth: 50.0,
        percent:  budgetPercentage == null ? 0 : budgetPercentage! / 100 ,
        animation: true,
        animateFromLastPercent: true,
        circularStrokeCap: CircularStrokeCap.butt,
        backgroundColor: ColourTheme.orange,
        progressColor: ColourTheme.fontBlue,
        center: Container(
          width: 150,
          child: Text(
            ' ${budgetPercentageValue == null ? "No Budget Allocated" : "Remaining Budget $budgetPercentageValue%"}', 
            style: TextFontStyle.customFontStyle(TextFontStyle.budgetTrackingPage_graphTitle, fontWeight: FontWeight.w900 , color: ColourTheme.fontBlue),
            textAlign: TextAlign.center
          ),
        ),
      ),
    );
  }

  Widget body() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: GeneralPositioning.mainSmallPadding),
      // color: Colors.limeAccent[200],
      child: ListView(
        children: <Widget>[
          
          budgetCircleProgressIndicator(),
          Container(
            margin: EdgeInsets.only(top: GeneralPositioning.mainPadding),
            height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                budgetCardInfo(title: 'Available Budget:', amount: 'RM${_currentBudget!.toStringAsFixed(2)}', titleColor: ColourTheme.orange , amountColor: ColourTheme.cashIn),
                SizedBox(width: 10),
                budgetCardInfo(title: 'Current Month Expenses:', amount: 'RM${_currentSpent.toStringAsFixed(2)}', titleColor: ColourTheme.fontBlue, amountColor: ColourTheme.cashOut),
              ],
            ),
          ),
          budgetLimitForm(),
          

          Container( //Update Budget Limit Button
            padding: EdgeInsets.symmetric(horizontal: GeneralPositioning.mainSmallPadding),
            margin: EdgeInsets.all(GeneralPositioning.mainPadding),
            child: ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(horizontal: GeneralPositioning.mainSmallPadding, vertical: 15)
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ShapeBorderRadius.boxElevatedButton)
                  ),
                ),
              ),
              child: Text('Update Budget Limit', style: TextFontStyle.customFontStyle(TextFontStyle.budgetTrackingPage_updateBudgetButton),),
              onPressed: () async {
                removeFocus();
                double? budgetAmount = budgetAmountControl.text.isEmpty ? null : double.parse( budgetAmountControl.text );
                if ( budgetAmountValidation( budgetAmountInput: budgetAmount! ) ) {
                  dynamic updateResult = await DatabaseService().updateBudgetLimit(budgetAmount: budgetAmount);
                  if (updateResult) {
                    print('Update successful');
                    setState(() {});
                  }
                }  
              },
            ),
          ),
        ],
      ),
    );
  }
}