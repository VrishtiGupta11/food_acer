import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_acer/CustomWidgets/image-picker.dart';
import 'package:food_acer/Model/dish-details.dart';
import 'package:food_acer/Util/constants.dart';

class AddDishes extends StatefulWidget {
  String? restaurantID, restaurantName;
  AddDishes({Key? key, this.restaurantID, this.restaurantName}) : super(key: key);

  @override
  _AddDishesState createState() => _AddDishesState();
}

class _AddDishesState extends State<AddDishes> {

  addDishDetails(BuildContext context){
    // if(flatDiscountController.text == '') {
    //   flatDiscountController.text = '0';
    // }
    // if(percentageDiscountController.text == '') {
    //   percentageDiscountController.text = '0';
    // }
    Dish dishDetails = Dish(
      name: nameController.text,
      ratings: double.parse(ratingsController.text),
      imageURL: imageUploaded['imageURL'],
      discountType: selectedValue,
      flatDiscount: double.parse(flatDiscountController.text),
      percentDiscount: double.parse(percentageDiscountController.text),
      price: double.parse(priceController.text),
      restaurantName: widget.restaurantName,
      restaurantID: widget.restaurantID,
    );
    var dataToSave = dishDetails.toMap();

    FirebaseFirestore.instance
        .collection(Util.RESTAURANT_COLLECTION)
        .doc(widget.restaurantID)
        .collection(Util.DISH_COLLECTION)
        .doc().set(dataToSave)
        .then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddDishes(restaurantID: widget.restaurantID, restaurantName: widget.restaurantName,))),
    );
  }

  final _formKey = GlobalKey<FormState>();
  Map imageUploaded = {
    'imageURL' : '',
    'imageName' : 'Select to Upload Image',
  };

  FocusNode nameFocus = new FocusNode();
  FocusNode discountFocus = new FocusNode();
  FocusNode percentDiscountFocus = new FocusNode();
  FocusNode flatDiscountFocus = new FocusNode();
  FocusNode priceFocus = new FocusNode();
  FocusNode ratingsFocus = new FocusNode();
  FocusNode selectButtonFocus = new FocusNode();
  FocusNode submitButtonFocus = new FocusNode();


  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController ratingsController = TextEditingController();
  // TextEditingController discountTypeController = TextEditingController();
  TextEditingController flatDiscountController = TextEditingController(text: '0');
  TextEditingController percentageDiscountController = TextEditingController(text: '0');

  var discountType = ['Flat Discount', 'Percent Discount', 'No Discount'];
  var selectedValue = 'No Discount';

  @override
  Widget build(BuildContext context) {
    Size sized = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
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
          child: Text('ADD DISHES', style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.logout),
          //   onPressed: (){
          //     FirebaseAuth.instance.signOut();
          //     Navigator.pushReplacementNamed(context, '/login');
          //   },
          //   color: Colors.grey,
          // ),
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
                  Image.asset('top.png', width: sized.width, fit: BoxFit.fill,),
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
              alignment: Alignment.center,
              child: Container(
                height: 500,
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
                          widget.restaurantName != null ?
                          Column(
                            children: [
                              Text(widget.restaurantName.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                              SizedBox(height: 15,),
                            ],
                          ) : Container(),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            focusNode: nameFocus,
                            controller: nameController,
                            autofocus: false,
                            textCapitalization: TextCapitalization.words,
                            validator: (value){
                              if(value!.isEmpty || value.trim().isEmpty){
                                return 'Dish Name is required';
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Dish Name',
                              filled: true,
                              isDense: true,
                              prefixIcon: Icon(Icons.fastfood, size: 25, color: Colors.grey,),
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
                            focusNode: priceFocus,
                            controller: priceController,
                            autofocus: false,
                            textCapitalization: TextCapitalization.words,
                            validator: (value){
                              if(value!.isEmpty || value.trim().isEmpty){
                                return 'Price is required';
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Price',
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
                          Container(
                            height: 52,
                            width: 300,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.grey.shade100,
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.card_giftcard, color: Colors.grey,),
                                SizedBox(width: 15,),
                                Container(
                                  width: 230,
                                  child: DropdownButtonFormField(
                                    isExpanded: true,
                                    decoration: InputDecoration.collapsed(hintText: 'hintText'),
                                    isDense: true,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    value: selectedValue,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValue = value as String;
                                      });
                                    },
                                    items: discountType.map((e) {
                                      return DropdownMenuItem(
                                        child: Text(e, style: TextStyle(color: Colors.black54),),
                                        value: e,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 15,),
                          Row(
                            children: [
                              Container(
                                width: 149,
                                child: TextFormField(
                                  enabled: selectedValue=='Percent Discount',
                                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                                  focusNode: percentDiscountFocus,
                                  controller: percentageDiscountController,
                                  autofocus: false,
                                  keyboardType: TextInputType.number,
                                  // validator: (value){
                                  //   if(value!.isEmpty || value.trim().isEmpty){
                                  //     return 'Percent Discount is required';
                                  //   }
                                  // },
                                  decoration: InputDecoration(
                                    hintText: 'Percent Discount',
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
                              ),
                              SizedBox(width: 2,),
                              Container(
                                width: 149,
                                child: TextFormField(
                                  enabled: selectedValue=='Flat Discount',
                                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                                  focusNode: flatDiscountFocus,
                                  controller: flatDiscountController,
                                  // initialValue: '0',
                                  autofocus: false,
                                  keyboardType: TextInputType.number,
                                  // validator: (value){
                                  //   if(value!.isEmpty || value.trim().isEmpty){
                                  //     return 'Flat discount is required';
                                  //   }
                                  // },
                                  decoration: InputDecoration(
                                    hintText: 'Flat Discount',
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
                              ),
                            ],
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
                                      // imageUploaded = await Navigator.push(context, MaterialPageRoute(
                                      //   builder: (context) =>
                                      //       ImagePickerPage(
                                      //         folderName: Util.DISH_COLLECTION,
                                      //         imageName: nameController.text,
                                      //       ),
                                      // ));
                                      imageUploaded = await Navigator.push(context, Util.getAnimatedRoute(
                                        ImagePickerPage(
                                          folderName: Util.DISH_COLLECTION,
                                          imageName: nameController.text,
                                        ),
                                      ));
                                      selectButtonFocus.unfocus();
                                      FocusScope.of(context).requestFocus(submitButtonFocus);
                                      setState(() {});
                                    }else{
                                      ShowSnackBar(context: context, message: 'Enter Dish Name first');
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
                                  addDishDetails(context);
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