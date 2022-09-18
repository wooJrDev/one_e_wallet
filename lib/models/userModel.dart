
class UserModel {
  String ?userId;
  String ?userEmail;
  String ?userName;
  double ?userUeAccBalance;
  double ?userBudgetLimit;
  String ?userBoostAcc;
  String ?userGrabAcc;
  String ?userTngAcc;
  bool ?isEmailVerified;
  // static String userBoostAcc = "boost_eliWoo";
  // static String userGrabAcc = "grab_eliWoo";
  // static String userTngAcc = "tng_kumarNazri";
  
  UserModel({
    this.userId,
    this.userEmail,
    this.userName,
    this.userUeAccBalance,
    this.userBudgetLimit,
    this.userBoostAcc,
    this.userGrabAcc,
    this.userTngAcc,
    this.isEmailVerified
  });

  List<String> getUserEwalletAcc() {
    return [userBoostAcc!, userGrabAcc!, userTngAcc!];
  }

  @override
  String toString() {
    return """userId: $userId, userEmail: $userEmail, userName: $userName, userUeAccBalance: 
    $userUeAccBalance, userBoostAcc: $userBoostAcc, userGrabAcc: $userGrabAcc, userTngAcc: $userTngAcc, isEmailVerified: $isEmailVerified""";
  }

}