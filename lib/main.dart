import 'package:food_acer/Authentication/login-page.dart';
import 'package:food_acer/Authentication/register-page.dart';
import 'package:food_acer/Home/splash-page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_acer/Home/splash-page1.dart';
import 'package:food_acer/Pages/add-dishes.dart';
import 'package:food_acer/Pages/add-restaurant.dart';
import 'package:food_acer/Pages/cart-page.dart';
import 'package:food_acer/Pages/payment-method-page.dart';
import 'package:food_acer/Pages/restaurant-page.dart';
import 'package:food_acer/Profile/add-address.dart';
import 'package:food_acer/Profile/help-page.dart';
import 'package:food_acer/Profile/manage-address.dart';
import 'package:food_acer/Profile/manage-order.dart';
import 'package:food_acer/Profile/profile-page.dart';
import 'package:food_acer/data-provider.dart';
import 'package:provider/provider.dart';

void main() async{
  // to execute the app created by us
  // MyApp -> Object
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => DataProvider(),),
    ],
    child: MyApp(),
  ));
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
        '/splash': (context) => SplashPage1(),
        '/profile': (context) => ProfilePage(),
        '/addRestaurant' : (context) => AddRestaurant(),
        '/restaurant': (context) => RestaurantPage(),
        '/addDishes' : (context) => AddDishes(),
        '/cart' : (context) => CartPage(),
        '/manageAddress' : (context) => ManageAddressPage(),
        '/help': (context) => HelpPage(),
        '/addAddress' : (context) => AddAddressPage(),
        '/manageOrders' : (context) => ManageOrdersPage1(),
        '/paymentMethods' : (context) => PaymentMethodsPage(),
      },
      initialRoute: '/',
    );
  }
}