import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:one_e_sample/firebase/database.dart';
import 'package:one_e_sample/models/ewallets_cardModel.dart';
import 'package:one_e_sample/models/userModel.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';
import 'package:one_e_sample/shared_objects/shared_appBar.dart';
import 'package:one_e_sample/shared_objects/shared_appBehaviour.dart';
import 'package:one_e_sample/shared_objects/shared_buttons.dart';
import 'package:one_e_sample/shared_objects/shared_popUpDialog.dart';

class IndvEwalletReloadPage extends StatefulWidget {
  @override
  _IndvEwalletReloadPageState createState() => _IndvEwalletReloadPageState();
    final EwalletsCardModel ewalletDetail;

    IndvEwalletReloadPage({required this.ewalletDetail});
}

class _IndvEwalletReloadPageState extends State<IndvEwalletReloadPage> {

  // dynamic regexTranslator = {
  //   '#':  RegExp(r'^\d+\.?\d{0,2}')
  // };
  var maskController = new MaskedTextController(mask: '00.00', text: '00.00'); //! Useful for putting in specific values
  var txtController = TextEditingController();
  String _reloadAmount = "";
  String _reloadErrorMsg = "";
  late UserModel userDetail;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => removeFocus(),
      child: Scaffold(
        backgroundColor: ColourTheme.lightBackground,
        appBar: BackButtonAppBar(context: context, title: 'Reload ${widget.ewalletDetail.eWalletType} E-wallet'),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                reloadEwalletForm(),
                Padding(
                  padding: const EdgeInsets.only(left: GeneralPositioning.mainPadding, top: GeneralPositioning.mainMediumPadding, bottom: 10),
                  child: Text(
                    'Quick Reload Options',
                    style: TextFontStyle.customFontStyle(TextFontStyle.ewalletReloadPage_quickReloadTitle,  fontWeight: FontWeight.w900, color: ColourTheme.fontBlue),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    reloadOptionButton(reloadAmountInput: "20"),
                    reloadOptionButton(reloadAmountInput: "50"),
                    reloadOptionButton(reloadAmountInput: "100"),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 50),
                  alignment: Alignment.center,
                  child: CustomBtnSlideButton(
                    width: 250,
                    isFullWidth: true,
                    text: 'Slide to Confirm Payment',
                    onSlide: () async{
                      removeFocus();
                      if ( reloadAmountValidation( userDetail.userUeAccBalance!, double.parse( _reloadAmount.isEmpty ? 0.toStringAsFixed(0) : _reloadAmount ) ) ) {
                        bool updateStatus = await DatabaseService().performReloadEwalletTrx(reloadedAmount: double.parse(_reloadAmount), ewalletDetail: widget.ewalletDetail);
                        if (updateStatus) {
                          popUpCustomSuccess(
                            context: context, 
                            title: '\nSuccessfully Reloaded ${widget.ewalletDetail.eWalletType} \nE-wallet',
                            dismissAction: (type) => Navigator.pop(context),
                          );
                        }
                        else {
                          popUpFailed(
                            context: context, 
                            title: '\nReload Transaction Failed, Please Try Again',
                            dismissAction: (type) => setState( () { txtController.value = TextEditingValue.empty; } ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget reloadEwalletForm() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ShapeBorderRadius.roundedEwalletReloadCard),
        color: ColourTheme.mainAppColour,
      ),
      margin: EdgeInsets.only(top: GeneralPositioning.mainPadding),
      padding: EdgeInsets.fromLTRB(GeneralPositioning.mainPadding, GeneralPositioning.mainPadding, GeneralPositioning.mainMediumPadding, GeneralPositioning.mainPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'E-wallet: ${widget.ewalletDetail.eWalletType}',
            style: TextFontStyle.customFontStyle(TextFontStyle.ewalletReloadPage_title),
          ),
          SizedBox(height: GeneralPositioning.ewalletReloadPage_spaceBetween_title),
          StreamBuilder(
            stream: DatabaseService().getUserDetail,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                userDetail = snapshot.data as UserModel;
                return Text(
                  'RM${userDetail.userUeAccBalance?.toStringAsFixed(2)}',
                  style: TextFontStyle.customFontStyle(TextFontStyle.ewalletReloadPage_title),
                );
              }
            }
          ),
          Text(
            'Current UE-wallet Balance',
            style: TextFontStyle.customFontStyle(TextFontStyle.ewalletReloadPage_ewalletDesc, fontWeight: FontWeight.normal),
          ),
          SizedBox(height: GeneralPositioning.ewalletReloadPage_spaceBetween_title),
          Text(
            'RM${widget.ewalletDetail.eWalletBalance?.toStringAsFixed(2)}',
            style: TextFontStyle.customFontStyle(TextFontStyle.ewalletReloadPage_title),
          ),
          Text(
            'Current ${widget.ewalletDetail.eWalletType} Balance',
            style: TextFontStyle.customFontStyle(TextFontStyle.ewalletReloadPage_ewalletDesc, fontWeight: FontWeight.normal),
          ),
          SizedBox(height: GeneralPositioning.ewalletReloadPage_spaceBetween_title),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Reload Amount:',
                style: TextFontStyle.customFontStyle(TextFontStyle.ewalletReloadPage_ewalletDesc),
              ),
              Container(
                width: 160,
                child: TextFormField(
                  controller: txtController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    // FilteringTextInputFormatter.allow( RegExp(r'^\d+\.?\d{0,2}') ), //* This works fine (Allows for 2 decimal place)
                    // FilteringTextInputFormatter.allow( RegExp('^[0-9]{0,6}(\\.[0-9]{0,2})?\$') ),
                  ],
                  keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                  style: TextFontStyle.customFontStyle(TextFontStyle.ewalletReloadPage_ewalletReloadAmount, color: ColourTheme.fontBlue),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
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
                  onChanged: (value) => setState(() => _reloadAmount = value),
                ),
              ),
            ],
          ),
          Visibility(
            visible: _reloadErrorMsg == "" ? false : true,
            child: Container(
              margin: EdgeInsets.only(top: GeneralPositioning.ewalletReloadPage_spaceBetween_title), 
              child: Text(
                '$_reloadErrorMsg', 
                style: TextFontStyle.customFontStyle(TextFontStyle.ewalletReloadPage_errorMessage, color: ColourTheme.fontRed),
              )
            ),
          ),
        ],
      ),
    );
  }

  Widget reloadOptionButton({required String reloadAmountInput}) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: GeneralPositioning.ewalletReloadPage_quickReloadButton_horzPadding, vertical: GeneralPositioning.ewalletReloadPage_quickReloadButton_vertPadding)
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ShapeBorderRadius.boxElevatedButton)
          ),
        ),
        backgroundColor: MaterialStateProperty.all(ColourTheme.mainAppColour),
      ),
      child: Text('RM$reloadAmountInput', style: TextFontStyle.customFontStyle(TextFontStyle.ewalletReloadPage_quickReloadOptionButton)),
      onPressed: () {
        _reloadAmount = reloadAmountInput;
        txtController.value = TextEditingValue(
          text: _reloadAmount,
          selection: TextSelection.fromPosition( TextPosition( offset: _reloadAmount.length ) ),
        );
      },
    );
  }

  bool reloadAmountValidation(double uewalletBalance, double reloadAmountInput) {
    if (reloadAmountInput > 9000) {
      setState(() {
        _reloadErrorMsg = "Reload Amount cannot be more than RM9000";
      });
      return false;
    } else if (reloadAmountInput > uewalletBalance) {
      setState(() {
        _reloadErrorMsg = "Reload Amount cannot be more than current UE-wallet balance";
      });
      return false;
    } else if (reloadAmountInput == 0) {
      setState(() {
        _reloadErrorMsg = "Reload Amount cannot be empty";
      });
      return false;
    }
    setState(() {
        _reloadErrorMsg = "";
      });
    return true;
  }

}