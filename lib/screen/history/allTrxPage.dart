import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one_e_sample/firebase/database.dart';
import 'package:one_e_sample/models/trx_cardModel.dart';
import 'package:one_e_sample/screen/history/trxPopUp.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';
import 'package:one_e_sample/shared_objects/shared_appBar.dart';

class AllTrxPage extends StatefulWidget {

  String ewalletType = "";

  AllTrxPage({this.ewalletType});

  @override
  _AllTrxPageState createState() => _AllTrxPageState();
}

class _AllTrxPageState extends State<AllTrxPage> {
  List<TrxCardModel> trxList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourTheme.lightBackground,
      appBar: backButtonAppBar(context: context, title: widget.ewalletType == "" ? 'All Transactions' : 'All ${widget.ewalletType} Transactions'),
      body: Container(
              height: 1000,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: GeneralPositioning.mainPadding, vertical: GeneralPositioning.mainPadding),
              child: StreamBuilder<List<TrxCardModel>>(
                stream: DatabaseService().getEwalletTrx(),
                builder: (context, snapshot) {

                  if (!snapshot.hasData) {
                    return Container(
                      height: MediaQuery.of(context).size.height - 240,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: GeneralPositioning.mainSmallPadding,),
                          Text(
                            "Loading",
                            textAlign: TextAlign.center,
                            style: TextFontStyle.customFontStyle(TextFontStyle.ewalletCard_emptyMessage, color: ColourTheme.fontBlue),
                          ),
                        ],
                      ),
                    ); 
                  } else {
                    trxList = snapshot.data;
                    trxList = widget.ewalletType != "" ? trxList.where((indvTrx) => indvTrx.trxMethod == widget.ewalletType || indvTrx.trxRecipient == widget.ewalletType).toList() : trxList;

                    trxList.sort( (a, b) => TrxCardModel().getDateTimeFormat(dateTime: b.trxDateTime).compareTo( TrxCardModel().getDateTimeFormat(dateTime: a.trxDateTime) ) ); //Sort based on DateTime descending order

                    return Visibility(
                      visible: trxList.isEmpty ? false : true,
                      replacement: Container(
                        height: MediaQuery.of(context).size.height - 240,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(FontAwesomeIcons.boxOpen, size: 80, color: ColourTheme.fontBlue,),
                            SizedBox(height: GeneralPositioning.mainSmallPadding,),
                            Text(
                              "No transactions found",
                              textAlign: TextAlign.center,
                              style: TextFontStyle.customFontStyle(TextFontStyle.ewalletCard_emptyMessage, color: ColourTheme.fontBlue),
                            ),
                          ],
                        ),
                      ),
                      child: ListView.builder(
                        itemCount: trxList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)
                            ),
                            margin: EdgeInsets.only(bottom: 15),
                            child: Material(
                              child: InkWell(
                                splashColor: ColourTheme.inkWellBlue,
                                onTap: () {
                                  showDialog(context: context, builder: (context) => TrxPopUpDialog(trxCard: trxList[index], onPressed: () => Navigator.pop(context),));
                                },
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FaIcon(TrxCardModel().getTrxCardStyle(trxList[index], dataType: "Icon"), size: TextFontStyle.listTile_faIconSize, color: ColourTheme.fontBlue,),
                                          SizedBox(width: 15,),
                                          Container(
                                            width: 150,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text( //Title
                                                  '${trxList[index].trxType}: ${TrxCardModel().getTrxCardStyle(trxList[index], dataType: "title")}', 
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextFontStyle.customFontStyle(TextFontStyle.historyPage_listTile_title, fontWeight: FontWeight.w900, color: ColourTheme.fontBlue)
                                                ),
                                                Text( //Desc (Paying/Reloading to )
                                                  '${trxList[index].trxRecipient ?? trxList[index].trxMethod}', 
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextFontStyle.customFontStyle(TextFontStyle.historyPage_listTile_subtitle, fontWeight: FontWeight.w600, color: ColourTheme.fontBlue)
                                                ),
                                                Text( //Desc (Date)
                                                  '${TrxCardModel().getTrxDate(dateTime: trxList[index].trxDateTime)}', 
                                                  style: TextFontStyle.customFontStyle(TextFontStyle.historyPage_listTile_subtitle, fontWeight: FontWeight.w600, color: ColourTheme.fontBlue)
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '${TrxCardModel().getTrxCardStyle(trxList[index], dataType: "priceLabel")}RM${trxList[index].trxAmount.toStringAsFixed(2)}', 
                                        style: TextFontStyle.customFontStyle(TextFontStyle.historyPage_listTile_trailing, fontWeight: FontWeight.w900, color: TrxCardModel().getTrxCardStyle(trxList[index], dataType: "Colour"))
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }

                  
                }
              ),
            ),
    );
  }
}