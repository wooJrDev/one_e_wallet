import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:one_e_sample/screen/authenticate/loginPage.dart';
import 'package:one_e_sample/screen/authenticate/registerPage.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool displaySignInPage = true;
  void toggleAuthenticatePage() {
    setState(() {
      displaySignInPage = !displaySignInPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return displaySignInPage ? LoginPage(changeScreen: toggleAuthenticatePage) : RegisterPage(changeScreen: toggleAuthenticatePage,);

    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 500),
      reverse: displaySignInPage,
      transitionBuilder: (
        Widget child,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return SharedAxisTransition(
          child: child,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
        );
      },
      child: displaySignInPage ? LoginPage(changeScreen: toggleAuthenticatePage) : RegisterPage(changeScreen: toggleAuthenticatePage,),
    );

    // return AnimatedCrossFade(
    //   firstChild: SignInPage(changeScreen: toggleAuthenticatePage), 
    //   secondChild: RegisterPage(changeScreen: toggleAuthenticatePage,), 
    //   crossFadeState: displaySignInPage ? CrossFadeState.showSecond : CrossFadeState.showSecond, 
    //   duration: const Duration(seconds: 1),
    // );
  }
}