import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one_e_sample/firebase/database.dart';
import 'package:one_e_sample/models/ewallets_cardModel.dart';
import 'package:one_e_sample/screen/e_wallets/addEwalletPage.dart';
import 'package:one_e_sample/screen/e_wallets/ewalletDetailPage.dart';
import 'package:one_e_sample/screen/e_wallets/ewalletReloadPage.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';

class EwalletsPage extends StatefulWidget {
  @override
  _EwalletsPageState createState() => _EwalletsPageState();
}

class _EwalletsPageState extends State<EwalletsPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourTheme.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleSpacing: GeneralPositioning.mainPadding,
        title: Text('Your E-wallet Accounts', style: TextFontStyle.customFontStyle(TextFontStyle.appBar_largeTitle, color: ColourTheme.mainAppColour),),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      floatingActionButton: ElevatedButton.icon(
        label: Text(
          'Add E-Wallet',
          style: TextFontStyle.customFontStyle(TextFontStyle.floatingActionButton, fontWeight: FontWeight.w500),
        ),
        icon: FaIcon(FontAwesomeIcons.plus),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(8),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25)
            )
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 20, vertical: 12)
          ),
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddEwalletsPage())).then((value) => setState(() {})),
      ),
      body: StreamBuilder(
        stream: DatabaseService().getEwalletUsers(),
        builder:  (context, snapshot)  {

          if (snapshot.connectionState == ConnectionState.waiting) {
            Future.delayed(Duration(seconds: 3)); //! TODO: Need to remove?
            return Container(
              child: Center (
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (!snapshot.hasData) {
            return Container(
                padding: EdgeInsets.all(GeneralPositioning.mainSmallPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.boxOpen, size: 80, color: ColourTheme.fontBlue,),
                    SizedBox(height: GeneralPositioning.mainSmallPadding,),
                    Text(
                      "It is quiet here... Try adding an \nE-wallet accounts to populate this area",
                      textAlign: TextAlign.center,
                      style: TextFontStyle.customFontStyle(TextFontStyle.ewalletCard_emptyMessage, color: ColourTheme.fontBlue),
                    ),
                  ],
                ),
              );
          }else {

            List<EwalletsCardModel> cardlst = snapshot.data;
            cardlst.sort((a, b) => a.eWalletUserName.compareTo(b.eWalletUserName)); //Sort alphabetically
            print('Ewallet new length: ${cardlst.length}');

            return Visibility(
              visible: cardlst.length == 0 ? false : true,
              replacement: Container(
                padding: EdgeInsets.all(GeneralPositioning.mainSmallPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.boxOpen, size: 80, color: ColourTheme.fontBlue,),
                    SizedBox(height: GeneralPositioning.mainSmallPadding,),
                    Text(
                      "It is quiet here... Try adding an \nE-wallet account to populate this area",
                      textAlign: TextAlign.center,
                      style: TextFontStyle.customFontStyle(TextFontStyle.ewalletCard_emptyMessage, color: ColourTheme.fontBlue),
                    ),
                  ],
                ),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height,
                // padding: EdgeInsets.onlytop: GeneralPositioning.mainSmallPadding),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: cardlst.length,
                        itemBuilder: (context, index) {
                        return Container(
                          height: 220,
                          margin: EdgeInsets.only(bottom: GeneralPositioning.mainPadding, right: GeneralPositioning.mainSmallPadding, left: GeneralPositioning.mainSmallPadding),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: ColourTheme.getEwalletTypeMainColour(cardlst[index]),
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
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: ColourTheme.getEwalletTypeMainColour(cardlst[index]).withBlue(5).withAlpha(200),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => EwalletDetailPage(ewallet: cardlst[index],)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(GeneralPositioning.mainPadding, GeneralPositioning.mainSmallPadding, 20, GeneralPositioning.mainMediumPadding),
                                  child: Stack(
                                    children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${cardlst[index].eWalletType ?? "Fallback EwalletType"}',
                                            style: TextFontStyle.customFontStyle(TextFontStyle.ewalletCard_eWalletType),
                                          ),
                                          PopupMenuButton(
                                            icon: FaIcon(FontAwesomeIcons.ellipsisH, color: ColourTheme.fontWhite,),
                                            padding: EdgeInsets.all(12),
                                            onSelected: (value) {
                                              setState(() {
                                                // print('Print DbEwalletAccountType: ${DatabaseService().getDbEwalletAccType(cardlst[index].eWalletType)}');
                                                DatabaseService().manageEwalletAcc(ewalletType: DatabaseService().getDbEwalletAccType(cardlst[index].eWalletType));
                                              });
                                            },
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                child: Text("Remove E-wallet"),
                                                value: 1,
                                              ),
                                            ]
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Text(
                                        '${cardlst[index].eWalletUserName ?? "Fallback Username"}',
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
                                            'RM${cardlst[index].eWalletBalance.toStringAsFixed(2) ?? "Fallback EwalletBalance"}',
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
                                        backgroundColor: MaterialStateProperty.all( ColourTheme.getEwalletTypeAccentColour(cardlst[index]) ),
                                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 18, vertical: 8)),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(ShapeBorderRadius.roundedeElevatedButton)
                                          )
                                        ),
                                      ),
                                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => IndvEwalletReloadPage(ewalletDetail: cardlst[index],))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 50,),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}