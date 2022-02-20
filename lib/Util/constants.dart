import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_acer/Model/user-details.dart';

class Util{
  static AppUser? appUser;
  static var uid = FirebaseAuth.instance.currentUser != null? FirebaseAuth.instance.currentUser!.uid : "";
  static var USER_COLLECTION = 'users';
  static var RESTAURANT_COLLECTION = 'restaurants';
  static var DISH_COLLECTION = 'dishes';
  static var CART_COLLECTION = 'cart';
  static var ADDRESS_COLLECTION = 'addresses';
  static String? imageLink;
  static fetchUserDetails() async{
    print('Fetching user details');
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    DocumentSnapshot document = await FirebaseFirestore.instance.collection(USER_COLLECTION).doc(uid).get();
    print('user details fetched');
    Util.appUser = AppUser();
    Util.appUser!.uid = document.get('uid').toString();
    Util.appUser!.name = document.get('name').toString();
    Util.appUser!.email = document.get('email').toString();
    Util.appUser!.phoneNumber = document.get('phoneNumber').toString();
    Util.appUser!.imageURL = document.get('imageURL').toString();
    Util.appUser!.isAdmin = document.get('isAdmin');
  }
  static Route getAnimatedRoute(Widget page){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(
          // begin: Offset(0, 1),  // 0 screen right, 1 page down
          begin: Offset(3, 0),  // 3 screen right, 4 pages down
          end: Offset(0, 0),
        );
        var curveTween = CurveTween(curve: Curves.ease);

        return SlideTransition(
          position: animation.drive(curveTween).drive(tween),
          child: child,
        );
      },
    );
  }
}

class ShowSnackBar{
  String? message;
  ShowSnackBar({required BuildContext context, @required this.message}){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message!)));
  }
}