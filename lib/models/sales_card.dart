import 'package:flutter/material.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';

class SalesCardModel {
  String ?ewalletType;
  String ?salesTitle;
  List<String> ?salesDesc;
  String ?salesImg;
  Color ?salesDescBgColour;
  Color ?salesDescTextColour;
  
  SalesCardModel({ 
    this.ewalletType,
    this.salesTitle,
    this.salesDesc,
    this.salesImg,
    this.salesDescBgColour,
    this.salesDescTextColour,
  });
}

//TODO: Add list of salesDesc for the terms and condition of each promo
List<SalesCardModel> salesCards = salesCardData.map((items) => SalesCardModel( 
    ewalletType: items['ewalletType'] as String,
    salesTitle: items['salesTitle'] as String,
    salesImg: items['salesImg'] as String,
    salesDescBgColour: items['salesDescBgColour'] as Color,
    salesDescTextColour: items['salesDescTextColour'] as Color,
    salesDesc: items['salesDesc'] as List<String>,
  )).toList() ;


//TODO: Add sample salesDesc for the terms and condition of each promo
var salesCardData = [
  {
    "ewalletType": "Grab",
    "salesTitle": "Use GrabPay Today and get 30% off at Starbucks when you spend a minimum of RM20",
    "salesImg": ImgLinks.grab_starbucks,
    "salesDescBgColour": ColourTheme.ewallet_Grab,
    "salesDescTextColour": ColourTheme.fontWhite,
    "salesDesc": [
      "This promotion is valid from 20/06/2021 until 31/07/2021. Availability of this promotion is only catered towards the first 8000 customers following a first come first serve basis.",

      "This promotion is available across all Starbucks branches except Starbucks KLIA. The terms and condition of this promotion is subject to change without any prior notice."
    ]
  },
  {
    "ewalletType": "TnG",
    "salesTitle": 'Up to Rm5 off with any purchase from Tealive with terms and conditions apply and not to mentioned that the discount',
    "salesImg": ImgLinks.tng_tealive,
    "salesDescBgColour": ColourTheme.ewallet_TnG,
    "salesDescTextColour": ColourTheme.fontWhite,
    "salesDesc": [
      "The availability of this promotion is limited towards beverage orders from the milk tea series and the smoothies series.",

      "This promotion is available across all Tealive outlets except Tealive KLCC. The terms and condition of this promotion is subject to change without any prior notice."
    ]
    
  },
  {
    "ewalletType": "Boost",
    "salesTitle": 'Get RM5 cashback when you spend at any Watson outlets using Boost E-wallet',
    "salesImg": ImgLinks.boost_watson,
    "salesDescBgColour": ColourTheme.ewallet_Boost,
    "salesDescTextColour": ColourTheme.fontWhite,
    "salesDesc": [
      "The usage of this promotion can only be applied from 13/04/2021 until 28/08/2021 through performing payment with a Boost E-wallet",

      "This promotion is available across all Watsons branches. The terms and condition of this promotion is subject to change without any prior notice."
    ]
  },
  {
    "ewalletType": "TnG",
    "salesTitle": "Enjoy RM5 off on your Pizza Hut's regular pizza when you spend using Touch n Go E-wallet",
    "salesImg": ImgLinks.tng_pizzaHut,
    "salesDescBgColour": ColourTheme.ewallet_TnG,
    "salesDescTextColour": ColourTheme.fontWhite,
    "salesDesc": [
      "The availability of this promotion is limited towards one order per user and per transaction within a single receipt",

      "This promotion is available across all Pizza Hut outlets except Pizza Hut Bukit Tinggi. The terms and condition of this promotion is subject to change without any prior notice."
    ]
  },
  {
    "ewalletType": "Boost",
    "salesTitle": "Hurry, get your RM5 cashback twice when you spend a minimum of RM50 with Boost E-wallet at TheStore outlet",
    "salesImg": ImgLinks.boost_theStore,
    "salesDescBgColour": ColourTheme.ewallet_Boost,
    "salesDescTextColour": ColourTheme.fontWhite,
    "salesDesc": [
      "The usage of this promotion can only be applied from 13/04/2021 until 28/08/2021 through performing payment with a Boost E-wallet",

      "This promotion is available across all TheStore outlets. The terms and condition of this promotion is subject to change without any prior notice."
    ]
  },
  {
    "ewalletType": "Grab",
    "salesTitle": "Use Grab today with Promo Code: THEMINESRM5 to get RM5 off your next Grab ride to The Mines Shopping Mall",
    "salesImg": ImgLinks.grab_theMines,
    "salesDescBgColour": ColourTheme.ewallet_Grab,
    "salesDescTextColour": ColourTheme.fontWhite,
    "salesDesc": [
      "The duration of this promotion would begin from 13/04/2021 until 28/08/2021. This promo code is only limited to the first 500 customers based on a first come first serve basis.",

      "This promotion is available throughout all active Grab user accounts within the Klang Valley. The terms and condition of this promotion is subject to change without any prior notice."
    ]
  },
];
