import 'package:food_acer/Authentication/login-page.dart';
import 'package:food_acer/Authentication/register-page.dart';
import 'package:food_acer/Home/splash-page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_acer/Pages/add-restaurant.dart';
import 'package:food_acer/Pages/restaurant-page.dart';

void main() async{
  // to execute the app created by us
  // MyApp -> Object
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: MyHomePage(),
      routes: {
        '/' : (context) => SplashPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/addRestaurant' : (context) => AddRestaurant(),
        '/restaurant': (context) => RestaurantPage(),
      },
      initialRoute: '/',
    );
  }
}