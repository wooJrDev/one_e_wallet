import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:one_e_sample/firebase/credentialDb.dart';
import 'package:one_e_sample/models/userModel.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';
import 'package:one_e_sample/shared_objects/shared_appBar.dart';
import 'package:one_e_sample/shared_objects/shared_appBehaviour.dart';
import 'package:one_e_sample/shared_objects/shared_buttons.dart';
import 'package:one_e_sample/shared_objects/shared_popUpDialog.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {

  final _formKey = GlobalKey<FormState>();

  String oldPasswordInput;
  String newPasswordInput;
  String confirmPasswordInput;
  bool loadingState = false;
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController reconfirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final userDetails = Provider.of<UserModel>(context);

    return GestureDetector(
      onTap: () => removeFocus(),
      child: Scaffold(
        backgroundColor: ColourTheme.lightBackground,
        appBar: backButtonAppBar(context: context, title: 'User Profile Settings'),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: GeneralPositioning.mainSmallPadding, vertical: GeneralPositioning.mainSmallPadding),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'User Details',
                    style: TextFontStyle.customFontStyle(TextFontStyle.userProfilePage_mainTitle, fontWeight: FontWeight.w900,  color: ColourTheme.fontBlue),
                  ),
                ),
                Card(
                  color: ColourTheme.darkOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Column(
                      children: <Widget>[
                        UserDetailSubTitle(text: "Username",),
                        UserDetailInfoTile(text: "${userDetails.userName ?? 'Fallback username'}",),
                        UserDetailSubTitle(text: "Email",),
                        UserDetailInfoTile(text: "${userDetails.userEmail ?? 'Fallback email'}",),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top: GeneralPositioning.mainPadding, bottom: 10),
                  child: Text(
                    'Update Password',
                    style: TextFontStyle.customFontStyle(TextFontStyle.userProfilePage_mainTitle, fontWeight: FontWeight.w900,  color: ColourTheme.fontBlue),
                  ),
                ),
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        userProfileTextFormField(hintText: "Old Password", onChanged: oldPasswordOnChanged, textController: oldPasswordController, validation: oldPasswordValidation),
                        userProfileTextFormField(hintText: "New Password", onChanged: passwordOnChanged, textController: newPasswordController, validation: newPasswordValidation),
                        userProfileTextFormField(hintText: "Reconfirm New Password", onChanged: confirmPasswordOnChanged, textController: reconfirmPasswordController, validation: reconfirmPasswordValidation),
                        TextButton(
                          onPressed: () async {
                            removeFocus();
                            if (_formKey.currentState.validate()) {

                              setState(() {
                                  loadingState = true;
                              });                              

                              var result = await AuthService().updatePassword(email: userDetails.userEmail, oldPassword: oldPasswordInput , newPassword: newPasswordInput);

                              if (this.mounted) {
                                setState(() {
                                  loadingState = false;
                                });
                              }

                              if (result != null) {
                                popUpFailed(
                                  context: context, 
                                  title: 'Fail to update password\n\n$result',
                                );
                              }else {
                                popUpSuccess(
                                  context: context, 
                                  title: 'Successfully updated password',
                                  dismissAction: () => setState(() {
                                    _formKey.currentState.reset();
                                  }),
                                );
                              }
                              // print(UserProfileTextFormField().passwordInput);
                            }
                          }, 
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
                              'Update User Profile',
                              style: TextFontStyle.customFontStyle(TextFontStyle.textButton),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget userProfileTextFormField({String hintText, String Function(String) validation, Function onChanged, TextEditingController textController}) {
    return Container(
      margin: EdgeInsets.only(bottom: GeneralPositioning.mainSmallPadding),
      child: TextFormField(
        controller: textController,
        style: TextStyle(
          fontSize: TextFormValues.textFormFont,
        ),
        obscureText: true,
        decoration: InputDecoration(
          hintText: '$hintText',
          errorMaxLines: 2,
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
        onChanged: onChanged,
        validator: validation //validation
      ),
    );
  }

  //General Password validation
  String oldPasswordValidation(value) {
    if (value.isEmpty) {
      return 'Old password is required';
    } else if (value.length<6) {
      return 'Old password must be more than 6 characters';
    }
    return null;
  }

  String newPasswordValidation(value) {
    if (value.isEmpty) {
      return 'New password is required';
    } else if (value.length<6) {
      return 'New password must be more than 6 characters';
    } 
    return null;
  }

  String reconfirmPasswordValidation(value) {
    if (value.isEmpty) {
      return 'Reconfirm new password is required';
    } else if (value.length < 6) {
      return 'Reconfirm new password must be more than 6 characters';
    } else if (value != newPasswordController.text) {
      return 'Reconfirm new password does not match with new password';
    }
    return null;
  }

  //Password onChanged Function
  passwordOnChanged (val) {
    setState(() => newPasswordInput = val);
  }

  //OldPassword onChanged Function
  oldPasswordOnChanged (val) {
    setState(() => oldPasswordInput = val);
  }

  //ConfirmPassword onChanged Function
  confirmPasswordOnChanged (val) {
    setState(() => confirmPasswordInput = val);
  }
}



class UserDetailSubTitle extends StatelessWidget {

  final String text;
  UserDetailSubTitle({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        '$text',
        style: TextFontStyle.customFontStyle(TextFontStyle.userProfilePage_subTitle, fontWeight: FontWeight.w900,),
      ),
    );
  }
}

class UserDetailInfoTile extends StatelessWidget {
  final String text;
  UserDetailInfoTile({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: GeneralPositioning.mainSmallPadding, vertical: 20),
      decoration: BoxDecoration(
        color: ColourTheme.fontBlue,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Text(
        '$text',
        style: TextFontStyle.customFontStyle(TextFontStyle.userProfilePage_username),
      ),
    );
  }
}

  // passwordOnChanged (val) {
  //   setState(() => widget.passwordInput = val);
  // }
