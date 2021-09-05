import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_acer/Util/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  void authenticateUser(BuildContext context) async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      print("User ID is: "+ userCredential.user!.uid.toString());

      if(userCredential.user!.uid.toString().isNotEmpty){
        // login Success
        // Util.appUser!.isAdmin == true
        //     ? Navigator.pushReplacementNamed(context, '/addRestaurant')
        //     : Navigator.pushReplacementNamed(context, '/restaurant');
        Navigator.pushReplacementNamed(context, '/restaurant');
      } else{
        setState(() {
          showLoader = false;
        });
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ShowSnackBar(context: context, message: "Incorrect Username");
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        ShowSnackBar(context: context, message: "Incorrect Password");
      }
    }
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  toggle(){
    setState(() {
      obscureText = !obscureText;
    });
  }
  final _formKey = GlobalKey<FormState>();
  var showLoader = false;
  var obscureText = true;

  @override
  Widget build(BuildContext context) {
    Size sized = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            Align(
              child: Image.asset('top.png', width: sized.width,),
              alignment: Alignment.topLeft,
            ),
            Padding(
              padding: EdgeInsets.only(top: sized.width*0.14, left: sized.width*0.4),
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                    colors: [Colors.redAccent.shade100, Colors.black87, ],
                    tileMode: TileMode.mirror,
                  ).createShader(bounds);
                },
                child: Text('LOGIN', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),),
              ),
            ),
            Align(
              alignment: Alignment.center,
              // padding: EdgeInsets.only(top: sized.width*0.48),
              child: Container(
                // height: 300,
                // width: 400,
                margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10,
                      )
                    ]
                ),
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: emailController,
                            autofocus: false,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value){
                              if(value!.isEmpty || value.trim().isEmpty){
                                return 'Email is required';
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Email',
                              filled: true,
                              isDense: true,
                              prefixIcon: Icon(Icons.account_circle, size: 25, color: Colors.grey,),
                              // contentPadding: EdgeInsets.only(left: 30),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                gapPadding: 0,
                                borderSide: BorderSide.none,
                              ),
                              enabled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder : OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: passwordController,
                            autofocus: false,
                            obscureText: obscureText,
                            validator: (value){
                              if(value!.isEmpty || value.trim().isEmpty){
                                return 'Password is required';
                              }else if(value.trim().length<6){
                                return 'Password must be 6 characters';
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Password',
                              filled: true,
                              isDense: true,
                              prefixIcon: Icon(Icons.lock, size: 25, color: Colors.grey,),
                              suffixIcon: IconButton(
                                icon: Icon(obscureText ? Icons.visibility_off: Icons.visibility, color: Colors.grey, ),
                                onPressed: (){
                                  toggle();
                                },
                              ),
                              // contentPadding: EdgeInsets.only(left: 30),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                gapPadding: 0,
                                borderSide: BorderSide.none,
                              ),
                              enabled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder : OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30,),
                          InkWell(
                            child: Text('Forgot Password?', style: TextStyle(color: Colors.grey),),
                            onTap: (){
                              // Change Password
                            },
                          ),
                          SizedBox(height: 10,),
                          Container(
                            height: 35,
                            width: 100,
                            child: TextButton(
                              onPressed: () {
                                if(_formKey.currentState!.validate()){
                                  setState(() {
                                    authenticateUser(context);
                                    showLoader = true;
                                  });
                                }
                              },
                              child: Text('LOGIN', style: TextStyle(color: Colors.white),),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.deepPurpleAccent,
                                elevation: 8,
                              ),
                            ),
                          ),

                          SizedBox(height: 10,),
                          InkWell(
                            child: Text('New User? REGISTER', style: TextStyle(color: Colors.grey),),
                            onTap: (){
                              Navigator.pushNamed(context, '/register');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}