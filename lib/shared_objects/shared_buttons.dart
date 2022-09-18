import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class PillShapedButton extends StatelessWidget {
  final String buttonText;
  final Color bgColor;
  final VoidCallback ?callback; //Function class can also be used instead

  PillShapedButton(this.buttonText, this.bgColor, {this.callback});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50)
      ),
    ),
    child: Text(
      '$buttonText',
      style: TextStyle(
        fontSize: 20
      ),
    ),
    onPressed: callback,
  );
  }
}

class CustomBtnSquareButton extends StatefulWidget {

  final VoidCallback ?onPressed;
  final String ?text;
  ///Provides a flexible width unless specified
  final double ?customWidth;
  final EdgeInsetsGeometry ?padding;
  final Color ?bgColour;
  ///Specifies a custom child, by [default] a text widget would be the child
  final Widget ?child;

  CustomBtnSquareButton({this.text, this.onPressed, this.customWidth, this.padding, this.bgColour, this.child});

  @override
  _CustomBtnSquareButtonState createState() => _CustomBtnSquareButtonState();
}

class _CustomBtnSquareButtonState extends State<CustomBtnSquareButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.customWidth,
      // height: 200,
      // padding: EdgeInsets.symmetric(horizontal: GeneralPositioning.mainPadding),
      // alignment: Alignment.center,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all( widget.bgColour ?? ColourTheme.fontBlue ),
          padding: MaterialStateProperty.all(
            widget.padding ?? EdgeInsets.symmetric(horizontal: GeneralPositioning.mainSmallPadding, vertical: 15)
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ShapeBorderRadius.boxElevatedButton)
            ),
          ),
        ),
        child: widget.child ?? Text(widget.text ?? '', style: TextFontStyle.customFontStyle(TextFontStyle.ewalletReloadPage_quickReloadConfirmButton),),
        onPressed: widget.onPressed, 
      ),
    );
  }
}

class CustomBtnSlideButton extends StatefulWidget {

  final String ?text;
  ///Specifies a custom width;
  final double width;
  ///If [true] the width would be set to the maximum value (332), [false] would be set to the default value (250).
  ///Will be overriden if a custom width is specified.
  final bool isFullWidth;
  final VoidCallback ?onSlide;

  CustomBtnSlideButton({this.text, required this.width, this.isFullWidth = false, this.onSlide});

  @override
  _CustomBtnSlideButtonState createState() => _CustomBtnSlideButtonState();
}

class _CustomBtnSlideButtonState extends State<CustomBtnSlideButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ConfirmationSlider(
        height: 60,
        width: widget.width != null ? widget.width : widget.isFullWidth ? 332 : 250,
        text: widget.text ?? 'Slide to Confirm',
        textStyle: TextFontStyle.customFontStyle(TextFontStyle.uewalletReloadPage_slideToConfirmBtn, color: ColourTheme.fontLightGrey),
        onConfirmation: widget.onSlide ?? () {},
      ),
    );
  }
}

class CustomBtnRadioButton extends StatefulWidget {

  final List<String> buttonLablesLst;
  final List<String> buttonValuesLst;
  final void Function(dynamic) onTap;
  final String buttonValue;

  const CustomBtnRadioButton({Key ?key, required this.buttonLablesLst, required this.buttonValuesLst, required this.buttonValue, required this.onTap}) : super(key: key);


  @override
  _CustomBtnRadioButtonState createState() => _CustomBtnRadioButtonState();
}

class _CustomBtnRadioButtonState extends State<CustomBtnRadioButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          CustomRadioButton(
            width: 90, 
            elevation: 0,
            enableShape: true,
            enableButtonWrap: true,
            unSelectedBorderColor: Colors.transparent,
            selectedColor: Theme.of(context).accentColor,
            unSelectedColor: Theme.of(context).canvasColor,
            buttonTextStyle: ButtonTextStyle( textStyle: TextStyle( fontSize: 15 ) ),
            defaultSelected:  widget.buttonValue ?? "",
            buttonLables: widget.buttonLablesLst,
            buttonValues: widget.buttonValuesLst,
            radioButtonValue: widget.onTap ?? (value) {},
          ),
        ],
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({ Key ?key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Loading', style: TextFontStyle.customFontStyle(TextFontStyle.loginPage_loginButton),),
        SizedBox(width: 15),
        CircularProgressIndicator(backgroundColor: Colors.white, strokeWidth: 5),
      ],
    );
  }
}
