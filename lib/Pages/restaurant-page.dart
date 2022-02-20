import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_acer/Pages/dish-page.dart';
import 'package:food_acer/Util/constants.dart';

import 'add-dishes.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({Key? key}) : super(key: key);

  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {

  fetchRestaurants(){
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection(Util.RESTAURANT_COLLECTION).snapshots();
    return stream;
  }

  @override
  Widget build(BuildContext context) {
    // if(Util.appUser == null){
    //   Util.fetchUserDetails();
    // }

    return StreamBuilder(
      stream: fetchRestaurants(),
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
              child: Text('FOODIE', style: TextStyle(fontWeight: FontWeight.bold),),
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
                              child: Util.appUser == null || Util.appUser!.imageURL == ''
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
                                      fontWeight: FontWeight.bold),
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
          body: snapshot.data.docs.isEmpty
              ? Center(
                  child: Text(
                    'No Restaurants Available',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView(
            children: snapshot.data.docs.map<Widget>((DocumentSnapshot document){
              Map<String, dynamic> map = document.data() as Map<String, dynamic>;

              return Padding(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 290,
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
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(
                        //   builder: (context) => DishPage(
                        //     restaurantID: document.id,
                        //     restaurantName: map['name'],
                        //   ),
                        // ));
                        Navigator.push(context, Util.getAnimatedRoute(
                          DishPage(
                            restaurantID: document.id,
                            restaurantName: map['name'],
                          ),
                        ));
                      },
                      child: Column(
                        children: [
                          FadeInImage.assetNetwork(
                            width: 380,
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
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(map['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),),
                                    SizedBox(height: 10,),
                                    Text(map['categories'], style: TextStyle(fontSize: 16, color: Colors.grey),),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Util.appUser != null
                                        ? (Util.appUser!.isAdmin == true ? Container(
                                      height: 50,
                                      width: 50,
                                      child: InkWell(
                                        child: Icon(Icons.edit),
                                        onTap: (){
                                          // Navigator.push(context, MaterialPageRoute(builder: (context) => AddDishes(restaurantID: document.id, restaurantName: map['name'],)));
                                          Navigator.push(context, Util.getAnimatedRoute(AddDishes(restaurantID: document.id, restaurantName: map['name'],)));

                                        },
                                      ),
                                    ) : Container()) : Container(),
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
                                    Text("\u20b9${map['pricePerPerson']} for one", style: TextStyle(color: Colors.grey),),
                                  ],
                                ),
                              ],
                            ),
                          ),
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