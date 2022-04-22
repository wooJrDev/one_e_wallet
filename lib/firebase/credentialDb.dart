
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_e_sample/firebase/database.dart';
import 'package:one_e_sample/models/userModel.dart';

class AuthService {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users') ;
  static User registerdUser;
  //Create UserModel object based on login/register user
  // UserModel _userFromFirebaseUser(User user, {String userBoostAcc, String userGrabAcc, String userTngAccount}) {
  //   //Check if created user is successful, 
  //   //if yes, create a usermodel object, else return an empty object
  //   // return user != null ? UserModel(userId: user.uid,) : null;
  //   return user != null ? UserModel(userId: currentUser.uid ?? user.uid, userEmail: currentUser.email ?? user.uid, userName: currentUser.displayName ?? user.displayName, userBoostAcc: userBoostAcc, userGrabAcc: userGrabAcc,  userTngAcc: userTngAccount) : null;
  //   //? incomplete UserModel object, missing the username and email
  // }
  UserModel _userFromFirebaseUser(User user, {String userBoostAcc, String userGrabAcc, String userTngAccount}) {
    //Check if created user is successful, 
    //if yes, create a usermodel object, else return an empty object
    // return user != null ? UserModel(userId: user.uid,) : null;
    return user != null ? UserModel(userId: user.uid, userEmail: user.email, userName: user.displayName, userBoostAcc: userBoostAcc, userGrabAcc: userGrabAcc,  userTngAcc: userTngAccount, isEmailVerified: user.emailVerified) : null;
  }

  //auth change user stream
  Stream<UserModel> get user {  
    var usermodel =  _firebaseAuth.userChanges()
      .map( (auth) => _userFromFirebaseUser(auth) );
    return usermodel;
  }

  Future authSignIn({@required String email, @required String password}) async {
    try {
      UserCredential authResult;
      authResult = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User user = authResult.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Register with email, username & password
  Future authRegister({@required String email, @required String password, @required String username}) async {
    try {
      registerdUser = null;
      UserCredential authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await authResult.user.sendEmailVerification();

      await authResult.user.updateProfile(displayName: username);
      User user =  authResult.user;
      registerdUser =  authResult.user;
      //Create a new user document
      await DatabaseService().createUser(userId: user.uid, userEmail: user.email, username: username);
      
      return _userFromFirebaseUser(user);

    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Update Password
  Future<String> updatePassword({@required String email, @required String oldPassword, @required String newPassword}) async {
    try {
      User user = _firebaseAuth.currentUser;
      AuthCredential testCredential = EmailAuthProvider.credential(email: email, password: oldPassword);
      await user.reauthenticateWithCredential(testCredential);
      if (oldPassword == newPassword) {
        throw FirebaseAuthException(message: null, code: 'reuse-oldPassword');
      }
      await user.updatePassword(newPassword);
      return null;
    } on FirebaseAuthException catch (e) {

      // print('Error code: ${e.code}');
      // print(e.toString());

      if (e.code == "wrong-password") {
        return 'Invalid old password';
      }

      if (e.code == "weak-password") {
        return 'New password strength is weak';
      }

      if (e.code == "too-many-requests") {
        return 'Too many frequent request, please try again later';
      }

      if (e.code == "reuse-oldPassword") {
        return 'New password cannot be the same as the old password';
      }

    } catch (e) {
      return '';
    }
  }

  //Sign out
  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}