import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one_e_sample/firebase/database.dart';
import 'package:one_e_sample/models/ewallets_cardModel.dart';
import 'package:one_e_sample/models/trx_cardModel.dart';
import 'package:one_e_sample/screen/e_wallets/ewalletReloadPage.dart';
import 'package:one_e_sample/screen/history/allTrxPage.dart';
import 'package:one_e_sample/screen/history/trxPopUp.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';
import 'package:one_e_sample/shared_objects/shared_appBar.dart';
import 'package:one_e_sample/shared_objects/shared_buttons.dart';

class EwalletDetailPage extends StatefulWidget {

  final EwalletsCardModel ewallet;

  EwalletDetailPage({@required this.ewallet});

  @override
  _EwalletDetailPageState createState() => _EwalletDetailPageState();
}

class _EwalletDetailPageState extends State<EwalletDetailPage> {

  List<TrxCardModel> trxList = [];
  List<String> toggleButtonLst = ['All', 'Reload', 'Expense'];
  String trxToggleStatus = "All";
  double _ewalletCardHeight = 220;
  ScrollController _scrollToTopController = ScrollController();
  List<EwalletsCardModel> ewalletDetail;
  double updatedEwalletBalance;

  @override
  Widget build(BuildContext context) {

    // trxList.forEach((lst) {
    //   print('indv lst: ${lst.trxAmount}');
    // });

    return Scaffold(
      backgroundColor: ColourTheme.lightBackground,
      appBar: backButtonAppBar(context: context, title: '${widget.ewallet.eWalletType} E-wallet'),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.fromLTRB(GeneralPositioning.mainSmallPadding, GeneralPositioning.mainSmallPadding, GeneralPositioning.mainSmallPadding, GeneralPositioning.mainPadding),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            StreamBuilder(
              stream: DatabaseService().getEwalletUsers(isSpecificUserId: true, ewalletUserId: [widget.ewallet.eWalletUserId]),
              builder: (context, snapshot) {
                
                if (snapshot.hasData) {
                  ewalletDetail = snapshot.data;
                }

                return Container(
                  height: _ewalletCardHeight,
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: GeneralPositioning.mainPadding),
                  decoration: BoxDecoration(
                    color: ColourTheme.getEwalletTypeMainColour(widget.ewallet),
                    borderRadius: BorderRadius.circular(ShapeBorderRadius.homeCardRadius),
                    boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 4.0,
                            spreadRadius: 0.0,
                            offset: Offset(2.0, 2.0), // shadow direction: bottom right
                        )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(GeneralPositioning.mainPadding, GeneralPositioning.mainSmallPadding, 20, GeneralPositioning.mainMediumPadding),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${widget.ewallet.eWalletType ?? "Fallback EwalletType"}',
                              style: TextFontStyle.customFontStyle(TextFontStyle.ewalletCard_eWalletType),
                            ),
                            Spacer(),
                            Text(
                              '${widget.ewallet.eWalletUserName ?? "Fallback Username"}',
                              style: TextFontStyle.customFontStyle(TextFontStyle.ewalletCard_AccountName),
                            ),
                            Text(
                              'Account Holder',
                              style: TextFontStyle.customFontStyle(TextFontStyle.ewalletCard_AccountName_title, fontWeight: FontWeight.w500),
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'RM${ewalletDetail[0].eWalletBalance.toStringAsFixed(2)  ?? "widget.ewallet.eWalletBalance.toStringAsFixed(2)"}',
                                  style: TextFontStyle.customFontStyle(TextFontStyle.ewalletCard_balance),
                                ),
                                Text(
                                  'Available Balance',
                                  style: TextFontStyle.customFontStyle(TextFontStyle.ewalletCard_balance_title, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            child: Text(
                              'Reload',
                              style: TextFontStyle.customFontStyle(TextFontStyle.ewalletCard_reloadButton),
                            ),
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(8),
                              backgroundColor: MaterialStateProperty.all(ColourTheme.getEwalletTypeAccentColour(widget.ewallet)),
                              padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 18, vertical: 8)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(ShapeBorderRadius.roundedeElevatedButton)
                                )
                              ),
                            ),
                            onPressed: () => Navigator.push(context, MaterialPageRoute( builder: (context) => IndvEwalletReloadPage( ewalletDetail: ewalletDetail[0] ) ) )
                              .then((value) {setState(() {});}),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                // color: Colors.red[200],
                // height: MediaQuery.of(context).size.height - _ewalletCardHeight - 200,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Transactions',
                          style: TextFontStyle.customFontStyle(TextFontStyle.sectionTitle, fontWeight: FontWeight.w900, color: ColourTheme.fontBlue),
                        ),
                        TextButton(
                          child: Text('See All', style: TextStyle(fontSize: TextFontStyle.seeAllButton)),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AllTrxPage(ewalletType: widget.ewallet.eWalletType,))),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    CustomBtnRadioButton(
                      buttonLablesLst: toggleButtonLst, 
                      buttonValuesLst: toggleButtonLst,
                      buttonValue: trxToggleStatus,
                      onTap: (value) => setState( () { 
                        trxToggleStatus = value;
                        if (trxList.isNotEmpty) {
                          _scrollToTopController.animateTo(
                            _scrollToTopController.position.minScrollExtent,
                            duration: Duration( milliseconds: 300 ),
                            curve: Curves.fastOutSlowIn,
                          );
                        }
                      } ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
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
                          }else {

                            trxList  = snapshot.data;

                            switch (trxToggleStatus) {
                              case "Reload" : trxList = TrxCardModel().getTrxReloadLst(trxList);
                              break;

                              case "Expense" : trxList = TrxCardModel().getTrxExpenseLst(trxList);
                              break;
                            }
                          
                          trxList = trxList.where((indvTrx) => indvTrx.trxMethod == widget.ewallet.eWalletType || indvTrx.trxRecipient == widget.ewallet.eWalletType).toList();
                          //Sort based on DateTime descending order
                          trxList.sort( (a, b) => TrxCardModel().getDateTimeFormat(dateTime: b.trxDateTime).compareTo( TrxCardModel().getDateTimeFormat(dateTime: a.trxDateTime) ) );
                          

                            return Visibility(
                              visible: trxList.isEmpty ? false: true,
                              replacement: Container(
                                padding: EdgeInsets.all(GeneralPositioning.mainPadding),
                                child: Column(
                                  children: [
                                    Image(image: AssetImage("assets/icons/empty_box128.png"), height: 95,),
                                    SizedBox(height: 10),
                                    Text(
                                      'Looks like there are no recent transactions to be displayed...',
                                      textAlign: TextAlign.center,
                                      style: TextFontStyle.customFontStyle(TextFontStyle.ewalletDetailPage_emptyTrxMsg, color: ColourTheme.fontBlue),
                                    ),
                                  ],
                                ),
                              ),
                              child: ListView.builder(
                                controller: _scrollToTopController,
                                itemCount: trxList.length > 4 ? 4 : trxList.length,
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
                                          showDialog(context: context, builder: (context) => TrxPopUpDialog(trxCard: trxList[index], onPressed: () => Navigator.pop(context), ));
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}