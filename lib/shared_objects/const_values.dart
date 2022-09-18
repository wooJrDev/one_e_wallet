//Value for all text style properties for login and register page
import 'package:flutter/material.dart';
import 'package:one_e_sample/models/ewallets_cardModel.dart';

class ImgLinks {
  static const tng_tealive = 'assets/img/tng_tealive.png';
  static const tng_pizzaHut = 'assets/img/tng_pizzaHut.jpg';
  static const grab_starbucks = 'assets/img/grab_starbucks.jpg';
  static const grab_theMines = 'assets/img/grab_theMines.png';
  static const boost_watson = 'assets/img/boost_watson.jpg';
  static const boost_theStore = 'assets/img/boost_theStore.jpg';
  
  static const profile_userAvatar = 'assets/img/profile_userAvatar.png';
  static const profile_plainAvatar = 'assets/img/profile_plainavatar.png';
  static const profile_logo = 'assets/logo/fyplogo.png';
}

class TextFormValues {
  static const double textFormFont = 22;
  static const double textFormDropDownFont = 21;
  static const double textFormErrorMsgFont = 18;
  static const double textFormTitleFont = 18;
  static const double spaceBetweenTextForm = 20;
  static const double spaceBetweenFormTitle = 5;
}

class ColourTheme {
  // var mainAppColour = Colors(0xFF25509E);
  static const mainAppColour = Color(0xFF25509E);
  static const mainAccentColour = Color(0xFFC0722C);
  static const lightBackground = Color(0xFFdDE4FF);
  static const cashIn = Color(0xFF41C005);
  static const cashOut = Color(0xFFC00505);
  static const toggle_green = Color(0xFF85E359);
  static const toggle_red = Color(0xFFE35959);
  static const fontWhite = Color(0xFFFFFFFF);
  static const fontLightGrey = Color(0xFF9E9E9E);
  static const fontGrey = Color(0xFF878787);
  static const fontDarkGrey = Color(0xFF545454);
  static const fontBlue = Color(0xFF2F80ED);
  static const fontLightBlue = Color(0xFF5899D0);
  static const fontBrightBlue = Color(0xFF3A61F9);
  static const fontRed = Color(0xFFF44336);
  static const fontBrightRed = Color(0xFFF33223);
  static const orange = Color(0xFFFBB856);
  static const darkOrange = Color(0xFFE4572E);
  static const ewallet_Grab = Color(0xFF22B21E);
  static const ewallet_Grab_Accent = Color(0xFF29D824);
  static const ewallet_TnG = Color(0xFF216EC8);
  static const ewallet_TnG_Accent = Color(0xFF2B8CFF);
  static const ewallet_Boost = Color(0xFFC82B21);
  static const ewallet_Boost_Accent = Color(0xFFFF362B);
  static const inkWellBlue = Color(0x282F80ED);
  static const inkWellDarkBlue = Color(0x6625509E);
  static const graphBgColour_darkBlackBlue = Color(0xFF232D37);
  static const graphGridColour = Color(0xFF37434D);
  static const graphLabelColour = Color(0xFF68737D);

  static Color getEwalletTypeMainColour(EwalletsCardModel ewallet) {
    Color ?ewalletCardColour;
    if (ewallet.eWalletType == "Grab") {
      ewalletCardColour = ewallet_Grab;
    } else if (ewallet.eWalletType == "Boost") {
      ewalletCardColour = ewallet_Boost;
    } else if (ewallet.eWalletType == "Tng") {
      ewalletCardColour = ewallet_TnG;
    }
    return ewalletCardColour!;
  }

  static Color getEwalletTypeAccentColour(EwalletsCardModel ewallet) {
    Color ?ewalletCardColour;
    if (ewallet.eWalletType == "Grab") {
      ewalletCardColour = ewallet_Grab_Accent;
    } else if (ewallet.eWalletType == "Boost") {
      ewalletCardColour = ewallet_Boost_Accent;
    } else if (ewallet.eWalletType == "Tng") {
      ewalletCardColour = ewallet_TnG_Accent;
    }
    return ewalletCardColour!;
  }

}

class GeneralPositioning {
  static const double mainPadding = 30;
  static const double mainMediumPadding = 25;
  static const double mainSmallPadding = 20;
  static const double salesCard_TextPadding_vert = 10;
  static const double salesCard_TextPadding_horz = 15;
  static const double homePage_spaceSections = 40;
  static const double homePage_spaceBetween_CardAndTitle = 15;
  static const double ewalletReloadPage_spaceBetween_title = 20;
  static const double ewalletReloadPage_quickReloadButton_horzPadding = 15;
  static const double ewalletReloadPage_quickReloadButton_vertPadding = 10;
}

class ShapeBorderRadius {
  static const double homeCardRadius = 25;
  static const double generalCardRadius = 15;
  static const double textFormField = 15;
  static const double roundedeElevatedButton = 25;
  static const double boxElevatedButton = 10;
  static const double roundedEwalletReloadCard = 40;
  static const double roundedEwalletReloadCard_medium = 25;
  static const double budgetTrackingInfo = 25;
  static const double budgetTrackingUpdateCard = 25;
  static const double reportAmountCard = 15;
}

class TextFontStyle {
  //* Default fontfamily is Roboto
  //Miscellaneous fontsize
  static const double seeAllButton = 15;
  static const double floatingActionButton = 22;
  static const double salesCard_salesTitle = 18;
  static const double profile_listTileTitle = 17;
  static const double appBar_largeTitle = 30;
  static const double appBar_mediumTitle = 22;

  //Login page fontsize
  static const double loginPage_titleFontSize = 27;
  static const double loginPage_textFormField = 22;
  static const double loginPage_loginButton = 22;
  static const double loginPage_registerMessage = 15;

  //Register page fontsize
  static const double registerPage_titleFontSize = 27;
  static const double registerPage_textFormField = 22;
  static const double registerPage_registerButton = 22;

  //Home page fontsize
  static const double sectionTitle = 22;
  static const double homePage_ewalletCard_AccountName = 22;
  static const double homePage_ewalletCard_AccountName_title = 16;
  static const double homePage_ewalletCard_balance = 35;
  static const double homePage_ewalletCard_balance_title = 16;
  static const double homePage_ewalletCard_eWalletType = 22;
  static const double homePage_ewalletCard_emptyMessage = 20;
  
  //IndvSalesPage fontsize
  static const double indvSalesPage_title = 20;
  static const double indvSalesPage_tncTitle = 20;
  static const double indvSalesPage_tncDesc = 16;
  
  //History page fontsize
  static const double historyPage_listTile_title = 18;
  static const double historyPage_listTile_subtitle = 14;
  static const double historyPage_listTile_trailing = 18;
  static const double listTile_iconSize = 35;
  static const double listTile_faIconSize = 28;
  
  //TrxPopUpDialog fontsize
  static const double trxPopUpDialog_trxTitle = 30;
  static const double trxPopUpDialog_subtitle_general = 18;
  static const double trxPopUpDialog_subtitle_trxmount = 25;
  static const double trxPopUpDialog_button = 18;
  
  //User profil page fontsize
  static const double userProfilePage_mainTitle = 22;
  static const double userProfilePage_subTitle = 20;
  static const double userProfilePage_username = 22;
  static const double userProfilePage_email = 22;
  
  //Ewallets page fontsize
  static const double ewalletCard_eWalletType = 25;
  static const double ewalletCard_AccountName = 25;
  static const double ewalletCard_AccountName_title = 16;
  static const double ewalletCard_balance = 32;
  static const double ewalletCard_balance_title = 16;
  static const double ewalletCard_reloadButton = 22;
  static const double ewalletCard_emptyMessage = 22;

  //Ewallets detail page fontsize
  static const double ewalletDetailPage_emptyTrxMsg = 20;

  //Add Ewallets page fontsize
  static const double addEwalletPage_textForm = 22;

  //Reload Ewallets page fontsize
  static const double ewalletReloadPage_title = 32;
  static const double ewalletReloadPage_ewalletBalance = 32;
  static const double ewalletReloadPage_ewalletDesc = 18;
  static const double ewalletReloadPage_ewalletReloadAmount = 30;
  static const double ewalletReloadPage_quickReloadTitle = 22;
  static const double ewalletReloadPage_quickReloadOptionButton = 25;
  static const double ewalletReloadPage_quickReloadConfirmButton = 22;
  static const double ewalletReloadPage_errorMessage = 18;

  //Reload UEwallet page fontsize
  static const double uewalletReloadPage_slideToConfirmBtn = 18;

  //Budget Tracking page fontsize
  static const double budgetTrackingPage_graphTitle = 26;
  static const double budgetTrackingPage_budgetInfoTitle = 14;
  static const double budgetTrackingPage_budgetInfoAmount = 26;
  static const double budgetTrackingPage_budgetLimitTitle = 22;
  static const double budgetTrackingPage_budgetLimitAmount = 32;
  static const double budgetTrackingPage_updateBudgetButton = 22;
  static const double budgetTrackingPage_errorMessage = 18;

  //Expenditure Report page fontsize
  static const double reportPage_expenditureTitle = 20;
  static const double reportPage_expenditureAmount = 28;
  
  //Payment page fontsize
  static const double paymentPage_timelineDesc = 14;
  static const double paymentPage_selectEwalletTitle = 20;
  static const double paymentPage_scanTitle = 30;
  static const double paymentPage_payAmount_title = 20;
  static const double paymentPage_payAmount_detail = 30;
  static const double paymentPage_payAmount_payInfo_Title = 20;
  static const double paymentPage_payAmount_payInfo_ewalletUsed = 18;
  static const double paymentPage_payAmount_payInfo_ewalletUsedDetail = 18;
  static const double paymentPage_payAmount_payInfo_payingTo = 18;
  static const double paymentPage_payAmount_payInfo_payingToDetail = 22;
  static const double paymentPage_payAmount_confirmButton = 20;


  static const double textButton = 22;
  
  static customFontStyle(double fontSize, {FontWeight ?fontWeight, Color ?color}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color ?? ColourTheme.fontWhite,
    );
  }
}