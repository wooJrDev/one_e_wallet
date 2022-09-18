import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:one_e_sample/firebase/credentialDb.dart';
import 'package:one_e_sample/models/userModel.dart';
import 'package:one_e_sample/screen/authNavigation.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
} 

class App extends StatelessWidget {
  UserModel ?blank;
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel>.value(
      value: AuthService().user,
      initialData: blank!,
      child: MaterialApp(
        title: 'UE-wallet',
        theme: ThemeData(
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),            
            ),
          )
        ),
        home: AuthNavigation(),
      ),
    );
  }
}





