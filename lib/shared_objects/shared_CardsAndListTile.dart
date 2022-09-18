import 'package:flutter/material.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';


class TrxListTile extends StatelessWidget {
  final String ?trxTitle;
  final String ?trxLabel;
  final double ?trxAmountFontSize;

  TrxListTile({this.trxTitle, this.trxLabel, this.trxAmountFontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '$trxTitle:',
            style: TextFontStyle.customFontStyle(TextFontStyle.trxPopUpDialog_subtitle_general),
          ),
          SizedBox(width: 5),
          Flexible(
            child: Text(
              '$trxLabel',
              textAlign: TextAlign.right,
              style: TextFontStyle.customFontStyle(trxAmountFontSize ?? TextFontStyle.trxPopUpDialog_subtitle_general),
              maxLines: 2
            ),
          ),
        ],
      ),
    );
  }
}