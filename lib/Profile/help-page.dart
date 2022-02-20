import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_acer/Util/constants.dart';

class HelpPage extends StatelessWidget {
  HelpPage({Key? key}) : super(key: key);

  TextEditingController queriesCotroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
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
            child: Text("Help", style: TextStyle(fontWeight: FontWeight.bold),),
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
        body: Padding(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Column(
            children: [
              TextField(
                controller: queriesCotroller,
                maxLines: 10,
                decoration: InputDecoration(
                  // fillColor: Colors.grey.shade300,
                  hintText: 'Write your Query here...',
                  filled: true,
                  isDense: true,
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
              SizedBox(height: 10,),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  elevation: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
