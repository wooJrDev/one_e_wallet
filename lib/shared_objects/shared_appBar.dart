import 'package:flutter/material.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';

Widget backButtonAppBar({@required BuildContext context, @required String title}) {
      return AppBar(
        title: Text(
          '$title', 
          style: TextFontStyle.customFontStyle(TextFontStyle.appBar_mediumTitle),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: ColourTheme.fontWhite, size: 35),
          onPressed: () => Navigator.pop(context),
        )
      );
}

Widget titleAppBar({String title}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    titleSpacing: GeneralPositioning.mainPadding,
    title: Text('$title', style: TextFontStyle.customFontStyle(TextFontStyle.appBar_largeTitle, color: ColourTheme.mainAppColour),),
    automaticallyImplyLeading: false,
    elevation: 0,
  );
}