import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_acer/CustomWidgets/image-picker.dart';
import 'package:food_acer/Util/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map imageUploaded = {
    'imageURL': '',
    'imageName': 'image',
  };

  updateDatabase() {
    print('Updating Database');
    FirebaseFirestore.instance
        .collection('users')
        .doc(Util.appUser!.uid)
        .update({'imageURL': imageUploaded['imageURL']});
    print('Database Updated');
    Util.fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
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
          child: Text(
            'My Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
                          decoration:
                              BoxDecoration(color: Colors.white, boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5,
                            ),
                          ]),
                          // child: Image.network(map['imageURL'], fit: BoxFit.fill,),
                          child: Util.appUser!.imageURL == ''
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
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 200,
                                      child: Center(
                                        child: Text('Image Not Available'),
                                      ),
                                    );
                                  },
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
                                  )
                                : Container(),
                            Util.appUser != null
                                ? Text(
                                    Util.appUser!.email.toString(),
                                    style: TextStyle(
                                        color: Colors.white60,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            ListTile(
              dense: true,
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/restaurant');
              },
            ),
            Util.appUser != null
                ? (Util.appUser!.isAdmin == true
                    ? ListTile(
                        dense: true,
                        leading: Icon(Icons.restaurant),
                        title: Text('Add Restaurant'),
                        onTap: () {
                          Navigator.pushNamed(context, '/addRestaurant');
                        },
                      )
                    : Container())
                : Container(),
            ListTile(
              dense: true,
              leading: Icon(Icons.shopping_cart),
              title: Text('Cart'),
              onTap: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 15),
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          imageUploaded = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImagePickerPage(
                                  folderName: 'Profile',
                                  imageName: Util.appUser!.uid,
                                ),
                              ));
                          updateDatabase();
                          setState(() {});
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            height: 160,
                            width: 160,
                            decoration:
                                BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5,
                              ),
                            ]),
                            // child: Image.network(map['imageURL'], fit: BoxFit.fill,),
                            child: Util.appUser!.imageURL == ''
                                ? (imageUploaded['imageURL'] == ''
                                    ? Container(
                                        color: Colors.grey,
                                        child: Icon(
                                          Icons.person,
                                          size: 150,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Image.network(
                                        imageUploaded['imageURL'],
                                        fit: BoxFit.fill,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            height: 200,
                                            child: Center(
                                              child:
                                                  Text('Image Not Available'),
                                            ),
                                          );
                                        },
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      ))
                                : Image.network(
                                    Util.appUser!.imageURL.toString(),
                                    fit: BoxFit.fill,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 200,
                                        child: Center(
                                          child: Text('Image Not Available'),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Divider(
                        indent: 30,
                        endIndent: 30,
                        thickness: 5,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        Util.appUser!.name.toString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        Util.appUser!.email.toString(),
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Divider(
                        indent: 30,
                        endIndent: 30,
                        thickness: 5,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Manage Profile",),
                  subtitle: Text("Update Your Data for your Account"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: (){
                    // Navigator.pushNamed(context, '/manageProfile');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text("Manage Orders",),
                  subtitle: Text("Manage your order history here"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: (){
                    Navigator.pushNamed(context, '/manageOrders');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text("Manage Addresses",),
                  subtitle: Text("Update Your Address for your delivery"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: (){
                    // Navigator.pushNamed(context, '/googleMap');
                    Navigator.pushNamed(context, '/manageAddress');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.message),
                  title: Text("Help",),
                  subtitle: Text("Raise your queries"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: (){
                    Navigator.pushNamed(context, '/help');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.document_scanner_outlined),
                  title: Text("Terms and Conditions",),
                  subtitle: Text("Check our Terms and Conditions"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: (){},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
