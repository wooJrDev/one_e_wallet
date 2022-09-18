import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one_e_sample/firebase/database.dart';
import 'package:one_e_sample/models/trx_cardModel.dart';
import 'package:one_e_sample/screen/history/allTrxPage.dart';
import 'package:one_e_sample/screen/history/trxPopUp.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';
import 'package:one_e_sample/shared_objects/shared_appBar.dart';
import 'package:one_e_sample/shared_objects/shared_buttons.dart';

enum SingingCharacter { all, trx }

class TrxPage extends StatefulWidget {
  @override
  _TrxPageState createState() => _TrxPageState();
}
class _TrxPageState extends State<TrxPage> {
  
  List<TrxCardModel> trxList = [];
  List<TrxCardModel> highesttrxList = [];
  String _trxToggleStatus = "All";
  List<String> toggleButtonLst = ['All', 'Reload', 'Expense'];
  String trxViewType_btnName = "Grid View";
  bool trxViewType = true; //* true = Listview, false = Gridview
  bool trxDataExist = true;
  ScrollController _scrollToTopController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourTheme.lightBackground,
      appBar: TitleAppBar(title: 'History',),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: GeneralPositioning.mainPadding),
        height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,  
        // height: 300,   
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: TextFontStyle.customFontStyle(TextFontStyle.sectionTitle, fontWeight: FontWeight.w900, color: ColourTheme.fontBlue),
                ),
                TextButton(
                  child: Text('See All', style: TextStyle(fontSize: TextFontStyle.seeAllButton)),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AllTrxPage(ewalletType: "",))),
                ),
              ],
            ),

            Container(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 200,
              child: SingleChildScrollView(
                child: trxListView(),
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget trxListView() {
    return Container(
      // height: MediaQuery.of(context).size.height - 140,
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
            trxList = snapshot.data!;

            trxDataExist = trxList.isEmpty ? false : true;
            highesttrxList = TrxCardModel().getTrxExpenseLst(trxList);

            print("Current trxlist length: ${trxList.length}");

            switch (_trxToggleStatus) {
              case "Reload" : trxList = TrxCardModel().getTrxReloadLst(trxList);
              break;

              case "Expense" : trxList = TrxCardModel().getTrxExpenseLst(trxList);
              break;
            }

            //Sort based on DateTime descending order
            trxList.sort( (a, b) => TrxCardModel().getDateTimeFormat(dateTime: b.trxDateTime!).compareTo( TrxCardModel().getDateTimeFormat(dateTime: a.trxDateTime!) ) ); 
            highesttrxList.sort( (a, b) => b.trxAmount!.compareTo( a.trxAmount! ) ); 

            return trxDataExist ? Column(
              children: <Widget>[
                CustomBtnRadioButton(
                  buttonLablesLst: toggleButtonLst, 
                  buttonValuesLst: toggleButtonLst, 
                  buttonValue: _trxToggleStatus, 
                  onTap: (value) {
                    setState(() {
                      _trxToggleStatus = value;
                      if (trxList.isNotEmpty) {
                        _scrollToTopController.animateTo(
                          _scrollToTopController.position.minScrollExtent, 
                          duration: Duration( milliseconds: 300 ), 
                          curve: Curves.fastOutSlowIn,
                        );
                      }
                    });
                  },
                ),
                SizedBox(height: 10),
                Visibility(
                  visible: trxList.isEmpty ? false : true,
                  replacement: emptyTrxMessage(title: 'No ${_trxToggleStatus.toLowerCase()} transactions available'),
                  child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    controller: _scrollToTopController,
                    itemCount: trxList.length > 4 ? 4 : trxList.length,
                    // itemCount:trxList.length,
                    itemBuilder: (context, index) {
                      return TrxCard(trxList: trxList, cardIndex: index,);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 15),
                    child: Text(
                      'Highest Payment Transactions',
                      style: TextFontStyle.customFontStyle(TextFontStyle.sectionTitle, fontWeight: FontWeight.w900, color: ColourTheme.fontBlue),
                    ),
                  ),
                ),
                Visibility(
                  visible: highesttrxList.isEmpty ? false : true,
                  replacement: emptyTrxMessage(title: 'No highest payment transactions available'),
                  // height: MediaQuery.of(context).size.height - 440,
                  child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: highesttrxList.length > 4 ? 4 : highesttrxList.length,
                    // itemCount:trxList.length,
                    itemBuilder: (context, index) {
                      return TrxCard(trxList: highesttrxList, cardIndex: index,);
                    },
                  ),
                ),

              ],
            )

            : Container(
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
            ); 
          }
        }
      ),
    );

  }

  Widget emptyTrxMessage({String ?title}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: ColourTheme.fontLightBlue,
      ),
      child: Text('$title', style: TextFontStyle.customFontStyle(16), textAlign: TextAlign.center,),
    );
  }

}

class TrxCard extends StatefulWidget {

  final int ?cardIndex;
  final List<TrxCardModel> ?trxList;

  const TrxCard({Key ?key, this.cardIndex, this.trxList}) : super(key: key);

  @override
  _TrxCardState createState() => _TrxCardState();
}

class _TrxCardState extends State<TrxCard> {
  @override
  Widget build(BuildContext context) {
    return  Card(
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
            showDialog(context: context, builder: (context) => TrxPopUpDialog(trxCard: widget.trxList![widget.cardIndex!], onPressed: () => Navigator.pop(context),),);
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    FaIcon(TrxCardModel().getTrxCardStyle(widget.trxList![widget.cardIndex!], dataType: "Icon"), size: TextFontStyle.listTile_faIconSize, color: ColourTheme.fontBlue,),
                    SizedBox(width: 15,),
                    Container(
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text( //* Title
                            '${widget.trxList![widget.cardIndex!].trxType}: ${TrxCardModel().getTrxCardStyle(widget.trxList![widget.cardIndex!], dataType: "title")}', 
                            overflow: TextOverflow.ellipsis,
                            style: TextFontStyle.customFontStyle(TextFontStyle.historyPage_listTile_title, fontWeight: FontWeight.w900, color: ColourTheme.fontBlue)
                          ),
                          Text( //* Desc (Paying/Reloading to )
                            '${widget.trxList![widget.cardIndex!].trxRecipient ?? widget.trxList![widget.cardIndex!].trxMethod}', 
                            overflow: TextOverflow.ellipsis,
                            style: TextFontStyle.customFontStyle(TextFontStyle.historyPage_listTile_subtitle, fontWeight: FontWeight.w600, color: ColourTheme.fontBlue)
                          ),
                          Text( //* Desc (Date)
                            '${TrxCardModel().getTrxDate(dateTime: widget.trxList![widget.cardIndex!].trxDateTime!)}', 
                            style: TextFontStyle.customFontStyle(TextFontStyle.historyPage_listTile_subtitle, fontWeight: FontWeight.w600, color: ColourTheme.fontBlue)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Text( //* Price
                    '${TrxCardModel().getTrxCardStyle(widget.trxList![widget.cardIndex!], dataType: "priceLabel")}RM${widget.trxList![widget.cardIndex!].trxAmount?.toStringAsFixed(2)}', 
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextFontStyle.customFontStyle(TextFontStyle.historyPage_listTile_trailing, fontWeight: FontWeight.w900, color: TrxCardModel().getTrxCardStyle(widget.trxList![widget.cardIndex!], dataType: "Colour"))
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
