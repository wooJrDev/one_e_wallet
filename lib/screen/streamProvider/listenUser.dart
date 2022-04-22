import 'package:flutter/material.dart';
import 'package:one_e_sample/models/userModel.dart';
import 'package:provider/provider.dart';

class ListenUser extends StatefulWidget {
  @override
  _ListenUserState createState() => _ListenUserState();
}

class _ListenUserState extends State<ListenUser> {
  @override
  Widget build(BuildContext context) {
    try {
      final dbResult = Provider.of<UserModel>(context);
      print("print: ${dbResult.toString()}");
    } catch (e) {
      print(e.toString());
    }
    return Container( 
    );
  }
}
