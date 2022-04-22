import 'package:flutter/material.dart';
import 'package:one_e_sample/models/userModel.dart';
import 'package:one_e_sample/screen/authenticate.dart';
import 'package:one_e_sample/screen/home/home_navigation.dart';
import 'package:provider/provider.dart';

class AuthNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final user = Provider.of<UserModel>(context);
    
    print('Test user: ${user.toString()}');

    if (user != null && user.isEmailVerified == false) {
      return Authenticate();
    } else if (user != null && user.isEmailVerified == true) {
      return HomeNavigation();
    } else {
      return Authenticate();
    }

    // return user == null ? Authenticate() : HomeNavigation();

    // return user == null ? Authenticate() : HomeNavigation();
  }
}