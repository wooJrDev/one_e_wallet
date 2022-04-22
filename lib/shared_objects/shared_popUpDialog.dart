import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';

popUpSuccess({@required BuildContext context, @required String title, String desc, VoidCallback dismissAction, Duration autoHideDuration, bool isAutoHide = true}) {
  return AwesomeDialog(
    context: context,
    animType: AnimType.LEFTSLIDE,
    headerAnimationLoop: false,
    dialogType: DialogType.SUCCES,
    autoHide: isAutoHide ? Duration(seconds: 3) : autoHideDuration,
    title: title ?? '',
    desc: desc ?? '',
    btnOkText: 'Dismiss',
    btnOkOnPress: () {},
    onDissmissCallback: dismissAction ?? () {},
  )
  ..show();
}

popUpCustomSuccess({@required BuildContext context, @required String title, String desc, Function dismissAction, Widget body, VoidCallback btnOkOnPress, VoidCallback btnCancelOnPress}) {
  return AwesomeDialog(
    context: context,
    animType: AnimType.LEFTSLIDE,
    headerAnimationLoop: false,
    dialogType: DialogType.SUCCES,
    // autoHide: Duration(seconds: 3),
    body: body,
    
    title: title ?? '',
    desc: desc ?? '',
    btnCancelText: 'Dismiss',
    btnOkText: 'Show Receipt',
    // btnOk: Container(
    //   width: 1100,
    //   height: 30,
    //   child: ElevatedButton(
    //     child: Text('Dismiss'),
    //     onPressed: () {},
    //   ),
    // ),
    // dismissOnTouchOutside: true,
    btnCancelOnPress: btnCancelOnPress ?? () {},
    btnOkOnPress: btnOkOnPress,
    
    onDissmissCallback: dismissAction ?? null,
  )
  ..show();
}

popUpFailed({@required BuildContext context, @required String title, String desc, Function dismissAction}) {
  return AwesomeDialog(
    context: context,
    animType: AnimType.LEFTSLIDE,
    headerAnimationLoop: false,
    dialogType: DialogType.ERROR,
    title: title ?? '',
    desc: desc ?? '',
    btnOkText: 'Dismiss',
    btnOkOnPress: () {},
    onDissmissCallback: dismissAction ?? () {},
  )
  ..show();
}

popUpWarning({@required BuildContext context, @required String title, String desc, Function dismissAction, Duration autoHideDuaration}) {
  return AwesomeDialog(
    context: context,
    animType: AnimType.LEFTSLIDE,
    headerAnimationLoop: false,
    dialogType: DialogType.WARNING,
    title: title ?? '',
    desc: desc ?? '',
    autoHide: autoHideDuaration ?? Duration( milliseconds: 4000 ),
    btnOkText: 'Dismiss',
    btnOkOnPress: () {},
    onDissmissCallback: dismissAction ?? () {},
  )
  ..show();
}

class popUpQrCode extends StatelessWidget {

  final Uint8List qrCodeData;
  final String ewalletType;
  final VoidCallback onPressed;

  popUpQrCode({ this.onPressed, @required this.qrCodeData, this.ewalletType});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(0),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
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
                '$ewalletType QR Code',
                style: TextFontStyle.customFontStyle(TextFontStyle.trxPopUpDialog_trxTitle)
              ),
            ),

            Container(
              height: 260,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15) 
              ),
              child: qrCodeData.isEmpty ? displayInvalidQrCode() : Image.memory( qrCodeData ),
            ),

            Container(
              margin: EdgeInsets.only(top: 15),
              child: TextButton(
                onPressed: onPressed, 
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith((states) => ColourTheme.inkWellDarkBlue),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  backgroundColor: MaterialStateProperty.all(ColourTheme.fontBlue)
                ),
                child: Text(
                  'Back',
                  style: TextFontStyle.customFontStyle(TextFontStyle.trxPopUpDialog_button),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget displayInvalidQrCode() {
    return Center(
      child: Text(
        'Unable to display QR Code, please try again',
        textAlign: TextAlign.center,
        style: TextFontStyle.customFontStyle(20),
      ),
    );
  }

}
