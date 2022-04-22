import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one_e_sample/firebase/credentialDb.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';
import 'package:one_e_sample/shared_objects/shared_appBehaviour.dart';
import 'package:one_e_sample/shared_objects/shared_buttons.dart';
import 'package:one_e_sample/shared_objects/shared_textFormField.dart';

class LoginPage extends StatefulWidget {

  final Function changeScreen;
  LoginPage({this.changeScreen});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String emailInput;
  String passwordInput;
  bool loadingState = false;
  bool loginError = false;
  String loginErrorText;

  RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => removeFocus(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                colors: [
                  // Color(0xFF3366FF),
                  // Color(0xFF00CCFF),
                  // ColourTheme.lightBackground,
                  Colors.lightBlue[200],
                  Colors.green[500],
                  // ColourTheme.fontBrightBlue
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(2.0, 2.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp)
            ),
            child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(child: _loginForm()),
              ),
              
              // Align(
              //   alignment: AlignmentDirectional.topEnd,
              //   child: Padding(
              //     padding: EdgeInsets.only(right: 20, top: 20),
              //     child: _registerButton(),
              //   ),
              // ),

            ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 30, 20, 25),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        // color: Colors.deepPurple[700].withAlpha(60),
        color: Colors.deepPurple[700].withAlpha(60).withOpacity(0.2),
        // color: Color(0xFFAAD9BC).withAlpha(90),
        // color: ColourTheme.orange.withAlpha(100),
        borderRadius: BorderRadius.circular(15)
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Text(
                'Sign In to your UE Wallet',
                style: TextFontStyle.customFontStyle(
                  TextFontStyle.loginPage_titleFontSize,
                  // color: ColourTheme.mainAppColour,
                ),
              )
            ),
            SizedBox(height: 30),
            ..._inputText(inputName: 'Email', validation: emailValidation, formIcon: Icons.email, inputValue: emailInput, onChanged: emailOnChanged),
            SizedBox(height: TextFormValues.spaceBetweenTextForm),
            ..._inputText(inputName: 'Password', obscureText: true, validation: passwordValidation, formIcon: Icons.lock, inputValue: passwordInput, onChanged: passwordOnChanged),
            SizedBox(height: TextFormValues.spaceBetweenTextForm),
            AdditionalErrorMsg(
              visbibleCondition: loginError,
              errorMsg: loginErrorText,
            ),

            _loginButton(),
            SizedBox(height: 30),
            RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(fontSize: TextFontStyle.loginPage_registerMessage),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Register',
                    style: TextStyle(color: Colors.indigo[700], fontWeight: FontWeight.w900),
                    recognizer: TapGestureRecognizer()..onTap = (){
                      widget.changeScreen();
                    },
                  ),
                  TextSpan(
                    text: ' now'
                  )
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _inputText({String inputName, bool obscureText, Function validation, IconData formIcon, String inputValue, Function onChanged}) {
    return [
      // Align(
      //   alignment: AlignmentDirectional.topStart,
      //   child: Text(
      //     '$inputName',
      //     style: TextFontStyle.customFontStyle(
      //       TextFormValues.textFormTitleFont,
      //       color: ColourTheme.fontBlue
      //     ),
      //   )
      // ),
      SizedBox(height: 5),
      // _inputTextField(hintText: inputName, obscureText: obscureText, validation: validation, formIcon: formIcon, inputValue: inputValue, onChanged: onChanged),
      CustomTextField(
        hintText: '$inputName',
        formIcon: formIcon,
        obscureText: obscureText,
        validation: validation,
        onChanged: onChanged,
      ),
    ];
  }

  Widget _loginButton() {
    return RaisedButton(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      color: ColourTheme.fontBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Visibility(
        replacement: LoadingIndicator(),
        visible: !loadingState,
        child: Text(
          'Login',
          style: TextFontStyle.customFontStyle( TextFontStyle.loginPage_loginButton ),
        ),
      ),
      onPressed: () async {
        removeFocus();
        if (_formKey.currentState.validate() && loadingState == false) {
          print('Email input: $emailInput');
          print('Password input: $passwordInput');

          setState(() {
            loginError = false;
            loadingState = true;
          });
          var result = await _authService.authSignIn(email: emailInput, password: passwordInput);
          if (this.mounted) {
            setState(() {
              if (result == null) {
                print('reached here instead');
                loginErrorText = 'Invalid Account Credentials';
                loginError = true;
              } else if (result.isEmailVerified == false) {
                print('reached here');
                loginErrorText = 'Email Not Verified';
                loginError = true;
              } else {
                loginError = false;
              }
              loadingState = false;
            });
          }
        } else {
          setState(() {
            loginError = false;
          });
        }
      },
    );
  }

  Widget _registerButton() {
    return RaisedButton(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Colors.orange,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50)
      ),
      child: Text(
        'Register',
        style: TextStyle(
          fontSize: 20
        ),
      ),
      onPressed: () {
        widget.changeScreen();
      },
    );
  }

  //Email Validation
  String emailValidation (value) {
    if (value.isEmpty) {
      return 'Email is required';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  //Password Validation
  String passwordValidation (value) {
    if (value.isEmpty) {
      return 'Password is required';
    } else if (value.length<6) {
      return 'Password must be more than 6 characters';
    }
    return null;
  }

  //Email onChanged Function
  emailOnChanged (val) {
    setState(() => emailInput = val);
  }

  //Password onChanged Function
  passwordOnChanged (val) {
    setState(() => passwordInput = val);
  }

}


