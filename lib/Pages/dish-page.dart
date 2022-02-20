import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_acer/CustomWidgets/counter.dart';
import 'package:food_acer/Pages/cart-page.dart';
import 'package:food_acer/Util/constants.dart';

import 'add-dishes.dart';

class DishPage extends StatefulWidget {
  String? restaurantID, restaurantName;

  DishPage({Key? key, this.restaurantID, this.restaurantName}) : super(key: key);

  @override
  _DishPageState createState() => _DishPageState();
}

class _DishPageState extends State<DishPage> {

  fetchDishes(){
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection(Util.RESTAURANT_COLLECTION)
        .doc(widget.restaurantID)
        .collection(Util.DISH_COLLECTION)
        .snapshots();
    return stream;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fetchDishes(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasError){
          return Center(
            child: Text("Something Went Wrong", style: TextStyle(color: Colors.red),),
          );
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
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
              child: Text(widget.restaurantName.toString(), style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          drawer: Drawer(
            elevation: 20,
            child: ListView(
              children: [
                DrawerHeader(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade300,
                    ),
                    child: Card(
                      color: Colors.deepPurple.shade300,
                      child: Row(
                        children: [
                          // Align(
                          //   child:
                          //   alignment: Alignment.bottomLeft,
                          // ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5,
                                    ),
                                  ]
                              ),
                              // child: Image.network(map['imageURL'], fit: BoxFit.fill,),
                              child: Util.appUser!.imageURL == '' || Util.appUser == null
                                  ? Container(
                                      color: Colors.grey,
                                      child: Icon(
                                        Icons.person,
                                        size: 80,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Image.network(
                                Util.appUser!.imageURL.toString(),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 60, left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Util.appUser != null
                                    ? Text(
                                  Util.appUser!.name.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ) : Container(),
                                Util.appUser != null
                                    ? Text(
                                  Util.appUser!.email.toString(),
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ) : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                ),
                ListTile(
                  dense: true,
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: (){
                    Navigator.pushNamed(context, '/restaurant');
                  },
                ),
                Util.appUser != null
                    ? (Util.appUser!.isAdmin==true
                    ? ListTile(
                  dense: true,
                  leading: Icon(Icons.restaurant),
                  title: Text('Add Restaurant'),
                  onTap: () {
                    Navigator.pushNamed(context, '/addRestaurant');
                  },
                )
                    : Container()) : Container(),
                ListTile(
                  dense: true,
                  leading: Icon(Icons.shopping_cart),
                  title: Text('Cart'),
                  onTap: (){
                    Navigator.pushNamed(context, '/cart');
                  },
                ),
                ListTile(
                  dense: true,
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: (){
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                ListTile(
                  dense: true,
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: (){
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  height: 35,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(5),
                  ),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, Util.getAnimatedRoute(CartPage()));
                    },
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          width: MediaQuery.of(context).size.width*0.55,
                          child: Text('CART', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          width: MediaQuery.of(context).size.width*0.35,
                          child: Icon(Icons.keyboard_arrow_right, color: Colors.white,),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: snapshot.data.docs.isEmpty
              ? Center(
            child: Text(
              'No Dish Available',
              style: TextStyle(color: Colors.grey),
            ),
          )
              : ListView(
            children: snapshot.data.docs.map<Widget>((DocumentSnapshot document){
              Map<String, dynamic> map = document.data() as Map<String, dynamic>;
              map['docID'] = document.id.toString();

              return Padding(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 340,
                    margin: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                          ),
                        ]
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {},
                      child: Column(
                        children: [
                          FadeInImage.assetNetwork(
                            width: 390,
                            height: 200,
                            fit: BoxFit.fill,
                            placeholder: 'circular_loader.gif',
                            image: map['imageURL'] == ''
                                ? 'https://firebasestorage.googleapis.com/v0/b/food-acer.appspot.com/o/restaurants%2FRestaurant.png?alt=media&token=8d37e8e2-17c6-48fb-8d88-950ebb6aa9ee'
                                : map['imageURL'],
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                child: Center(
                                  child: Text('Image Not Available'),
                                ),
                              );
                            },
                            placeholderErrorBuilder:
                                (context, error, stackTrace) {
                              return Center(
                                child: Text('Loading Image'),
                              );
                            },
                          ),
                          SizedBox(height: 10,),
                          Container(
                            margin: EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      map['name'],
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                                    ),
                                    SizedBox(height: 10,),
                                    Text(map['discountType'], style: TextStyle(fontSize: 16, color: Colors.grey),),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        for(double i = 1; i<=map['ratings']; i++)
                                          Icon(Icons.star, color: Colors.orangeAccent, size: 15,),
                                        (10*map['ratings'])%10 != 0 ?
                                        ShaderMask(
                                          blendMode: BlendMode.srcATop,
                                          shaderCallback: (Rect rect) {
                                            return LinearGradient(
                                              // stops: [0, (5 - map['ratings'])*100],
                                              stops: [0, ((10*map['ratings'])%10) / 10],
                                              colors: [
                                                Colors.orangeAccent,
                                                Colors.white,
                                              ],
                                            ).createShader(rect);
                                          },
                                          child: Icon(Icons.star, size: 15, color: Colors.white,),
                                        ) : Container(),
                                        // Spacer(),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    map['discountType'] == 'No Discount'
                                        ? Text("\u20b9${map['price']}", style: TextStyle(color: Colors.grey),)
                                        : Row(
                                      children: [
                                        Text("\u20b9${map['price']}", style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey),),
                                        Text(' \u20b9${map['price'] - map['flatDiscount'] - 0.01*map['percentDiscount']*map['price']}', style: TextStyle(color: Colors.grey.shade600),)
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          Counter(dish: map,),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}