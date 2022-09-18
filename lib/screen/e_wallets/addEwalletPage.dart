import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one_e_sample/firebase/database.dart';
import 'package:one_e_sample/models/ewallets_cardModel.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';
import 'package:one_e_sample/shared_objects/shared_appBar.dart';
import 'package:one_e_sample/shared_objects/shared_appBehaviour.dart';
import 'package:one_e_sample/shared_objects/shared_buttons.dart';
import 'package:one_e_sample/shared_objects/shared_popUpDialog.dart';
import 'package:one_e_sample/shared_objects/shared_textFormField.dart';

class AddEwalletsPage extends StatefulWidget {
  @override
  _AddEwalletsPageState createState() => _AddEwalletsPageState();
}

class _AddEwalletsPageState extends State<AddEwalletsPage> {

  final _formKey = GlobalKey<FormState>();
  List<String> ewalletTypes = EwalletsCardModel().ewalletTypeLst;
  List<EwalletsCardModel> ?ewalletLst;

  RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  String ?_currentEwalletType; //Default value
  String ?_emailInput;
  String ?_passwordInput;
  bool _errorFromDb = false;
  String ?_errorMsgFromDb;

  bool loadingState = false;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => removeFocus(),
      child: Scaffold(
        backgroundColor: ColourTheme.lightBackground,
        appBar: BackButtonAppBar(context: context, title: 'Add E-wallet'),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height - 100,
            padding: EdgeInsets.all(GeneralPositioning.mainSmallPadding),
            child: StreamBuilder(
              stream: DatabaseService().getEwalletUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  ewalletLst = snapshot.data as List<EwalletsCardModel>?;
                  
                  ewalletLst?.forEach((ewalletDetail) {
                    ewalletTypes.removeWhere((ewalletType) => ewalletType == ewalletDetail.eWalletType);
                  });

                  return Visibility(
                    visible: ewalletLst?.length == 3 ? false : true,
                    replacement: Container(
                      padding: EdgeInsets.all(GeneralPositioning.mainSmallPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.boxOpen, size: 80, color: ColourTheme.fontBlue,),
                          SizedBox(height: GeneralPositioning.mainSmallPadding,),
                          Text(
                            "You have already added the maximum number of E-wallets. \n\nTo switch to another E-wallet account, kindly remove the existing E-wallet",
                            textAlign: TextAlign.center,
                            style: TextFontStyle.customFontStyle(TextFontStyle.ewalletCard_emptyMessage, color: ColourTheme.fontBlue),
                          ),
                        ],
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          DropDownFormField(
                            hintText: 'Select E-wallet Type',
                            itemLst: ewalletTypes,
                            onChanged: (value) => setState(() => _currentEwalletType = value),
                            validate: validateEwalletType,
                          ),
                          SizedBox(height: GeneralPositioning.mainSmallPadding),
                          addEwalletTextFormField(hintText: "Email", validation: emailValidation, onChanged: usernameOnChanged, obscureText: false),
                          addEwalletTextFormField(hintText: "Password", validation: passwordValidation, onChanged: passwordOnChanged, obscureText: true),
                          errorMsgFromDb(),
                          TextButton( 
                            style: ButtonStyle(
                              overlayColor: MaterialStateColor.resolveWith((states) => ColourTheme.inkWellDarkBlue),
                              padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 25, vertical: 20)),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                              backgroundColor: MaterialStateProperty.all(ColourTheme.fontBlue)
                            ),
                            child: Visibility(
                              replacement: LoadingIndicator(),
                              visible: !loadingState,
                              child: Text(
                                'Add E-wallet',
                                style: TextFontStyle.customFontStyle(TextFontStyle.textButton),
                              ),
                            ),
                            onPressed: () async {
                              removeFocus();
                              if (_formKey.currentState!.validate()) {
                                dynamic ewalletUserId = await DatabaseService().authEwalletUserId(email: _emailInput, password: _passwordInput, ewalletType: _currentEwalletType);
                                if (ewalletUserId == null) {
                                  setState(() {
                                    _errorFromDb = true;
                                    _errorMsgFromDb = 'Invalid E-wallet Account';
                                  });
                                }else {
                                  var accountNotTaken = await DatabaseService().authEwalletAvailableStatus(ewalletUserId: ewalletUserId, ewalletType: _currentEwalletType);

                                  if (accountNotTaken) {
                                    setState(() {
                                      ewalletTypes.removeWhere((item) => item == _currentEwalletType);
                                      _formKey.currentState!.reset();
                                      loadingState = true;
                                    });

                                    dynamic updateResult = await DatabaseService().manageEwalletAcc(ewalletType: DatabaseService().getDbEwalletAccType(_currentEwalletType!), ewalletUserId: ewalletUserId);
                                    if (!updateResult) {
                                      _errorFromDb = true;
                                      _errorMsgFromDb = 'An Error Has Occur, Please Try Again';
                                      loadingState = false;
                                    }else {
                                      if (this.mounted) {
                                        setState(() {
                                          _errorFromDb = false;
                                          ewalletTypes.removeWhere((item) => item == _currentEwalletType);
                                          _formKey.currentState!.reset();
                                          loadingState = false;
                                        });
                                      }
                                      popUpSuccess(
                                        context: context, 
                                        title: '\nSuccessfully Added $_currentEwalletType \nE-wallet Account',
                                        dismissAction: (type) => Navigator.pop(context),
                                      );
                                    }
                                  } else {
                                    setState(() {
                                      _errorFromDb = true;
                                      _errorMsgFromDb = 'E-wallet account has been used';
                                    });
                                  }
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );

                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.boxOpen, size: 80, color: ColourTheme.fontBlue,),
                      SizedBox(height: GeneralPositioning.mainSmallPadding,),
                      Text(
                        "You have already added the maximum number of E-wallets. To switch to another E-wallet account, kindly remove the existing E-wallet",
                        textAlign: TextAlign.center,
                        style: TextFontStyle.customFontStyle(TextFontStyle.ewalletCard_emptyMessage, color: ColourTheme.fontBlue),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget errorMsgFromDb() {
    return Visibility(
      visible: _errorFromDb,
      child: Container(
        margin: EdgeInsets.only(bottom: GeneralPositioning.mainSmallPadding),
        child: Text(
          '$_errorMsgFromDb',
          style: TextFontStyle.customFontStyle(TextFormValues.textFormErrorMsgFont, fontWeight: FontWeight.w500, color: ColourTheme.fontRed),
        ),
      ),
    );
  }

  Widget addEwalletTextFormField({String ?hintText, Function ?validation, Function ?onChanged, bool ?obscureText}) {
    return Container(
      margin: EdgeInsets.only(bottom: GeneralPositioning.mainSmallPadding),
      child: TextFormField(
      style: TextStyle(
        fontSize: TextFormValues.textFormFont,
      ),
      obscureText: obscureText!,
      decoration: InputDecoration(
        hintText: '$hintText',
        hintStyle: TextFontStyle.customFontStyle(20, color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(horizontal: GeneralPositioning.mainSmallPadding, vertical: 20),
        fillColor: ColourTheme.fontWhite,
        filled: true,
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ShapeBorderRadius.textFormField),
          borderSide: BorderSide(
            color: ColourTheme.fontBlue,
            width: 3.0
          )
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ShapeBorderRadius.textFormField),
          borderSide: BorderSide(
            color: Colors.red,
            width: 3.0
          )
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ShapeBorderRadius.textFormField),
          borderSide: BorderSide(
            color: Colors.white,
            width: 3.0
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ShapeBorderRadius.textFormField),
          borderSide: BorderSide(
            color: ColourTheme.fontBlue,
            width: 3.0
          )
        ),
      ),
      onChanged: onChanged as void Function(String)?,
      validator: validation as String? Function(String?)?,
      ),
    );
  }

  //Password onChanged Function
  passwordOnChanged (val) {
    setState(() => _passwordInput = val);
  }

  //OldPassword onChanged Function
  usernameOnChanged (val) {
    setState(() => _emailInput = val);
  }

  //Email Validation
  String emailValidation (value) {
    if (value.isEmpty) {
      return 'Email is required';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Invalid email format';
    }
    return null!;
  }

  //Password Validation
  String passwordValidation (value) {
    if (value.isEmpty) {
      return 'Password is required';
    } else if (value.length<6) {
      return 'Password must be more than 6 characters';
    }
    return null!;
  }

  //E-wallet dropdown list Validation
  String validateEwalletType(value) {
    if (_currentEwalletType == null) 
      return "Please select an E-wallet from the provided list";
    return null!;
  }
}