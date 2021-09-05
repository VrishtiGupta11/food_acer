import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_acer/CustomWidgets/image-picker.dart';
import 'package:food_acer/Model/restaurant-details.dart';
import 'package:food_acer/Util/constants.dart';

class AddRestaurant extends StatefulWidget {
  const AddRestaurant({Key? key}) : super(key: key);

  @override
  _AddRestaurantState createState() => _AddRestaurantState();
}

class _AddRestaurantState extends State<AddRestaurant> {

  addRestaurantDetails(BuildContext context){
    Restaurant restaurantDetails = Restaurant(
      name: nameController.text,
      categories: categoriesController.text,
      pricePerPerson: int.parse(pricePerPersonController.text),
      ratings: double.parse(ratingsController.text),
      imageURL: imageUploaded['imageURL'],
    );
    var dataToSave = restaurantDetails.toMap();

    FirebaseFirestore.instance.collection(Util.RESTAURANT_COLLECTION).doc().set(dataToSave).then((value) => Navigator.pushNamed(context, '/'));
  }

  final _formKey = GlobalKey<FormState>();
  Map imageUploaded = {
    'imageURL' : '',
    'imageName' : 'Select to Upload Image',
  };

  FocusNode nameFocus = new FocusNode();
  FocusNode categoriesFocus = new FocusNode();
  FocusNode pricePerPersonFocus = new FocusNode();
  FocusNode ratingsFocus = new FocusNode();
  FocusNode selectButtonFocus = new FocusNode();
  FocusNode submitButtonFocus = new FocusNode();


  TextEditingController nameController = TextEditingController();
  TextEditingController categoriesController = TextEditingController();
  TextEditingController pricePerPersonController = TextEditingController();
  TextEditingController ratingsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size sized = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              // colors: [Colors.redAccent.shade100, Colors.orangeAccent, ],
              colors: [Colors.redAccent.shade100, Colors.black87],
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          child: Text('ADD RESTAURANT', style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: (){
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
            color: Colors.grey,
          ),
          IconButton(
            icon: Icon(Icons.restaurant),
            onPressed: (){
              Navigator.pushNamed(context, '/restaurant');
            },
            color: Colors.grey,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            Align(
              child: Column(
                children: [
                  Image.asset('top.png', width: sized.width,),
                ],
              ),
              alignment: Alignment.topLeft,
            ),
            // Align(
            //   alignment: Alignment.topCenter,
            //   child: Text(
            //     "Add Restaurant",
            //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            //   ),
            // ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                // height: 500,
                margin: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 30),
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
                            focusNode: nameFocus,
                            controller: nameController,
                            autofocus: false,
                            textCapitalization: TextCapitalization.words,
                            validator: (value){
                              if(value!.isEmpty || value.trim().isEmpty){
                                return 'Restaurant Name is required';
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Restaurant Name',
                              filled: true,
                              isDense: true,
                              prefixIcon: Icon(Icons.restaurant, size: 25, color: Colors.grey,),
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
                            focusNode: categoriesFocus,
                            controller: categoriesController,
                            autofocus: false,
                            textCapitalization: TextCapitalization.words,
                            validator: (value){
                              if(value!.isEmpty || value.trim().isEmpty){
                                return 'Category is required';
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Category',
                              filled: true,
                              isDense: true,
                              prefixIcon: Icon(Icons.category, size: 25, color: Colors.grey,),
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
                            focusNode: pricePerPersonFocus,
                            controller: pricePerPersonController,
                            autofocus: false,
                            keyboardType: TextInputType.number,
                            validator: (value){
                              if(value!.isEmpty || value.trim().isEmpty){
                                return 'Price per Person is required';
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Price per Person',
                              filled: true,
                              isDense: true,
                              prefixIcon: Icon(Icons.price_change, size: 25, color: Colors.grey,),
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
                            focusNode: ratingsFocus,
                            controller: ratingsController,
                            autofocus: false,
                            keyboardType: TextInputType.number,
                            validator: (value){
                              if(value!.isEmpty || value.trim().isEmpty){
                                return 'Rating is required';
                              }
                              if(double.parse(value)<0 || double.parse(value)> 5){
                                return 'Enter ratings from 0-5';
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Ratings',
                              filled: true,
                              isDense: true,
                              prefixIcon: Icon(Icons.star, size: 25, color: Colors.grey,),
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
                          // Image Picker widget
                          // ImagePickerPage(collection: Util.RESTAURANT_COLLECTION,),

                          Container(
                            height: 55,
                            width: 300,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.grey.shade100,
                            ),
                            child: Row(
                              children: [
                                OutlinedButton(
                                  focusNode: selectButtonFocus,
                                  onPressed: () async {
                                    if(nameController.text.isNotEmpty) {
                                      imageUploaded = await Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            ImagePickerPage(
                                              folderName: Util.RESTAURANT_COLLECTION,
                                              imageName: nameController.text,
                                            ),
                                      ));
                                      selectButtonFocus.unfocus();
                                      FocusScope.of(context).requestFocus(submitButtonFocus);
                                      setState(() {});
                                    }else{
                                      ShowSnackBar(context: context, message: 'Enter Restaurant Name first');
                                    }
                                  },
                                  child: Text('Select', style: TextStyle(color: Colors.white),),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.deepPurpleAccent,
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  height: 35,
                                  child: Center(
                                    child: Text(imageUploaded['imageName'], style: TextStyle(color: Colors.grey),),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20,),
                          Container(
                            height: 35,
                            width: 100,
                            child: TextButton(
                              focusNode: submitButtonFocus,
                              onPressed: () {
                                if(_formKey.currentState!.validate()){
                                  addRestaurantDetails(context);
                                }
                              },
                              child: Text('SUBMIT', style: TextStyle(color: Colors.white),),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.deepPurpleAccent,
                                elevation: 8,
                              ),
                            ),
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
