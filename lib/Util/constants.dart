import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_acer/Model/user-details.dart';

class Util{
  static AppUser? appUser;
  static var uid = FirebaseAuth.instance.currentUser != null? FirebaseAuth.instance.currentUser!.uid : "";
  static var USER_COLLECTION = 'users';
  static var RESTAURANT_COLLECTION = 'restaurants';

  static String? imageLink;
  static fetchUserDetails() async{
    print('Fetching user details');
    DocumentSnapshot document = await FirebaseFirestore.instance.collection(USER_COLLECTION).doc(uid).get();
    Util.appUser = AppUser();
    Util.appUser!.uid = document.get('uid').toString();
    Util.appUser!.name = document.get('name').toString();
    Util.appUser!.email = document.get('email').toString();
    Util.appUser!.phoneNumber = document.get('phoneNumber').toString();
    Util.appUser!.imageURL = document.get('imageURL').toString();
    Util.appUser!.isAdmin = document.get('isAdmin');
  }
}

class ShowSnackBar{
  String? message;
  ShowSnackBar({required BuildContext context, @required this.message}){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message!)));
  }
}