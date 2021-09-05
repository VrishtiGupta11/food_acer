import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_acer/CustomWidgets/image-picker.dart';
import 'package:food_acer/Model/user-details.dart';
import 'package:food_acer/Util/constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  void registerUser(BuildContext context) async{
    try {

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      print("User ID is:"+userCredential.user!.uid.toString());

      if(userCredential.user!.uid.toString().isNotEmpty){
        // AppUser user = AppUser(uid: userCredential.user!.uid, name: nameController.text, email: loginIDController.text);
        Util.appUser = AppUser(
          uid: userCredential.user!.uid,
          name: nameController.text,
          phoneNumber: phoneController.text,
          email: emailController.text,
          imageURL: '',
          isAdmin: false,
        );
        var dataToSave = Util.appUser!.toMap();

        FirebaseFirestore.instance.collection("users").doc(Util.appUser!.uid).set(dataToSave).then((value) => Navigator.pushReplacementNamed(context, "/restaurant"));

      }else{
        // Registration Failed
        setState(() {
          showLoader=false;
        });
      }


    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }


  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
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
    return showLoader
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Stack(
              children: [
                Align(
                  child: Image.asset(
                    'top.png',
                    width: sized.width,
                  ),
                  alignment: Alignment.topLeft,
                ),
                Padding(
                  padding: EdgeInsets.only(top: sized.width*0.15, left: sized.width*0.36),
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter,
                        colors: [Colors.redAccent.shade100, Colors.black87, ],
                        tileMode: TileMode.mirror,
                      ).createShader(bounds);
                    },
                    child: Text('REGISTER', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),),
                  ),
                ),
                Align(
                  // padding: EdgeInsets.only(top: sized.width*0.48),
                  alignment: Alignment.centerLeft,
                  child: Container(
                    // height: 410,
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
                        ]),
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: nameController,
                                autofocus: false,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value!.isEmpty || value.trim().isEmpty) {
                                    return 'Name is required';
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'Name',
                                  filled: true,
                                  isDense: true,
                                  prefixIcon: Icon(
                                    Icons.person,
                                    size: 25,
                                    color: Colors.grey,
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
                                  focusedBorder: OutlineInputBorder(
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
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: emailController,
                                autofocus: false,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty || value.trim().isEmpty) {
                                    return 'Email is required';
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  filled: true,
                                  isDense: true,
                                  prefixIcon: Icon(
                                    Icons.account_circle,
                                    size: 25,
                                    color: Colors.grey,
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
                                  focusedBorder: OutlineInputBorder(
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
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: phoneController,
                                autofocus: false,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value!.isEmpty || value.trim().isEmpty) {
                                    return 'Phone number is required';
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'Mobile Number',
                                  filled: true,
                                  isDense: true,
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    size: 25,
                                    color: Colors.grey,
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
                                  focusedBorder: OutlineInputBorder(
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
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: passwordController,
                                autofocus: false,
                                obscureText: obscureText,
                                validator: (value) {
                                  if (value!.isEmpty || value.trim().isEmpty) {
                                    return 'Password is required';
                                  } else if (value.trim().length < 6) {
                                    return 'Password must be 6 characters';
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  filled: true,
                                  isDense: true,
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    size: 25,
                                    color: Colors.grey,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
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
                                  focusedBorder: OutlineInputBorder(
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
                              SizedBox(
                                height: 15,
                              ),
                              // Image Picker widget
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {},
                                child: Text(
                                  'By Registering in You accept our Terms & Conditions',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 35,
                                width: 100,
                                child: TextButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        registerUser(context);
                                        showLoader = true;
                                      });
                                    }
                                  },
                                  child: Text(
                                    'REGISTER',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.deepPurpleAccent,
                                    elevation: 8,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                child: Text(
                                  'Terms & Conditions',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                onTap: () {
                                  // Change Password
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
          )
    );
  }
}
