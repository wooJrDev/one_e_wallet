import 'package:flutter/material.dart';
import 'package:one_e_sample/models/trx_cardModel.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';
import 'package:one_e_sample/shared_objects/shared_CardsAndListTile.dart';

class TrxPopUpDialog extends StatelessWidget {
  final TrxCardModel trxCard;
  final VoidCallback onPressed;

  TrxPopUpDialog({@required this.trxCard, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(0),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        decoration: BoxDecoration(
          color: ColourTheme.mainAppColour,
          borderRadius: BorderRadius.circular(25)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(bottom: 30),
              // height: 100,
              child: Text(
                'Transaction Detail',
                style: TextFontStyle.customFontStyle(TextFontStyle.trxPopUpDialog_trxTitle)
              ),
              
            ),
            TrxListTile(trxTitle: "Transaction Type", trxLabel: "${trxCard.trxType}",),
            TrxListTile(trxTitle: "Transaction Method", trxLabel: "${trxCard.trxMethod}",),
            TrxListTile(trxTitle:  trxCard.trxType == "Reload" ? "Reloading To" : "Paying To", trxLabel: "${trxCard.trxRecipient}",),
            TrxListTile(trxTitle: "Transaction Amount", trxLabel: "RM${trxCard.trxAmount.toStringAsFixed(2)}", trxAmountFontSize: TextFontStyle.trxPopUpDialog_subtitle_trxmount,),
            TrxListTile(trxTitle: "Date and Time", trxLabel: "${TrxCardModel().getTrxDate(dateTime: trxCard.trxDateTime)} ${TrxCardModel().getTrxTime(dateTime: trxCard.trxDateTime)}",),
            TrxListTile(trxTitle: "Transaction ID", trxLabel: "${trxCard.trxId}",),

            Container(
              margin: EdgeInsets.only(top: 15),
              child: TextButton(
                onPressed: onPressed, 
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith((states) => ColourTheme.inkWellDarkBlue),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  backgroundColor: MaterialStateProperty.all(ColourTheme.fontBlue)
                ),
                child: Text(
                  'Dismiss',
                  style: TextFontStyle.customFontStyle(TextFontStyle.trxPopUpDialog_button),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrxPopUpCard extends StatelessWidget {
  
  final TrxCardModel trxCard;
  TrxPopUpCard({this.trxCard});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        color: ColourTheme.mainAppColour,
        borderRadius: BorderRadius.circular(25)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(bottom: 30),
            // height: 100,
            child: Text(
              'Transaction Detail',
              style: TextFontStyle.customFontStyle(TextFontStyle.trxPopUpDialog_trxTitle)
            ),
            
          ),
          TrxListTile(trxTitle: "Transaction Type", trxLabel: "${trxCard.trxType}",),
          TrxListTile(trxTitle: "Transaction Method", trxLabel: "${trxCard.trxMethod}",),
          TrxListTile(trxTitle:  trxCard.trxType == "Reload" ? "Reloading To" : "Paying To", trxLabel: "${trxCard.trxRecipient}",),
          TrxListTile(trxTitle: "Transaction Amount", trxLabel: "RM${trxCard.trxAmount.toStringAsFixed(2)}", trxAmountFontSize: TextFontStyle.trxPopUpDialog_subtitle_trxmount,),
          TrxListTile(trxTitle: "Date and Time", trxLabel: "${TrxCardModel().getTrxDate(dateTime: trxCard.trxDateTime)} ${TrxCardModel().getTrxTime(dateTime: trxCard.trxDateTime)}",),
          TrxListTile(trxTitle: "Transaction ID", trxLabel: "${trxCard.trxId}",),

          Container(
            margin: EdgeInsets.only(top: 15),
            child: TextButton(
              onPressed: () => Navigator.pop(context), 
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith((states) => ColourTheme.inkWellDarkBlue),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                backgroundColor: MaterialStateProperty.all(ColourTheme.fontBlue)
              ),
              child: Text(
                'Dismiss',
                style: TextFontStyle.customFontStyle(TextFontStyle.trxPopUpDialog_button),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
