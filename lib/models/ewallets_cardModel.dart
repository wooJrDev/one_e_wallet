
class EwalletsCardModel {
  String eWalletUserId;
  String eWalletUserName;
  String eWalletType;
  double eWalletBalance;
  String eWalletEmail;
  String eWalletPassword;

  EwalletsCardModel({this.eWalletUserId, this.eWalletUserName, 
  this.eWalletType, this.eWalletBalance, this.eWalletEmail, this.eWalletPassword});

  List<String> ewalletTypeLst = ["Boost", "Grab", "Tng"];
}
