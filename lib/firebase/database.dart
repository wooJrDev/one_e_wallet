import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one_e_sample/firebase/dateManagement.dart';
import 'package:one_e_sample/models/ewallets_cardModel.dart';
import 'package:one_e_sample/models/trx_cardModel.dart';
import 'package:one_e_sample/models/userModel.dart';

class DatabaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //Collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users') ;
  final CollectionReference ewalletUsersCollection = FirebaseFirestore.instance.collection('ewalletUsers') ;
  final CollectionReference ewalletTrxCollection = FirebaseFirestore.instance.collection('ewalletTrx') ;

  // final User currentUser = 

  List<String> finalEmailList;

  ///* 4 types of transactions
  /// [Reload UEwallet] => using visa/fpx/pin to reload ue wallet [trxType: Reload]
  /// [Using UEwallet] => using ue wallet to reload individual e-wallet (grab, tng, boost) [trxtype: Payment]
  /// [Reload Ewallet] => using ue wallet to reload individual e-wallet (grab, tng, boost) [trxtype: Reload]
  /// [Using Ewallet] => using individual e-wallet (grab, tng, boost) to perform merchant payment [trxtype: Payment]

  ///Insert, Update users collection(table)
  Future createUser({String boostAcc, String grabAcc, String tngAcc, String ueAccBalance, String userBudgetLimit, String userId, String userEmail, String username}) async {
    return await userCollection.doc(userId).set({
      'userBoostAccount': boostAcc ?? "",
      'userGrabAccount': grabAcc ?? "",
      'userTngAccount':  tngAcc ?? "",
      'userUEwalletBalance':  ueAccBalance ?? 0,
      'userBudgetLimit': userBudgetLimit ?? 0,
      'userEmail':  userEmail ?? "fallbackemail@gmail.com",
      'userName':  username ?? "fallback username",
      'userId':  userId ?? "fallbackId",
    }, SetOptions(merge: true));
  }

  //! TODO: Make the parameters required
  ///Insert, Update ewalletUsers collection(table)
  Future<bool> createEwalletTrx({String trxType, String trxMethod, String trxRecipient, 
  double trxAmount, String userId, DateTime dateTime}) async {
    var docId = "TRX_" + ewalletTrxCollection.doc().id.substring(0, 10).toUpperCase();
    try {
      await ewalletTrxCollection.doc(docId).set({
        'trxType': trxType,
        'trxMethod': trxMethod,
        'trxRecipient': trxRecipient,
        'trxAmount': trxAmount,
        'trxId': docId,
        'userId': userId,
        'trxDateTime': dateTime, 
      });
      return true;
    } catch(e) {
      print(e.toString());
      return false;
    }
  }

  Future<TrxCardModel> createEwalletTrxWithReceipt({String trxType, String trxMethod, 
  String trxRecipient, double trxAmount, String userId, DateTime dateTime}) async {
    var docId = "TRX_" + ewalletTrxCollection.doc().id.substring(0, 10).toUpperCase();
    try {
      await ewalletTrxCollection.doc(docId).set({
        'trxType': trxType,
        'trxMethod': trxMethod,
        'trxRecipient': trxRecipient,
        'trxAmount': trxAmount,
        'trxId': docId,
        'userId': userId,
        'trxDateTime': dateTime, 
      });
      return TrxCardModel(
        trxType: trxType,
        trxMethod: trxMethod,
        trxRecipient: trxRecipient,
        trxAmount: trxAmount,
        trxId: docId,
        trxDateTime: DateFormat( "dd/MM/y hh:mm a" ).format( dateTime ).toString()
        // trxDateTime: DateFormat( "dd/MM/y hh:mm a" ).format( dateTime.add( Duration( hours: 8 ) ) ).toString()
      );
    } on FirebaseException catch(e) {
      return null;
    }
  }

  ///Insert, Update ewalletUsers collection(table)
  Future updateEwalletUsers() async {
    return await ewalletUsersCollection.doc("grab_rayMak").set({
      'ewalletUsername': "Ray Mak",
      'ewalletType': "Grab",
      'ewalletBalance': 340.00,
      'ewalletEmail': "raymak@gmail.com",
      'ewalletPassword': "ray1234",
      'ewalletUserId': "grab_rayMak",
    });
  }

  ///Insert, Update UE Account or ewallet account balance collection(table)
  Future updateEwalletBalance({double ewalletBalance, CollectionReference dbCollection, String userId, String fieldName}) async {
    //* if mainEwallet = true, reload to UE Account, if false, reload to individual ewallet Account (Grab, Boost Tng) 
    try {
      await dbCollection.doc(userId).update({
        fieldName: FieldValue.increment(ewalletBalance), //* Allows incrementing the value without overriding the previous balance
      });
      return true;
    } on FirebaseException catch (e) {
      print(e.toString());
      return false;
    }
  }

  /// Update UE Account budget limit
  Future updateBudgetLimit( { @required double budgetAmount} ) async {
    //* if mainEwallet = true, reload to UE Account, if false, reload to individual ewallet Account (Grab, Boost Tng) 
    try {
      await userCollection.doc(_firebaseAuth.currentUser.uid).update({
        "userBudgetLimit": budgetAmount,
      });
      return true;
    } on FirebaseException catch (e) {
      print(e.toString());
      return false;
    }
  }
  

  ///Get firestore ewalletType field based on the given ewalletType
  String getDbEwalletAccType(String ewalletType) {
    String dbEwalletField;
    if (ewalletType == "Boost") {
      dbEwalletField = "userBoostAccount";
    } else if (ewalletType == "Grab") {
      dbEwalletField = "userGrabAccount";
    } else if (ewalletType == "Tng") {
      dbEwalletField = "userTngAccount";
    }
    return dbEwalletField;
  }

  ///Authenticate ewalletAcc credential and return the ewalletId
  Future<String> authEwalletUserId({@required String email, @required String password, @required String ewalletType}) async{
    QuerySnapshot qShot = await ewalletUsersCollection
      .where("ewalletType", isEqualTo: ewalletType)
      .where("ewalletEmail", isEqualTo: email)
      .where("ewalletPassword", isEqualTo: password).get();
    if (qShot.docs.isEmpty) {
      return null; // Account does not exist
    } else {
      final ewalletUserId = qShot.docs.map((doc) {
        return "${doc.data()['ewalletUserId']}";
      }).reduce((value, element) => null);
      return ewalletUserId;
    }
  }

  ///Add/Remove a particular Ewallet account
  Future<bool> manageEwalletAcc({@required String ewalletType, String ewalletUserId}) async {
    try {
      User user = _firebaseAuth.currentUser;
      await userCollection.doc(user.uid).update({
        '$ewalletType':  ewalletUserId ?? "" //ewalletType = boostAcount/grabAccount/tngAccount
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  ///Get all added ewallet account (Eg: Grab, Boost Tng)
  Stream<List<EwalletsCardModel>> getEwalletUsers({List<String> ewalletUserId, bool isSpecificUserId = false}) async*{ //*returning list instead of querysnapshot
    try {
      List<String> ewalletAccLst;
      if (isSpecificUserId) {
        ewalletAccLst = ewalletUserId;
      } else {
        ewalletAccLst = await queryUserEwalletAcc() ?? [];
      }
      yield* ewalletUsersCollection.where("ewalletUserId", whereIn: ewalletAccLst).snapshots().map(_ewalletAccLstFromSnapshot);
    } catch (e) {
      print(e.toString());
      yield null;
    }
  }

  Future<bool> authEwalletAvailableStatus({String ewalletUserId, String ewalletType}) async {
    String ewalletTypeFieldName = getDbEwalletAccType(ewalletType);

    QuerySnapshot queryResult = await userCollection.where(ewalletTypeFieldName, isEqualTo: ewalletUserId).get();
    if (queryResult.docs.isEmpty) {
      return true; //*E-wallet account has not been used
    }else {
      return false; //*E-wallet account has been used
    }
  }

  ///List of Ewallet Account from snapshot
  List<EwalletsCardModel> _ewalletAccLstFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => EwalletsCardModel(
      eWalletUserId: doc.data()['ewalletUserId'],
      eWalletUserName: doc.data()['ewalletUsername'],
      eWalletType: doc.data()['ewalletType'],
      eWalletBalance: double.parse(doc.data()['ewalletBalance'].toString()),
    )).toList();
  }

  /// UserModel from snapshot
  UserModel _userModelFromSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      userId: snapshot.data()['userId'],
      userName: snapshot.data()['userName'],
      userEmail: snapshot.data()['userEmail'],
      userUeAccBalance: double.parse(snapshot.data()['userUEwalletBalance'].toString()),
      userBudgetLimit:double.parse(snapshot.data()['userBudgetLimit'].toString()) ,
      userBoostAcc: snapshot.data()['userBoostAccount'] ?? "",
      userGrabAcc: snapshot.data()['userGrabAccount'] ?? "",
      userTngAcc: snapshot.data()['userTngAccount'] ?? "",
    );
  }

  ///Get transactions records based on the added E-wallet accounts & UE-wallet account
  Stream<List<TrxCardModel>> getEwalletTrx() async* {
    //allTrxUserId would gather the user id of (boost, grab, tng) and UE wallet user id
    List<String> allTrxUserId = await queryUserEwalletAcc();
    allTrxUserId.removeWhere((element) => element.isEmpty);
    allTrxUserId.add(_firebaseAuth.currentUser.uid);
    yield* ewalletTrxCollection.where('userId', whereIn: allTrxUserId).snapshots().map(_ewalletTrxLstFromSnapshot); 
  }

  ///List of Ewallet Account from snapshot
  List<TrxCardModel> _ewalletTrxLstFromSnapshot(QuerySnapshot snapshot) {
    try {
      if (snapshot.docs.isEmpty) {
        return [];
      } else {
        final testLst =  snapshot.docs.map((doc) => TrxCardModel(
          trxId: doc.data()['trxId'],
          trxType: doc.data()['trxType'],
          trxMethod: doc.data()['trxMethod'],
          trxRecipient: doc.data()['trxRecipient'],
          trxAmount: double.parse(doc.data()['trxAmount'].toString()),
          trxDateTime: DateFormat('dd/MM/y hh:mm a')
            .format( doc.data()['trxDateTime'].toDate() ).toString(),
        )).toList();
        return testLst;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<UserModel> get getUserDetail async*{
    // return userCollection.where(FieldPath.documentId, isEqualTo: "userId2").snapshots();
    User user = FirebaseAuth.instance.currentUser;
    yield* userCollection.doc(user.uid).snapshots().map((doc) => _userModelFromSnapshot(doc));
  }

  Future<List<String>> queryUserEwalletAcc() async {
    User user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot qshot = await userCollection.doc(user.uid).get();
    List<String> userDetails = [];
    if (qshot.exists) {
      userDetails.add(qshot.data()['userBoostAccount']);
      userDetails.add(qshot.data()['userGrabAccount']);
      userDetails.add(qshot.data()['userTngAccount']);
    }
    return userDetails;
  }

  Future<List<TrxCardModel>> getEwalletExpenses() async {
    List<String> ewalletAccLst = await queryUserEwalletAcc() ?? [];
    final querySnap = await ewalletTrxCollection.where("userId", whereIn: ewalletAccLst).where("trxType", isEqualTo: "Payment").get();
    return _ewalletTrxLstFromSnapshot( querySnap );
  }

  Future<bool> performReloadEwalletTrx({double reloadedAmount, EwalletsCardModel ewalletDetail}) async {
    bool _updateStatus;
    DateTime trxDateTime = DateTime.now();
    try {
      //* Update UE Account on deducted balance
      _updateStatus = await updateEwalletBalance(dbCollection: userCollection, ewalletBalance: -reloadedAmount, 
      fieldName: "userUEwalletBalance", userId: _firebaseAuth.currentUser.uid);
      //* Update Ewallet account reloaded balance
      _updateStatus = await updateEwalletBalance(dbCollection: ewalletUsersCollection, ewalletBalance: reloadedAmount, 
      fieldName: "ewalletBalance", userId: ewalletDetail.eWalletUserId);
      //* Create Trx for UE wallet (Payment Trx)
      _updateStatus = await createEwalletTrx(userId: _firebaseAuth.currentUser.uid, trxType: "Payment", 
      trxMethod: "UE Wallet", trxRecipient: ewalletDetail.eWalletUserId, trxAmount: reloadedAmount, dateTime: trxDateTime);
      //* Create Trx for Ewallet (Reload Trx)
      _updateStatus = await createEwalletTrx(userId: ewalletDetail.eWalletUserId, trxType: "Reload", 
      trxMethod: "UE Wallet", trxRecipient: ewalletDetail.eWalletType, trxAmount: reloadedAmount, dateTime: trxDateTime);
      return _updateStatus;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> performReloadUEwalletTrx({@required double reloadedAmount, @required String paymentMethod}) async {
    bool _updateStatus;
    DateTime trxDateTime = DateTime.now();
    try {
       //* Update UE Account on reloaded balance
      _updateStatus = await updateEwalletBalance(dbCollection: userCollection, ewalletBalance: reloadedAmount, 
      fieldName: "userUEwalletBalance", userId: _firebaseAuth.currentUser.uid);
      //* Create Trx for UE wallet (Payment Trx)
      _updateStatus = await createEwalletTrx(userId: _firebaseAuth.currentUser.uid, trxType: "Reload", 
      trxMethod: "$paymentMethod", trxRecipient: "UE Wallet", trxAmount: reloadedAmount, dateTime: trxDateTime);
      return _updateStatus;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<TrxCardModel> performPayment({double paymentAmount, EwalletsCardModel ewalletDetail, String merchantName}) async{
    bool _updateStatus;
    TrxCardModel trxDetail;
    DateTime trxDateTime = DateTime.now();
    try {
      //* Update E-wallet account on deducted balance
      _updateStatus = await updateEwalletBalance(dbCollection: ewalletUsersCollection, ewalletBalance: -paymentAmount,
      fieldName: "ewalletBalance", userId: ewalletDetail.eWalletUserId);

      //* Create Trx for E-wallet payment (Payment Trx)
      trxDetail = await createEwalletTrxWithReceipt(userId: ewalletDetail.eWalletUserId, trxType: "Payment", 
      trxMethod: ewalletDetail.eWalletType, trxRecipient: merchantName, trxAmount: paymentAmount, dateTime: trxDateTime);

      return _updateStatus == true && trxDetail != null ? trxDetail : null;
    } catch (e) {
      print(e.toString());
      return null;
    }
    
  }

  // testFakeTrx() async {
  //   await createEwalletTrx(trxType: "Payment", trxAmount: 13, trxMethod: "Grab", trxRecipient: "Tealive", dateTime: DateTime.now(), userId: "grab_eliWoo");
  // }

  Stream<List<TrxCardModel>> getDailyTrx() async*{
    try {

      Date date = Date();
      List<String> allTrxUserId = await queryUserEwalletAcc();
      allTrxUserId.removeWhere((element) => element.isEmpty);

      yield* ewalletTrxCollection
        .where("trxType", isEqualTo: "Payment")
        .where("userId", whereIn: allTrxUserId)
        .where("trxDateTime", isGreaterThanOrEqualTo: date.startOfDay.subtract( Duration( hours: 0 ) ) ) //Start of day
        .where("trxDateTime", isLessThan: date.endOfDay.add( Duration( hours: 0 ) ) ) //End of day
        .snapshots().map( _ewalletTrxLstFromSnapshot );

    } catch (e) {
      yield null ;
      print(e.toString());
    }
  }


  Stream<List<TrxCardModel>> getWeeklyTrx() async*{
    // Accepted Date Format
    //* "2012-02-27 13:27:00"
    //* "2021-05-27"
    //* "20120227 13:27:00"

    try {
    Date date = Date();
    List<String> allTrxUserId = await queryUserEwalletAcc();
    allTrxUserId.removeWhere((element) => element.isEmpty);
      yield* ewalletTrxCollection
        .where("trxType", isEqualTo: "Payment")
        .where("userId", whereIn: allTrxUserId)
        .where("trxDateTime", isGreaterThanOrEqualTo: date.startOfWeek.subtract( Duration( hours: 0) ) ) //Start Date
        .where("trxDateTime", isLessThanOrEqualTo: date.endOfWeek.add( Duration( hours: 0 ) ) ) //End Date
        .snapshots().map( _ewalletTrxLstFromSnapshot );
    } catch (e) {
      print(e.toString());
    }
    
  }

  Stream<List<TrxCardModel>> getMonthlyTrx() async*{
    try {

      Date date = Date();
      List<String> allTrxUserId = await queryUserEwalletAcc();
      allTrxUserId.removeWhere((element) => element.isEmpty);

      yield* ewalletTrxCollection
        .where("trxType", isEqualTo: "Payment")
        .where("userId", whereIn: allTrxUserId)
        .where("trxDateTime", isGreaterThanOrEqualTo: date.startOfMonth().subtract( Duration( hours: 0 ) ) ) //Start Date
        .where("trxDateTime", isLessThanOrEqualTo: date.endOfMonth.add( Duration( hours: 0 ) ) ) //End Date
        .snapshots().map( _ewalletTrxLstFromSnapshot );

    } catch (e) {
      yield null ;
      print(e.toString());
    }
  }
}