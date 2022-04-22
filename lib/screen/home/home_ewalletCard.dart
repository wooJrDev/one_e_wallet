import 'package:flutter/material.dart';
import 'package:one_e_sample/models/ewallets_cardModel.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';
import 'package:provider/provider.dart';

class HomeEwalletCard extends StatefulWidget {
  const HomeEwalletCard({ Key key, }) : super(key: key);

  @override
  _HomeEwalletCardState createState() => _HomeEwalletCardState();
}

class _HomeEwalletCardState extends State<HomeEwalletCard> {
  @override
  Widget build(BuildContext context) {

    final ewalletList = Provider.of<List<EwalletsCardModel>>(context) ?? [];
    print('ewallet length: ${ewalletList.length}');
    return Visibility(
      visible: ewalletList.length == 0 ? false : true,
      replacement: Container(
        margin: EdgeInsets.symmetric(horizontal: GeneralPositioning.mainPadding),
        padding: EdgeInsets.symmetric(horizontal: GeneralPositioning.mainPadding, vertical: GeneralPositioning.mainPadding),
        decoration: BoxDecoration(
          color: Colors.orange[100],
          borderRadius: BorderRadius.circular(15)
        ),
        child: Text(
          'Looks like you have not added any E-wallets yet. Add one now and it\'ll show up here.',
          textAlign: TextAlign.center,
          style: TextFontStyle.customFontStyle(TextFontStyle.homePage_ewalletCard_emptyMessage, color: ColourTheme.fontBlue),
        ),
      ),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: GeneralPositioning.mainPadding),
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: ewalletList.length,
        itemBuilder: (context, index) {
          return Container(
            width: 300,
            padding: EdgeInsets.all(25),
            margin: EdgeInsets.only(right: 30, left: ewalletList.length == 1 ? 15: 0),
            decoration: BoxDecoration(
              color: ColourTheme.getEwalletTypeMainColour(ewalletList[index]),
              borderRadius: BorderRadius.circular(ShapeBorderRadius.homeCardRadius),
            ),
            child: Stack(
              children: <Widget>[
                Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 175,
                    child: Text( //* Account Holder Name
                      ewalletList[index].eWalletUserName ?? 'Fallback name',
                      style: TextFontStyle.customFontStyle(TextFontStyle.homePage_ewalletCard_AccountName),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // SizedBox(height: 20),
                  Text(
                    'Account Holder',
                    style: TextFontStyle.customFontStyle(TextFontStyle.homePage_ewalletCard_AccountName_title, fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  Text(
                    'RM${ewalletList[index].eWalletBalance.toStringAsFixed(2) ?? "Fallback Balance"}',
                    style: TextFontStyle.customFontStyle(TextFontStyle.homePage_ewalletCard_balance),
                  ),
                  Text(
                    'Availble Balance',
                    style: TextFontStyle.customFontStyle(TextFontStyle.homePage_ewalletCard_balance_title, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  '${ewalletList[index].eWalletType ?? "Fallback E-walletType"}',
                  style: TextFontStyle.customFontStyle(TextFontStyle.homePage_ewalletCard_eWalletType),
                ),
              ),
              ]
            ),
          );
        },
          
          
          
          //* Using row and columns
            //Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             SizedBox(
            //               width: 175,
            //               child: Text(
            //                 'Leong Shin Ni Eli Teg',
            //                 style: TextStyle(
            //                   fontSize: TextFontStyle.ewalletCard_AccountName,
            //                   fontWeight: FontWeight.bold,
            //                   color: ColourTheme.fontWhite
            //                 ),
            //                 overflow: TextOverflow.ellipsis,
            //               ),
            //             ),
            //             // SizedBox(height: 20),
            //             Text(
            //               'Account Holder',
            //               style: TextStyle(
            //                 fontSize: TextFontStyle.ewalletCard_AccountName_title,
            //                 fontWeight: FontWeight.w500,
            //                 color: ColourTheme.fontWhite
            //               )
            //             ),
            //           ],
            //         ),
            //         Text(
            //           'Boost',
            //           style: TextStyle(
            //             fontSize: TextFontStyle.ewalletCard_EWalletName,
            //             fontWeight: FontWeight.bold,
            //             color: ColourTheme.fontWhite
            //           ),
            //         ),
            //       ],
            //     ),
            //     Spacer(),
            //     Text(
            //       'RM450.00',
            //       style: TextStyle(
            //         fontSize: TextFontStyle.ewalletCard_balance,
            //         fontWeight: FontWeight.bold,
            //         color: ColourTheme.fontWhite
            //       )
            //     ),
            //     Text(
            //       'Availble Balance',
            //       style: TextStyle(
            //         fontSize: TextFontStyle.ewalletCard_AccountName_title,
            //         fontWeight: FontWeight.w500,
            //         color: ColourTheme.fontWhite
            //       )
            //     ),
            //   ],
            // ),
      ),
    );
  }
}