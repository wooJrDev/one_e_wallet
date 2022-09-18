import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one_e_sample/firebase/database.dart';
import 'package:one_e_sample/models/ewallets_cardModel.dart';
import 'package:one_e_sample/models/trx_cardModel.dart';
import 'package:one_e_sample/models/userModel.dart';
import 'package:one_e_sample/screen/history/trxPopUp.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';
import 'package:one_e_sample/shared_objects/shared_CardsAndListTile.dart';
import 'package:one_e_sample/shared_objects/shared_appBar.dart';
import 'package:one_e_sample/shared_objects/shared_appBehaviour.dart';
import 'package:one_e_sample/shared_objects/shared_buttons.dart';
import 'package:one_e_sample/shared_objects/shared_popUpDialog.dart';
import 'package:one_e_sample/shared_objects/shared_textFormField.dart';

class PaymentAmountPage extends StatefulWidget {

  final EwalletsCardModel ?ewalletDetail;
  final String ?merchantName;

  PaymentAmountPage({this.ewalletDetail, this.merchantName});

  @override
  _PaymentAmountPageState createState() => _PaymentAmountPageState();
}

class _PaymentAmountPageState extends State<PaymentAmountPage> {

  TextEditingController _paymentAmountController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool waitResult = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => removeFocus(),
      child: Scaffold(
        backgroundColor: ColourTheme.lightBackground,
        appBar: BackButtonAppBar(context: context, title: 'Enter Payment Amount'),
        body: SingleChildScrollView(
          child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 20, left: GeneralPositioning.mainPadding, right: GeneralPositioning.mainPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Amount To Pay:',
                    style: TextFontStyle.customFontStyle(TextFontStyle.paymentPage_payAmount_title, color: ColourTheme.fontBlue),
                  ),
                  SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: PaymentTextFormField(
                      width: double.infinity,
                      isDecimal: true,
                      controller: _paymentAmountController,
                      validation: _paymentAmountValidation,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.only(bottom: 20),
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
                            'Current Balance',
                            style: TextFontStyle.customFontStyle(TextFontStyle.trxPopUpDialog_trxTitle)
                          ),
                        ),
                        StreamBuilder(
                          stream: DatabaseService().getUserDetail,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                                UserModel uewalletDetail = snapshot.data as UserModel;
                                return TrxListTile(trxTitle: "UE-wallet", trxLabel: 'RM${uewalletDetail.userUeAccBalance?.toStringAsFixed(2)}' ?? "Uewallet Balance",);
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                        TrxListTile(trxTitle: "${widget.ewalletDetail?.eWalletType} Balance", trxLabel: 'RM${widget.ewalletDetail?.eWalletBalance?.toStringAsFixed(2)}' ?? "Fallback E-wallet Type",),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
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
                            'Payment Info',
                            style: TextFontStyle.customFontStyle(TextFontStyle.trxPopUpDialog_trxTitle)
                          ),
                        ),
                        TrxListTile(trxTitle: "E-wallet used", trxLabel: widget.ewalletDetail?.eWalletType ?? "Fallback E-wallet Type",),
                        TrxListTile(trxTitle: "Paying To", trxLabel:  widget.merchantName ?? "Fallback Merchant",),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomBtnSlideButton(
                    width: 322,
                    text: 'Slide to Confirm Payment',
                    isFullWidth: true,
                    onSlide: () async {
                      removeFocus();
                      if (_formKey.currentState!.validate()) {

                        double finalPaymentAmount = double.parse(_paymentAmountController.text);
                        TrxCardModel trxDetail = await DatabaseService().performPayment(
                          paymentAmount: finalPaymentAmount, 
                          ewalletDetail: widget.ewalletDetail,
                          merchantName:   widget.merchantName
                        );

                        if (trxDetail != null) {
                          popUpCustomSuccess(
                            context: context, 
                            title: 'Successfully Paid RM${double.parse(_paymentAmountController.text).toStringAsFixed(2)} To ${widget.merchantName}', 
                            // btnCancelOnPress: () => Navigator.of(context).popUntil((route) => route.isFirst),
                            dismissAction: (type) {
                              print('Triggered Dismiss');
                              waitResult ? null : Navigator.of(context).popUntil((route) => route.isFirst);
                            },
                            btnOkOnPress: () async {
                              print('Clicked on ok btn');
                              waitResult = true;
                              showDialog(
                                context: context, 
                                builder: (context) => TrxPopUpDialog( 
                                  trxCard: trxDetail, 
                                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst)
                                )
                              ).then((value) => Navigator.of(context).popUntil((route) => route.isFirst));
                            },
                            // body: Container(
                            //   color: Colors.brown[200],
                            //   child: Column(
                            //     children: <Widget>[
                            //       Text(
                            //         'Successfully Paid RM${_paymentAmountController.text}'
                            //       ),
                            //       CustomBtnSquareButton(text: 'Dimiss', onPressed: () {}, ),
                            //       CustomBtnSquareButton(text: 'Show Receipt', onPressed: () {}, ),
                            //     ],
                            //   ),
                            // ),
                          );
                        } else {
                          popUpFailed(
                            context: context, 
                            title: "Failed to perform transaction, please try again", 
                            dismissAction: (type) { 
                              setState(() {
                                _paymentAmountController.value = TextEditingValue.empty;
                              }); 
                            } 
                          );
                        }
                      }
                      else
                        print('Error: Invalid Payment Info Found');
                    },
                  ),
                ],
              ),
          ),
        ),
      ),
    );
  }

  TrxCardModel fakeTrxReciept() {
    print('Test Date: ${DateTime.now()}');
    print('Test Date2: ${DateFormat( "dd/MM/y hh:mm a" ).format( DateTime.now() ).toString()}');
    DateTime dt = DateTime(2021);
    return TrxCardModel(
      trxId: 'TestID001',
      trxType: 'Payment',
      trxMethod: widget.ewalletDetail?.eWalletType,
      trxRecipient: widget.merchantName,
      trxAmount: double.parse(_paymentAmountController.text),
      trxDateTime: DateFormat( "dd/MM/y hh:mm a" ).format( DateTime.now().add( Duration( hours: 8 ) ) ).toString(),
    );
  }

  String _paymentAmountValidation(String ?value) {
    var paymentAmount = value!.isNotEmpty ? double.parse(value) : 0;
    if (paymentAmount == 0 )
      return 'Payment amount cannot be empty';
    else if (paymentAmount > 9999)
      return 'Payment amount cannot exceed RM9999';
    else if (paymentAmount > widget.ewalletDetail!.eWalletBalance!)
      return 'Payment amount cannot exceed current E-wallet balance';
    return null!;
  }

}