import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:credit_card_validator/validation_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one_e_sample/firebase/database.dart';
import 'package:one_e_sample/models/userModel.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';
import 'package:one_e_sample/shared_objects/shared_appBar.dart';
import 'package:one_e_sample/shared_objects/shared_appBehaviour.dart';
import 'package:one_e_sample/shared_objects/shared_popUpDialog.dart';
import 'package:one_e_sample/shared_objects/shared_textFormField.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class UEWalletReloadPage extends StatefulWidget {
  @override
  _UEWalletReloadPageState createState() => _UEWalletReloadPageState();
}

class _UEWalletReloadPageState extends State<UEWalletReloadPage> with TickerProviderStateMixin {
  // RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  RegExp pinCodeRegex = RegExp(r'^[a-zA-Z0-9]+$');
  var maskCardNumber = new MaskedTextController(mask: '0000 0000 0000 0000');
  var maskCardValid = new MaskedTextController(mask: '00/00');
  var maskCardCvv = new MaskedTextController(mask: '000');
  var reloadAmountControl = TextEditingController();
  var pinReloadNumControl = TextEditingController();
  // var cardNumControl = TextEditingController();
  var cardNameControl = TextEditingController();
  var cardValidControl = TextEditingController();
  // var cardCvvControl = TextEditingController();
  TabController tabController;
  CreditCardValidator ccValidator = CreditCardValidator();

  final _cardPaymentFormKey = GlobalKey<FormState>();
  final _bankPaymentFormKey = GlobalKey<FormState>();
  final _pinPaymentFormKey = GlobalKey<FormState>();

  //List of available banks
  List<String> bankTypesLst = ['RHB Bank', 'Maybank', 'Public Bank', 'CIMB Bank', 'Hong Leong Bank'];

  //Reload Amount
  String _reloadAmount;
  String _reloadErrorMsg = "";
  ///Payment Details
  //Credit/Debit card payment detail
  // String cardNumber;
  // String cardName;
  String cardType;
  dynamic cardTypeIcon;
  // String cardValid;
  // String cardCvv;
  //FPX payment detail
  String bankName;
  //Pin payment detail
  // String reloadPinNum;
  UserModel userDetail;
  

  var cardNumber;
  CCNumValidationResults  cardNumberResult;
  

  int _activePaymentMethodBtn = 0; //Highlight default paymentMethod active button

  double _paymentMethodTabMinheight = 86*3.0;
  double _paymentMethodTabMaxHeight = 108*3.0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bankTypesLst.sort(); //Arrange the list in assending order
    return GestureDetector(
      onTap: () => removeFocus(),
      child: Scaffold(
        backgroundColor: ColourTheme.lightBackground,
        appBar: backButtonAppBar(context: context, title: 'Reload UE-wallet'),
        body: ListView(
          children: <Widget>[
            reloadEwalletForm(),
            reloadOptionTitle(title: "Quick Reload Option"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                reloadOptionButton(reloadAmountInput: "20"),
                reloadOptionButton(reloadAmountInput: "50"),
                reloadOptionButton(reloadAmountInput: "100"),
              ],
            ),
            reloadOptionTitle(title: "Payment Method"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                paymentMethodButton(title: 'CARD', tabIndex: 0, maxHeight: 108*3.0, minHeight: 86*3.0, resetForm: _cardPaymentFormKey),
                paymentMethodButton(title: 'FPX', tabIndex: 1, maxHeight: 110, minHeight: 86, resetForm: _bankPaymentFormKey),
                paymentMethodButton(title: 'PIN', tabIndex: 2, maxHeight: 110, minHeight: 86, resetForm: _pinPaymentFormKey),
              ],
            ),
            SizedBox(height: 20,),
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: _paymentMethodTabMinheight,
                // maxHeight: _paymentMethodTabMaxHeight,
              ),
              child: Container(
                height: _paymentMethodTabMaxHeight,
                // color: Colors.greenAccent[200],
                padding: EdgeInsets.symmetric(horizontal: GeneralPositioning.mainPadding),
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: [
                    cardPaymentForm(),
                    fpxPaymentForm(),
                    pinPaymentForm(),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: GeneralPositioning.mainPadding, right: GeneralPositioning.mainPadding, bottom: 20),
              child: ConfirmationSlider(
                height: 60,
                width: 332,
                text: 'Slide to Confirm Payment',
                textStyle: TextFontStyle.customFontStyle(TextFontStyle.uewalletReloadPage_slideToConfirmBtn, color: ColourTheme.fontLightGrey),
                onConfirmation: () async {
                  removeFocus();
                  String paymentMethod;
                  bool _validateReloadDetail = false;
                  switch (_activePaymentMethodBtn) {
                    case 0: {
                      if (_cardPaymentFormKey.currentState.validate()) {
                        var trimCCNum = maskCardNumber.text.replaceAll(new RegExp(r"\s+"), ""); //? TODO: Is this needed?
                        if (cardNumberResult.ccType.toString().split(".").last == "visa") {
                          paymentMethod = "Visa";
                        }
                        else if (cardNumberResult.ccType.toString().split(".").last == "mastercard") {
                          paymentMethod = "MasterCard";
                        }
                        paymentMethod = paymentMethod + " ${maskCardNumber.text.split(" ").last}";
                        _validateReloadDetail = true;
                      }
                    }
                    break;
                    
                    case 1: {
                      if (_bankPaymentFormKey.currentState.validate()) {
                        paymentMethod = "FPX $bankName";
                        _validateReloadDetail = true;
                      }
                    }
                    break;

                    case 2: {
                      if (_pinPaymentFormKey.currentState.validate()) {
                        paymentMethod = "PIN ${pinReloadNumControl.text}";
                        _validateReloadDetail = true;
                      }
                    }
                    break;
                  }

                  if (_validateReloadDetail && reloadAmountValidation(userDetail.userUeAccBalance, double.parse(_reloadAmount ?? 0.toStringAsFixed(0))) ) {
                    print('Reload UE-wallet payment method: $paymentMethod');
                    //* Perform reload action
                    bool updateResult = await DatabaseService().performReloadUEwalletTrx(reloadedAmount: double.parse(_reloadAmount), paymentMethod: paymentMethod);
                    if (updateResult)
                      popUpCustomSuccess(context: context, title: "Successfully reloaded UE-wallet", dismissAction: () => Navigator.pop(context) );
                    else 
                      popUpFailed(
                        context: context, 
                        title: "Failed to reload UE-wallet", 
                        dismissAction: () { 
                          setState(() {
                            resetValue();
                            reloadAmountControl.value = TextEditingValue.empty;
                          }); 
                        } 
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool reloadAmountValidation(double uewalletBalance, double reloadAmountInput) {
    if (reloadAmountInput > 1000) {
      setState(() {
        _reloadErrorMsg = "Reload amount cannot exceed RM1000";
      });
      return false;
    } else if (reloadAmountInput == 0) {
      setState(() {
        _reloadErrorMsg = "Reload amount cannot be empty";
      });
      return false;
    }
    setState(() {
        _reloadErrorMsg = "";
      });
    return true;
  }

  String trimSpaceWithin(String inputText) {
    return inputText.replaceAll(RegExp(r"\s+"), "");
  }
  
  cardNumberOnChanged(value) {
    cardNumber = trimSpaceWithin(maskCardNumber.text);
    cardNumberResult = ccValidator.validateCCNum(cardNumber);

    if (cardNumberResult.ccType.toString().split(".").last == "visa" && cardNumber.length >= 4) {
      setState(() {
        cardTypeIcon = FontAwesomeIcons.ccVisa;
      });
    }
    else if (cardNumberResult.ccType.toString().split(".").last == "mastercard" && cardNumber.length >= 4) {
      setState(() {
        cardTypeIcon = FontAwesomeIcons.ccMastercard;
      });
    }
    else if (cardNumberResult.ccType.toString().split(".").last == "unknown") {
      setState(() {
        cardTypeIcon = null;
      });
    }
  }

  String validateCardNumber(value) {
    if (cardNumberResult == null) {
      cardNumber = trimSpaceWithin(maskCardNumber.text);
      cardNumberResult = ccValidator.validateCCNum(cardNumber);
    }  
    print('Card num length: ${cardNumber.length}');
    print('Card num valid: ${cardNumberResult.isValid}');
    print('Card type: ${cardNumberResult.ccType}');
    if (!cardNumberResult.isPotentiallyValid)
      return cardNumberResult.message;
    else if ( !(cardNumberResult.ccType.toString().split(".").last == "visa" || cardNumberResult.ccType.toString().split(".").last == "mastercard") )
      return "Only Visa and Mastercard are accepted";
    else if (!cardNumberResult.isValid && cardNumber.length < 16)
      return "Invalid credit/debit card number length";

    return null;
  }

  String validateCardName(value) {
    var regexNameWithSpace = RegExp("^[a-zA-Z ]*\$");
    if (cardNameControl.text.isEmpty)
      return "Card holder name cannot be empty";
    else if ( !regexNameWithSpace.hasMatch (cardNameControl.text ) )
      return "Card holder name can only contain alphabets";
    else if (cardNameControl.text.length > 21)
      return "Name must not exceed 21 characters";
    return null;
  }

  String validateCardValid(value) {
    ValidationResults cardValid = ccValidator.validateExpDate(value);
    if (!cardValid.isPotentiallyValid) {
      return cardValid.message ?? 'Card has expired';
    }
    else if (!cardValid.isValid) {
      return cardValid.message;
    }
    return null;
    // cardValid.message
    // if ()
  }

  String validateCardCvv(value) {
    if (maskCardCvv.text.isEmpty)
      return "CVV cannot be empty";
    else if (maskCardCvv.text.length < 3)
      return 'CVV must be 3 digits long';
    return null;
  }

  String validateBankName(value) {
    if (bankName == null) 
      return "Please select a bank from the provided list";
    return null;
  }

  String validatePinNum(value) {
    if (pinReloadNumControl.text.isEmpty)
      return "Pin code cannot be empty";
    else if (!pinCodeRegex.hasMatch(value))
      return 'Pin code must be alphanumeric only without space or special characters';
    else if (pinReloadNumControl.text.length < 6 || pinReloadNumControl.text.length > 10 )
      return "Pin code must be within 6 to 10 characters";
    return null;
  }

  setCardTypeIcon() => cardTypeIcon == null ? FaIcon(FontAwesomeIcons.accessibleIcon, color: Colors.transparent,) : FaIcon(cardTypeIcon);

  Widget reloadOptionTitle({@required String title}) {
    return Padding(
      padding: const EdgeInsets.only(left: GeneralPositioning.mainPadding, top: GeneralPositioning.mainMediumPadding, bottom: 10),
      child: Text(
        '$title',
        style: TextFontStyle.customFontStyle(TextFontStyle.ewalletReloadPage_quickReloadTitle,  fontWeight: FontWeight.w900, color: ColourTheme.fontBlue),
      ),
    );
  }

  resetValue() { //! TODO: Clear current payment form errors when switching to different payment form
    maskCardNumber.value = TextEditingValue.empty;
    maskCardValid.value = TextEditingValue.empty;
    maskCardCvv.value = TextEditingValue.empty;
    cardNameControl.value = TextEditingValue.empty;
    bankName = null;
    pinReloadNumControl.value = TextEditingValue.empty;
  }

  Widget reloadEwalletForm() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ShapeBorderRadius.roundedEwalletReloadCard_medium),
        color: ColourTheme.mainAppColour,
      ),
      margin: EdgeInsets.only(top: GeneralPositioning.mainPadding),
      padding: EdgeInsets.fromLTRB(GeneralPositioning.mainPadding, GeneralPositioning.mainPadding, GeneralPositioning.mainMediumPadding, GeneralPositioning.mainPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'UE-Wallet',
            style: TextFontStyle.customFontStyle(TextFontStyle.ewalletReloadPage_title),
          ),
          SizedBox(height: GeneralPositioning.ewalletReloadPage_spaceBetween_title),
          StreamBuilder(
            stream: DatabaseService().getUserDetail,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                userDetail = snapshot.data;
                return Text(
                  'RM${userDetail.userUeAccBalance.toStringAsFixed(2)}',
                  style: TextFontStyle.customFontStyle(TextFontStyle.ewalletReloadPage_title),
                );
              }
            }
          ),
          Text(
            'Current Balance',
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
                  controller: reloadAmountControl,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly,],
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

  Widget reloadOptionButton({@required String reloadAmountInput}) {
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
        reloadAmountControl.value = TextEditingValue(
          text: _reloadAmount,
          selection: TextSelection.fromPosition( TextPosition( offset: _reloadAmount.length ) ),
        );
      },
    );
  }

  Widget paymentMethodButton({@required String title, @required int tabIndex, double maxHeight, double minHeight, GlobalKey<FormState> resetForm}) {
    return SizedBox(
      width: 100,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: GeneralPositioning.ewalletReloadPage_quickReloadButton_horzPadding, vertical: GeneralPositioning.ewalletReloadPage_quickReloadButton_vertPadding)
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ShapeBorderRadius.boxElevatedButton)
            ),
          ),
          backgroundColor: MaterialStateProperty.all( _activePaymentMethodBtn == tabIndex ? ColourTheme.fontRed : ColourTheme.mainAppColour ),
        ),
        child: Text('$title', style: TextFontStyle.customFontStyle(TextFontStyle.ewalletReloadPage_quickReloadOptionButton)),
        onPressed: () async {
          tabController.animateTo( ( tabController.index = tabIndex ) );
          FocusScope.of(context).unfocus();
          setState( () {
            print('current index: $tabIndex, active button: $_activePaymentMethodBtn');
          _activePaymentMethodBtn = tabIndex;
          print('NEW current index: $tabIndex, active button: $_activePaymentMethodBtn');
          _paymentMethodTabMinheight = minHeight;
          _paymentMethodTabMaxHeight = maxHeight;
          resetValue();
          // resetForm.currentState.reset(); //* this approach does not work (causes issue: will make clicking the payment button have a delayed effect where the active colour won't be registered but the form switches)
        } );
        } 
      ),
    );
  }

  Widget cardPaymentForm() {
    return Container(
      child: Form(
        key: _cardPaymentFormKey, //Credit/Debit Form
        child: Wrap(
          spacing: 50,
          children: <Widget>[
            reloadEwalletTextFormField(hintText: "Credit/Debit Card Number", controller: maskCardNumber, keyboardType: TextInputType.number, surfixIcon: setCardTypeIcon(), validation: validateCardNumber, validationMode: AutovalidateMode.onUserInteraction, onChanged: cardNumberOnChanged),
            reloadEwalletTextFormField(hintText: "Card Holder Name", controller: cardNameControl, validation: validateCardName, validationMode: AutovalidateMode.onUserInteraction),
            SizedBox(width: 160, child: reloadEwalletTextFormField( hintText: "Valid Until", textAlign: TextAlign.center, controller: maskCardValid, keyboardType: TextInputType.datetime, validation: validateCardValid, validationMode: AutovalidateMode.onUserInteraction) ),
            SizedBox(width: 120, child: reloadEwalletTextFormField( hintText: "CVV", textAlign: TextAlign.center, controller: maskCardCvv, keyboardType: TextInputType.number, validation: validateCardCvv, validationMode: AutovalidateMode.onUserInteraction) ),
          ],
        ),
      ),
    );
  }

  Widget fpxPaymentForm() {
    return Container(
      child: Form(
        key: _bankPaymentFormKey,
        child: bankTypeDropDownFormField(validate: validateBankName),
      ),
    );
  }

  Widget pinPaymentForm() {
    return Container(
      child: Form(
        key: _pinPaymentFormKey,
        child: reloadEwalletTextFormField(hintText: "Pin Code", controller: pinReloadNumControl, validation: validatePinNum)
      ),
    );
  }

  Widget reloadEwalletTextFormField({String hintText, Function validation, Function onChanged, TextAlign textAlign, TextEditingController controller, TextInputType keyboardType, AutovalidateMode validationMode, FaIcon surfixIcon}) {
    return Container(
      // height: ,
      color: Colors.transparent,
      margin: EdgeInsets.only(bottom: GeneralPositioning.mainSmallPadding),
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          fontSize: TextFormValues.textFormFont,
        ),
        textAlign: textAlign ?? TextAlign.left,
        decoration: reloadPaymentInputDecoration(hintText: hintText, surfixIcon: surfixIcon),
        keyboardType: keyboardType,
        autovalidateMode: validationMode,
        onChanged: onChanged,
        validator: validation
      ),
    );
  }

  Widget bankTypeDropDownFormField({Function validate}) {
    return Container(
      margin: EdgeInsets.only(bottom: GeneralPositioning.mainSmallPadding),
      child: DropdownButtonFormField(
        decoration: dropDownInputDecoration(hintText: 'Bank Types'),
        items: bankTypesLst.map((bankType) {
          return DropdownMenuItem(
            value: bankType,
            child: Text(
              '${bankType.toString()}',
              style: TextFontStyle.customFontStyle(TextFormValues.textFormDropDownFont, color: ColourTheme.fontLightGrey),
            )
          );
        }).toList(),
        validator: validate,
        onChanged: (value) => setState( () { bankName = value; } ),
        ),
    );
  }

}