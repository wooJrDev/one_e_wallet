import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one_e_sample/firebase/database.dart';
import 'package:one_e_sample/models/userModel.dart';
import 'package:one_e_sample/screen/e_wallets/uewalletReloadPage.dart';
import 'package:one_e_sample/screen/payment/paymentSelectEwalletPage.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';

class HomeTopCard extends StatefulWidget {
  @override
  _HomeTopCardState createState() => _HomeTopCardState();
}

class _HomeTopCardState extends State<HomeTopCard> {
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: DatabaseService().getUserDetail,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: GeneralPositioning.mainPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: ColourTheme.mainAppColour,
            ),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }else {
          UserModel userDetail = snapshot.data as UserModel;
          return Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: GeneralPositioning.mainPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: ColourTheme.mainAppColour,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 25,
                  child: Text(
                    'Hi, ${userDetail.userName}',
                    style: TextStyle(
                      fontSize: 20,
                      color: ColourTheme.fontWhite,
                      fontWeight: FontWeight.w400,
                    )
                  ),
                ),
                Positioned(
                  top: 55,
                  child: Text(
                    'RM${userDetail.userUeAccBalance?.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 40,
                      color: ColourTheme.fontWhite,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ),
                Positioned(
                  top: 95,
                  child: Text(
                    'Current Balance',
                    style: TextStyle(
                      fontSize: 20,
                      color: ColourTheme.fontWhite,
                      fontWeight: FontWeight.w400,
                    )
                  ),
                ),
                Positioned(
                  top: 130,
                  width: MediaQuery.of(context).size.width - (GeneralPositioning.mainPadding*2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 125,
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.payments_outlined, size: 26,),
                          label: Text( 'Pay', style: TextStyle( fontSize: 22 ) ),
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(15),
                            backgroundColor: MaterialStateProperty.all<Color>(ColourTheme.orange),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                            padding: MaterialStateProperty.all<EdgeInsets>( EdgeInsets.symmetric( vertical: 14 ) ),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>( RoundedRectangleBorder( borderRadius: BorderRadius.circular(15)) ),
                          ),
                          onPressed: () {
                            Navigator.push( 
                              context, 
                              MaterialPageRoute( 
                                builder: (context) => PaymentSelectEwalletPage(),
                              ) 
                            );
                          }, 
                        ),
                      ),
                      SizedBox(
                        width: 125,
                        child: ElevatedButton.icon(
                          icon: FaIcon(FontAwesomeIcons.redoAlt, size: 20,),
                          label: Text( 'Reload', style: TextStyle( fontSize: 22 ) ),
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(15),
                            backgroundColor: MaterialStateProperty.all<Color>(ColourTheme.orange),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                            padding: MaterialStateProperty.all<EdgeInsets>( EdgeInsets.symmetric( vertical: 14 ) ),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>( RoundedRectangleBorder( borderRadius: BorderRadius.circular(15)) ),
                          ),
                          onPressed: () => Navigator.push( context, MaterialPageRoute( builder: (context) => UEWalletReloadPage() ) ), 
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
    
  }
}