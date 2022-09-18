import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one_e_sample/firebase/database.dart';
import 'package:one_e_sample/models/ewallets_cardModel.dart';
import 'package:one_e_sample/screen/payment/paymentAmountPage.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';
import 'package:one_e_sample/shared_objects/shared_appBar.dart';
import 'package:one_e_sample/shared_objects/shared_buttons.dart';
import 'package:one_e_sample/shared_objects/shared_popUpDialog.dart';
import 'package:one_e_sample/shared_objects/shared_textFormField.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;


class PaymentSelectEwalletPage extends StatefulWidget {

  // GlobalKey<FormState> _ewalletFormKey;


  @override
  _PaymentSelectEwalletPageState createState() => _PaymentSelectEwalletPageState();
}

class _PaymentSelectEwalletPageState extends State<PaymentSelectEwalletPage> {

  List<String> ?ewalletTypes = EwalletsCardModel().ewalletTypeLst;
  List<String> merchantLst = ['Tealive', 'GSC Cinema', 'Snowflake', 'Madam Kwan', "Steven's corner", 'KFC', 'Popular Bookstore'];

  List<EwalletsCardModel> ?ewalletLst;
  EwalletsCardModel ?selectedEwallet;

  final _ewalletFormKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourTheme.lightBackground,
        appBar: BackButtonAppBar(context: context, title: 'E-wallet Selection'),
        body: StreamBuilder<List<EwalletsCardModel>>(
          stream: DatabaseService().getEwalletUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              ewalletLst = snapshot.data!;                
              ewalletTypes = ewalletLst?.map((item) => item.eWalletType).cast<String>().toList();

              return Visibility(
                visible: ewalletLst!.isEmpty ? false : true,
                replacement: Container(
                  padding: EdgeInsets.all(GeneralPositioning.mainSmallPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.boxOpen, size: 80, color: ColourTheme.fontBlue,),
                      SizedBox(height: GeneralPositioning.mainSmallPadding,),
                      Text(
                        "You can't pay without adding any E-wallet account. Please add an E-wallet account first before attempting payment.",
                        textAlign: TextAlign.center,
                        style: TextFontStyle.customFontStyle(TextFontStyle.ewalletCard_emptyMessage, color: ColourTheme.fontBlue),
                      ),
                    ],
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.only(top: GeneralPositioning.mainPadding),
                  margin: EdgeInsets.symmetric(horizontal: GeneralPositioning.mainPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Select E-wallet Payment of Choice',
                        style: TextFontStyle.customFontStyle(TextFontStyle.paymentPage_selectEwalletTitle, color: ColourTheme.fontBlue),
                      ),
                      SizedBox(height: 15),
                      Form(
                        key: _ewalletFormKey,
                        child: DropDownFormField(
                          itemLst: ewalletTypes!, 
                          validate: validateEwalletType, 
                          hintText: 'Select E-wallet',
                          onChanged: (value) => setState( () { selectedEwallet = ewalletLst?.firstWhere((item) => item.eWalletType == value); } ),
                        )
                      ),
                      SizedBox(height: 40),

                      Container(
                        // height: 150,
                        width: double.infinity,
                        child: Column(
                          children: [
                            CustomBtnSquareButton(
                              text: 'Scan QR Code',
                              customWidth: 210,
                              onPressed: () {
                                if (_ewalletFormKey.currentState!.validate()) { scanQrCode(); }
                              },
                            ),

                            SizedBox(height: 20),

                            CustomBtnSquareButton(
                              text: 'Display QR Code',
                              customWidth: 210,
                              onPressed: () async {
                                if (_ewalletFormKey.currentState!.validate()) {  
                                  Uint8List qrcodeResult = await scanner.generateBarCode('EwalletAcount:${selectedEwallet?.eWalletType},Balance:${selectedEwallet?.eWalletBalance}');
                                  showDialog( context: context, builder: (context) => popUpQrCode( onPressed: () => Navigator.pop(context), qrCodeData: qrcodeResult, ewalletType: selectedEwallet?.eWalletType, ));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );

            } else {
              return Center(
                child: Container(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }
        ),
    );
  }

  String validateEwalletType(value) {
    if (selectedEwallet == null) 
      return "Please select an e-wallet from the provided list";
    return null!;
  }

  scanQrCode() async {
    try {
      if (await Permission.camera.request().isGranted) { //Prompts for camera permission and check if access if granted
        String ?scanResult = await scanner.scan(); //Display the qrcode scanner interface
        String ?merchantName = scanResult != null ?scanResult.split("=").last : null;
        // print('Scan Result: $scanResult');
        // print('MerchantName: $merchantName');

        if ( scanResult != null && merchantLst.contains( merchantName ) ) {
          displayPaymentAmountPage(context, ewalletDetail: selectedEwallet!, merchantName: merchantName!);
        } else {
          popUpWarning(context: context, title: 'Invalid Merchant QR Code');
        }
      } else {
        popUpWarning(context: context, title: 'Unable to gain camera permission, please enable it to use the scanning feature');
      }

      } on FormatException catch(e) {
        popUpWarning(context: context, title: 'Invalid Merchant QR Code');
      }
  }

  displayPaymentAmountPage(BuildContext context, {EwalletsCardModel ?ewalletDetail, String ?merchantName}) {
    Navigator.push( 
      context, 
      PageTransition( 
        type: PageTransitionType.rightToLeftWithFade, 
        duration: Duration( milliseconds: 250 ),
        child: PaymentAmountPage( 
          ewalletDetail: ewalletDetail, 
          merchantName: merchantName,)
      )
    );
  }

}