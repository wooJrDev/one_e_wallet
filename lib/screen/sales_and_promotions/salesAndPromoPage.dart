import 'package:flutter/material.dart';
import 'package:one_e_sample/models/sales_card.dart';
import 'package:one_e_sample/screen/sales_and_promotions/indvSalesPage.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';
import 'package:one_e_sample/shared_objects/shared_appBar.dart';

class SalesAndPromoPage extends StatefulWidget {
  @override
  SalesAndPromoPageState createState() => SalesAndPromoPageState();
}

class SalesAndPromoPageState extends State<SalesAndPromoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourTheme.lightBackground,
      appBar: BackButtonAppBar(context: context, title: 'Sales and Promotions'),
      body: Container(
        // padding: EdgeInsets.fromLTRB(35, 35, 35, 0),
        child: ListView.builder(
          // padding: EdgeInsets.only(left: GeneralPositioning.mainLeftPadding),
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: salesCards.length,
          itemBuilder: (context, index) {
            return Container(
              height: 220,
              margin: EdgeInsets.fromLTRB(35, 35, 35, 0),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ShapeBorderRadius.homeCardRadius),
                boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 4.0,
                        spreadRadius: 0.0,
                        offset: Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                ],
              ),
              child: Stack(
                children: <Widget>[
                  Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        width: double.infinity,
                        color: Colors.red[300],
                        child: Image(
                          alignment: Alignment.center,
                          image: AssetImage(salesCards[index!].salesImg!),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: GeneralPositioning.salesCard_TextPadding_horz, vertical: GeneralPositioning.salesCard_TextPadding_vert),
                        width: double.infinity,
                        height: double.infinity,
                        color: salesCards[index].salesDescBgColour,
                        child: Text(
                          '${salesCards[index].salesTitle}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                          style: TextFontStyle.customFontStyle(TextFontStyle.salesCard_salesTitle),
                        ),
                      ),
                    )
                  ],
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(40),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => IndvSalesPage(salesDetail: salesCards[index],))),
                    ),
                  ),
                )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}