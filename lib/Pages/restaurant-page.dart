import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_acer/Util/constants.dart';

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
    if(Util.appUser == null){
      Util.fetchUserDetails();
    }
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
                    color: Colors.deepPurpleAccent,
                  ),
                    child: Card(
                      color: Colors.deepPurpleAccent,
                      child: Row(
                        children: [
                          // Align(
                          //   child:
                          //   alignment: Alignment.bottomLeft,
                          // ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              color: Colors.grey,
                              child: Icon(
                                Icons.person,
                                size: 90,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 60, left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Util.appUser!.name.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  Util.appUser!.email.toString(),
                                  style: TextStyle(
                                      color: Colors.white60,
                                      fontWeight: FontWeight.bold),
                                ),
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
                Util.appUser!.isAdmin==true
                    ? ListTile(
                        dense: true,
                        leading: Icon(Icons.logout),
                        title: Text('Logout'),
                        onTap: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      )
                    : Container(),
                ListTile(
                  dense: true,
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: (){},
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
          body: ListView(
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
                      onTap: () {},
                      child: Column(
                        children: [
                          FadeInImage.assetNetwork(
                            width: 350,
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
                                    Util.appUser!.isAdmin == true ? Container(
                                      height: 50,
                                      width: 50,
                                      child: InkWell(
                                        child: Icon(Icons.edit),
                                        onTap: (){
                                          // Navigator.push(context, MaterialPageRoute(builder: (context) => DishDetails(restaurantID: document.id,)));
                                        },
                                      ),
                                    ) : Container(),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    Container(
                                      height: 28,
                                      width: 50,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(map['ratings'].toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                          Icon(Icons.star, color: Colors.white, size: 15,)
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.green[800],
                                      ),
                                    ),
                                    SizedBox(height: 5,),
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
