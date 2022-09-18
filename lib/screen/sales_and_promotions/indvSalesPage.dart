import 'package:flutter/material.dart';
import 'package:one_e_sample/models/sales_card.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';
import 'package:one_e_sample/shared_objects/shared_appBar.dart';

class IndvSalesPage extends StatelessWidget {

  final SalesCardModel ?salesDetail;

  IndvSalesPage({this.salesDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourTheme.lightBackground,
      appBar: BackButtonAppBar(context: context, title: '${salesDetail?.ewalletType} Promotion'),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${salesDetail?.salesTitle}',
                style: TextFontStyle.customFontStyle(TextFontStyle.indvSalesPage_title, color: ColourTheme.fontBlue),
              ),
              SizedBox(height: 20),
              Container(
                height: 220,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: ColourTheme.ewallet_Grab,
                  borderRadius: BorderRadius.circular(ShapeBorderRadius.homeCardRadius)
                ),
                child: Image(
                  image: AssetImage( salesDetail!.salesImg!),
                  fit: BoxFit.cover,
                  alignment: new Alignment(-1.0, 1.0), //? QUES: Do we need to specify the alignment for each photo?
                ),
              ),
              SizedBox(height: 20),

              Text(
                'Terms and Conditions',
                style: TextFontStyle.customFontStyle(TextFontStyle.indvSalesPage_tncTitle, color: ColourTheme.fontBlue),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: salesDetail?.salesDesc?.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${index+1}.',
                          style: TextFontStyle.customFontStyle(TextFontStyle.indvSalesPage_tncDesc, color: ColourTheme.fontBlue, fontWeight: FontWeight.w600),
                        ),
                        Expanded(
                            child: Container(
                            child: Text(
                              salesDetail!.salesDesc![index],
                              style: TextFontStyle.customFontStyle(TextFontStyle.indvSalesPage_tncDesc, color: ColourTheme.fontBlue, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        )
                      ],                
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}