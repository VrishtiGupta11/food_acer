import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessPage extends StatefulWidget {

  String title;
  String message;
  bool flag;

  SuccessPage({Key? key, required this.message, required this.title, required this.flag}) : super(key: key);

  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              child: Text(widget.title, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),),
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blueGrey, Colors.lightGreen, ],
                  // colors: [Colors.green, Colors.white],
                  tileMode: TileMode.mirror,
                ).createShader(bounds);
              },
            ),

            widget.flag
                // ? Lottie.asset('assets/tick.json', width: 200)
            ? Icon(Icons.check, color: Colors.green, size: 80,)
                : Icon(Icons.error, color: Colors.redAccent, size: 80,),
            SizedBox(height: 12,),

            Divider(),
            Text(widget.message, style: TextStyle(color: Colors.blueGrey),),
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 35,
              width: 100,
              child: TextButton(
                onPressed: (){
                  Navigator.pushReplacementNamed(context, '/restaurant');
                },
                child: Text('Home', style: TextStyle(color: Colors.white),),
                style: TextButton.styleFrom(backgroundColor: Colors.green, elevation: 5),
              ),
            ),

          ],
        ),
      ),
    );
  }
}