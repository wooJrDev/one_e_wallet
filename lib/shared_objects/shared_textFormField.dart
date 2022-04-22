import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';

// const textInputDecoration = InputDecoration(
//   fillColor: Colors.white,
//   filled: true,
//   enabledBorder: OutlineInputBorder(
//     borderSide: BorderSide(color: Colors.white, width: 2.0)
//   ),
//   focusedBorder: OutlineInputBorder(
//     borderSide: BorderSide(color: Colors.pink, width: 2.0)
//   )
// );

InputDecoration reloadPaymentInputDecoration({String hintText, FaIcon surfixIcon}) {
  return InputDecoration(
    hintText: '$hintText',
    hintStyle: TextFontStyle.customFontStyle(20, color: Colors.grey),
    contentPadding: EdgeInsets.symmetric(horizontal: GeneralPositioning.mainSmallPadding, vertical: 20),
    fillColor: ColourTheme.fontWhite,
    filled: true,
    suffixIcon: surfixIcon ?? null,
    errorMaxLines: 2,
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ShapeBorderRadius.textFormField),
      borderSide: BorderSide(color: ColourTheme.fontBlue, width: 3.0
      )
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ShapeBorderRadius.textFormField),
      borderSide: BorderSide(color: Colors.red, width: 3.0
      )
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ShapeBorderRadius.textFormField),
      borderSide: BorderSide(color: Colors.white, width: 3.0
      )
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ShapeBorderRadius.textFormField),
      borderSide: BorderSide(color: ColourTheme.fontBlue, width: 3.0
      )
    ),
  );
}


InputDecoration dropDownInputDecoration({String hintText}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextFontStyle.customFontStyle(TextFormValues.textFormDropDownFont, color: ColourTheme.fontLightGrey),
    fillColor: Colors.white,
    filled: true,
    contentPadding: EdgeInsets.symmetric(horizontal: GeneralPositioning.mainSmallPadding, vertical: 20),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ShapeBorderRadius.textFormField),
      borderSide: BorderSide(color: Colors.white, width: 2.0)
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ShapeBorderRadius.textFormField),
      borderSide: BorderSide(color: ColourTheme.fontBlue, width: 2.0)
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ShapeBorderRadius.textFormField),
      borderSide: BorderSide(color: ColourTheme.fontBlue, width: 2.0)
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ShapeBorderRadius.textFormField),
      borderSide: BorderSide(color: ColourTheme.fontRed, width: 2.0)
    ),
  );
}

InputDecoration textPaymentInputDecoration () {
  return InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ShapeBorderRadius.textFormField),
      borderSide: BorderSide(color: Colors.white, width: 2.0)
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ShapeBorderRadius.textFormField),
      borderSide: BorderSide(color: ColourTheme.fontBlue, width: 2.0)
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ShapeBorderRadius.textFormField),
      borderSide: BorderSide(color: ColourTheme.fontBlue, width: 2.0)
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ShapeBorderRadius.textFormField),
      borderSide: BorderSide(color: ColourTheme.fontRed, width: 2.0)
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
  );
}

InputDecoration textInputDecoration({@required hintText, IconData formIcon}) {
  return InputDecoration(
    prefixIcon: formIcon!=null ? Icon(formIcon): null ,
    hintText: '$hintText',
    hintStyle: TextFontStyle.customFontStyle(20, color: Colors.grey),
    // labelText: '$hintText',
    labelStyle: TextStyle(fontSize: 20, color: Colors.grey, height: 2, ),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    // disabledBorder: ,
    contentPadding: EdgeInsets.symmetric(horizontal: GeneralPositioning.mainSmallPadding, vertical: 15),
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
        color: Colors.transparent,
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
  );
}

class PaymentTextFormField extends StatefulWidget {

  final Function(String value) onChanged;
  final Function(String value) validation;
  final TextEditingController controller;
  final bool isDecimal;
  ///Controls the width of the textformfield, defaults to 160
  final double width;

  PaymentTextFormField({this.onChanged, this.controller, this.width, this.isDecimal = false, this.validation});

  @override
  _PaymentTextFormFieldState createState() => _PaymentTextFormFieldState();
}

class _PaymentTextFormFieldState extends State<PaymentTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 160,
      child: TextFormField(
        controller: widget.controller,
        inputFormatters: [
          // FilteringTextInputFormatter.digitsOnly,
          widget.isDecimal ? FilteringTextInputFormatter.allow( RegExp(r'^\d+\.?\d{0,2}') ) : FilteringTextInputFormatter.digitsOnly
          // FilteringTextInputFormatter.allow( RegExp(r'^\d+\.?\d{0,2}') ) //* This works fine (Allows for 2 decimal place)
          // FilteringTextInputFormatter.allow( RegExp('^[0-9]{0,6}(\\.[0-9]{0,2})?\$') ),
        ],
        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
        style: TextFontStyle.customFontStyle(TextFontStyle.ewalletReloadPage_ewalletReloadAmount, color: ColourTheme.fontBlue),
        decoration: textPaymentInputDecoration(),
        validator: widget.validation,
        onChanged: widget.onChanged,
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  // String hintText, bool obscureText, Function validation, IconData formIcon, String inputValue, Function onChanged}) { //Input Text Field For login/Register Fields
  ///Indicates the default text to be displayed when the field is empty
  final String hintText;
  /// Hides the input text. [true] to hide it, [false] to unhide it.
  final bool obscureText;
  /// Provides validation checking for the text field
  final Function(String) validation;
  /// Controls the event of changing the text
  final Function(String) onChanged;
  /// Displays an icon at the start of the text field
  final IconData formIcon;
  /// Provides a text controller in managing the input text.
  final TextEditingController textController;

  const CustomTextField({this.hintText, this.obscureText, this.validation, this.onChanged, this.formIcon, this.textController});


  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextFontStyle.customFontStyle(
        TextFontStyle.loginPage_textFormField,
        color: ColourTheme.fontDarkGrey
      ),
      controller: widget.textController,
      obscureText: widget.obscureText ?? false,
      decoration: textInputDecoration(hintText: widget.hintText, formIcon: widget.formIcon),
      onChanged: widget.onChanged,
      validator: widget.validation,  //validation
    );
  }
}

class DropDownFormField extends StatefulWidget {

  final Function validate;
  final Function(String value) onChanged;
  final List<String> itemLst; 
  final String hintText;

  DropDownFormField({this.validate, this.onChanged, @required this.itemLst, this.hintText}); 


  @override
  _DropDownFormFieldState createState() => _DropDownFormFieldState();
}

class _DropDownFormFieldState extends State<DropDownFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButtonFormField(
        decoration: dropDownInputDecoration(hintText: widget.hintText),
        items: widget.itemLst.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              '${item.toString()}',
              style: TextFontStyle.customFontStyle(TextFormValues.textFormDropDownFont, color: ColourTheme.fontLightGrey),
            )
          );
        }).toList(),
        validator: widget.validate,
        onChanged: widget.onChanged ?? (value) {},
        ),
    );
  }
}

class AdditionalErrorMsg extends StatelessWidget {

  final String errorMsg;
  final bool visbibleCondition;

  AdditionalErrorMsg({ @required this.visbibleCondition, this.errorMsg });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visbibleCondition ?? false,
      child: Container(
        margin: EdgeInsets.only(bottom: GeneralPositioning.mainSmallPadding),
        child: Text(
          '$errorMsg',
          style: TextFontStyle.customFontStyle(TextFormValues.textFormErrorMsgFont, fontWeight: FontWeight.w500, color: ColourTheme.fontRed),
        ),
      ),
    );
  }
}