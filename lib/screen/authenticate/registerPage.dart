import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:one_e_sample/firebase/credentialDb.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';
import 'package:one_e_sample/shared_objects/shared_appBehaviour.dart';
import 'package:one_e_sample/shared_objects/shared_buttons.dart';
import 'package:one_e_sample/shared_objects/shared_popUpDialog.dart';
import 'package:one_e_sample/shared_objects/shared_textFormField.dart';

class RegisterPage extends StatefulWidget {

  final Function ?changeScreen;
  RegisterPage({this.changeScreen});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  String ?usernameInput;
  String ?passwordInput;
  String ?emailInput;
  bool signUpError = false;
  bool loadingState = false;


  RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => removeFocus(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: new LinearGradient(
            colors: [
              Colors.orange[100]!,
              Colors.deepOrange[700]!,
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(2.0, 2.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp)
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[

            Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(child: _registerForm(),),
            ), 

            // Align( //* Sign In Button
            //   alignment: AlignmentDirectional.topEnd,
            //   child: Padding(
            //     padding: EdgeInsets.only(right: 20, top: 20),
            //     child: PillShapedButton('Sign In', Colors.orange, callback: signInBtnAction)
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _registerForm() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 30, 20, 25),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: ColourTheme.fontBrightRed.withAlpha(50),
        borderRadius: BorderRadius.circular(15)
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TitleText(title: 'Register an account', fontSize: TextFontStyle.registerPage_titleFontSize,),
            SizedBox(height: 30),

            ..._inputText(inputName: 'Username', validation: usernameValidation, formIcon: Icons.person, inputValue: usernameInput!, onChanged: usernameOnChanged),
            SizedBox(height: TextFormValues.spaceBetweenTextForm),
            ..._inputText(inputName: 'Email', validation: emailValidation, formIcon: Icons.email, inputValue: emailInput!, onChanged: emailOnChanged),
            SizedBox(height: TextFormValues.spaceBetweenTextForm),
            ..._inputText(inputName: 'Password', obscureText: true, validation: passwordValidation, formIcon: Icons.lock, inputValue: passwordInput!, onChanged: passwordOnChanged),
            SizedBox(height: TextFormValues.spaceBetweenTextForm),
            AdditionalErrorMsg(visbibleCondition: signUpError, errorMsg: 'This email has been taken',),
            _registerButton(),
            SizedBox(height: 30),
            RichText(
              text: TextSpan(
                text: "Already have an account? ",
                style: TextStyle(fontSize: TextFontStyle.loginPage_registerMessage),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Login',
                    style: TextStyle(color: Colors.red[800], fontWeight: FontWeight.w900),
                    recognizer: TapGestureRecognizer()..onTap = (){
                      widget.changeScreen!();
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

  List<Widget> _inputText({String ?inputName, bool ?obscureText, Function ?validation, IconData ?formIcon, String ?inputValue, Function ?onChanged}) {
    return [
      SizedBox(height: TextFormValues.spaceBetweenFormTitle),
      CustomTextField(
        hintText: inputName,
        formIcon: formIcon,
        obscureText: obscureText,
        validation: validation as dynamic Function(String)?,
        onChanged: onChanged as dynamic Function(String)?,
      ),
    ];
  }

  Widget _registerButton() {
    return CustomBtnSquareButton(
      child: Visibility(
        replacement: LoadingIndicator(),
        visible: !loadingState,
        child: Text(
          'Sign Up',
          style: TextFontStyle.customFontStyle( TextFontStyle.loginPage_loginButton ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      onPressed: () async{
        removeFocus();
        if (_formKey.currentState!.validate()) {
          setState(() {
              signUpError = false;
              loadingState = true;
          });

          dynamic result = await _authService.authRegister(email: emailInput!, password: passwordInput!, username: usernameInput!);
          //* If result == null, register has error, If result != null == userData, register is successful
          if (this.mounted) {
            setState(() {
              if (result == null) {
                signUpError = true;
              }else {
                signUpError = false;
                popUpSuccess(
                  context: context, 
                  title: 'Successfully registered account \n\nPlease verify your account through the link sent to your email $emailInput',
                  isAutoHide: false,
                  dismissAction: (type) => widget.changeScreen!(),
                );
              }
              loadingState = false;
            });
          }
        } else {
          setState(() {
            signUpError = false;
          });
        }
      },
    );
  }

  signInBtnAction() {
    widget.changeScreen!();
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

  //Username Validation
  String usernameValidation (value) {
    if (value.isEmpty) {
      return 'Username is required';
    } else if (value.length > 20) {
      return 'Username must not be more than 20 characters';
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

  //Username onChanged Function
  usernameOnChanged (val) {
    setState(() => usernameInput = val.toString().trim());
  }

  //Email onChanged Function
  emailOnChanged (val) {
    setState(() => emailInput = val.toString().trim());
  }

  //Password onChanged Function
  passwordOnChanged (val) {
    setState(() => passwordInput = val.toString().trim());
  }
}

class TitleText extends StatelessWidget {
  final String ?title;
  final double ?fontSize;
  TitleText({this.title, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Text(
        '$title',
        style: TextFontStyle.customFontStyle( fontSize! ),
      )
    );
  }
}




