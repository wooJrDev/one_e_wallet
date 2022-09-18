import 'package:flutter/material.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';

class BackButtonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final BuildContext context;
  final String title;
  const BackButtonAppBar({Key? key, required this.context, required this.title}) : super(key: key);

  @override
  State<BackButtonAppBar> createState() => _BackButtonAppBarState();
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}

class _BackButtonAppBarState extends State<BackButtonAppBar> {
  @override
  Widget build(BuildContext context) {
          return AppBar(
            title: Text(
              widget.title, 
              style: TextFontStyle.customFontStyle(TextFontStyle.appBar_mediumTitle),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: ColourTheme.fontWhite, size: 35),
              onPressed: () => Navigator.pop(context),
            )
          );
  }
}

// Widget titleAppBar({String ?title}) {
class TitleAppBar extends StatefulWidget implements PreferredSizeWidget{
  final String title;

  const TitleAppBar({Key? key, required this.title}) : super(key: key);

  @override
  State<TitleAppBar> createState() => _TitleAppBarState();
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}

class _TitleAppBarState extends State<TitleAppBar> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      titleSpacing: GeneralPositioning.mainPadding,
      title: Text(widget.title, style: TextFontStyle.customFontStyle(TextFontStyle.appBar_largeTitle, color: ColourTheme.mainAppColour),),
      automaticallyImplyLeading: false,
      elevation: 0,
    );
  }
}
