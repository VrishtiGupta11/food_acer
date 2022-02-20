import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_acer/Util/constants.dart';

class SplashPage1 extends StatelessWidget {
  const SplashPage1({Key? key}) : super(key: key);

  navigateToHome(BuildContext context) {
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/restaurant');
    });
  }

  @override
  Widget build(BuildContext context) {
    Util.fetchUserDetails();
    navigateToHome(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}