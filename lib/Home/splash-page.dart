import 'package:flutter/material.dart';
import 'package:food_acer/Util/constants.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  navigateToHome(BuildContext context) {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/login');
      if (Util.uid.isNotEmpty) {
        Navigator.pushReplacementNamed(context, '/restaurant');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(Util.uid.isNotEmpty) {
      Util.fetchUserDetails();
    }
    navigateToHome(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('hamburger.png'),
            SizedBox(height: 10,),
            Text("Your hunger point!", style: TextStyle(color: Colors.grey, fontSize: 16),)
          ],
        ),
      ),
    );
  }
}