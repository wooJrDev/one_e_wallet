import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:one_e_sample/models/ewallets_cardModel.dart';
import 'package:provider/provider.dart';

class ListenDb extends StatefulWidget {
  @override
  _ListenDbState createState() => _ListenDbState();
}

class _ListenDbState extends State<ListenDb> {
  @override
  Widget build(BuildContext context) {

    final ewalletList = Provider.of<List<EwalletsCardModel>>(context) ?? [];
    if (ewalletList == []) {
      return Container(
        child: Text('lol'),
      );
    }
    else {
      // print("docs:  ${dbResult.docs}");
      // for (var doc in dbResult.docs) {
        print('making sure its working');
      //   print(doc.data());
      // }

      // print(dbResult[0].eWalletUserName);
      ewalletList.forEach((element) {
        print('test: ${element.eWalletUserId}');
        print('test: ${element.eWalletUserName}');
        print('test: ${element.eWalletType}');
        print('test: ${element.eWalletBalance}');
       });
      // print(dbResult[1].eWalletType);
    }
    return Container(

    );
  }
}