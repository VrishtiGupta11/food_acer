import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_acer/Profile/alert-dialog.dart';
import 'package:food_acer/Util/constants.dart';

import 'add-address.dart';

class ManageAddressPage extends StatefulWidget {
  const ManageAddressPage({Key? key}) : super(key: key);

  @override
  _ManageAddressPageState createState() => _ManageAddressPageState();
}

class _ManageAddressPageState extends State<ManageAddressPage> {

  List<Widget> widgetList = [];

  fetchAddresses(){
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection(Util.USER_COLLECTION).doc(Util.appUser!.uid).collection(Util.ADDRESS_COLLECTION).snapshots();
    return stream;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fetchAddresses(),
      builder: (BuildContext context,AsyncSnapshot snapshot) {

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
        if(snapshot.data.docs.isEmpty){
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
                  'My Addresses',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
              child: Icon(Icons.add, color: Colors.white,),
              onPressed: (){
                // Open UI To add address
                Navigator.pushNamed(context, '/addAddress');
              },
            ),
            body: Center(
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Click on ', style: TextStyle(color: Colors.black54, letterSpacing: 0.5),),
                  Icon(Icons.add_circle, color: Colors.grey,),
                  Text(' to ADD Address', style: TextStyle(color: Colors.black54, letterSpacing: 0.5),),
                ],
              ),
            ),
          );
        }

        else{
          return Scaffold(
            appBar: AppBar(
              title: Text("Addresses"),
              centerTitle: true,
              backgroundColor: Colors.redAccent.shade100,
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
              child: Icon(Icons.add, color: Colors.white,),
              onPressed: (){
                // Open UI To add address
                Navigator.pushNamed(context, '/addAddress');
              },
            ),
            // View the addresses
            body: ListView(
              children: snapshot.data.docs.map<Widget>((DocumentSnapshot document){
                Map map = document.data() as Map;
                map['docID'] = document.id.toString();
                String addressString = '';
                List addressList = map['address'].split(',');

                if(map['address'] == null || map['address'] == 'null' || map['address'] == ''){
                  print('Deleting Null Address');
                  FirebaseFirestore.instance.collection(Util.USER_COLLECTION).doc(Util.appUser!.uid).collection(Util.ADDRESS_COLLECTION).doc(map['docID']).delete();
                }

                addressList.forEach((element) {
                  // print(element);
                  var addList = element.split('=');
                  // print(addList);
                  if(addList[0].trim() == 'streetAddress' || addList[0].trim() == 'region' || addList[0].trim() == 'countryName' || addList[0].trim() == 'postal'){
                    addressString += element + '\n';
                  }
                });
                return Card(
                  child: ListTile(
                    leading: map['label'] == 'Home Place'? Icon(Icons.home) : Icon(Icons.work),
                    title: Container(
                      child: Column(
                          children: [
                            Row(
                              children: [
                                Text(map['label'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                Spacer(),
                                AlertDialogIcon(docId: map['docID'],),
                              ],
                            ),
                            SizedBox(height: 10,),
                          ]
                      ),
                    ),
                    subtitle: Container(
                      child: Row(
                        children: [
                          Text(addressString, style: TextStyle(color: Colors.black54),),
                          Spacer(),
                          IconButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AddAddressPage(lat: map['location'].latitude, long: map['location'].longitude,)));
                            },
                            icon: Image.asset(
                              'map.png',
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 70,
                                  child: Center(
                                    child: Text('Image Not Available'),
                                  ),
                                );
                              },
                              fit: BoxFit.fill,
                            ),
                            iconSize: 50,
                          ),
                        ],
                      ),
                    ),
                    dense: true,
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
