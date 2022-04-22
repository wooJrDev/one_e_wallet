import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReferenceDb {
  static final FirebaseAuth firebaseAuth2 = FirebaseAuth.instance;

  //Collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users') ;
  final CollectionReference ewalletUsersCollection = FirebaseFirestore.instance.collection('ewalletUsers') ;
  final CollectionReference ewalletTrxCollection = FirebaseFirestore.instance.collection('ewalletTrx') ;
}