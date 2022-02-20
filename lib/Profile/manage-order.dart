import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_acer/data-provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ManageOrdersPage1 extends StatefulWidget {
  const ManageOrdersPage1({Key? key}) : super(key: key);

  @override
  _ManageOrdersPage1State createState() => _ManageOrdersPage1State();
}

class _ManageOrdersPage1State extends State<ManageOrdersPage1> {
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
            'My Orders',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: context.watch<DataProvider>().orders != null
          ? CustomScrollView(
        physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                List ID= [];
                List data = context.watch<DataProvider>().orders!.map((DocumentSnapshot document) {
                  ID.add(document.id);
                  return document.data();
                }).toList();

                return Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ManageOrdersPage2(
                                id: ID[index],
                                order: data[index],
                                index: index,
                              ),
                            ));
                      },
                      child: Card(
                        child: Container(
                            padding: EdgeInsets.only(top: 60, left: 10, right: 10),
                            height: 170,
                            width: 350,
                            color: Colors.grey.shade200,
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Text('Order ID: ${ID[index].substring(0, 7)}', style: TextStyle(fontSize: 13, color: Colors.grey.shade700),),
                                    SizedBox(height: 4,),
                                    Text('Order Date: ${(data[index]['timestamp'] as Timestamp).toDate().toString().split(' ')[0]}', style: TextStyle(color: Colors.grey.shade700),),
                                    SizedBox(height: 4,),
                                    Text('Order Time: ${(data[index]['timestamp'] as Timestamp).toDate().toString().split(' ')[1]}', style: TextStyle(color: Colors.grey.shade700),),
                                    SizedBox(height: 4,),
                                    Text('Total: \u20b9${data[index]['total']}', style: TextStyle(fontSize: 13, color: Colors.grey.shade700),),
                                    SizedBox(height: 4,),
                                    Text('Address: ${data[index]['address']}', style: TextStyle(fontSize: 13, color: Colors.blueGrey),),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    Icon(Icons.keyboard_arrow_right, size: 50,),
                                  ],
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                ),
                              ],
                            )
                        ),
                        margin: EdgeInsets.only(left: 30),
                      ),
                    ),
                    Positioned(
                      child: Hero(
                        tag: 'imageTag$index',
                        child: CircleAvatar(
                          backgroundImage: AssetImage('hamburger.png'),
                          radius: 30,
                          onBackgroundImageError: (exception, stackTrace) {
                            Center(
                              child: Icon(Icons.error_outline, color: Colors.redAccent,),
                            );
                          },
                        ),
                      ),
                      left: MediaQuery.of(context).size.width*0.43,
                    ),
                  ],
                );
              },
              childCount: context.watch<DataProvider>().orders!.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 2,
            ),
          ),
        ],
      )
          : Center(
        child: Text(
          'No order made yet',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

class ManageOrdersPage2 extends StatefulWidget {
  Map<String, dynamic>? order;
  String? id;
  int? index;
  ManageOrdersPage2({Key? key, this.order, this.id, this.index}) : super(key: key);

  @override
  _ManageOrdersPage2State createState() => _ManageOrdersPage2State();
}

class _ManageOrdersPage2State extends State<ManageOrdersPage2> {

  getDishesList(){
    List<Widget> dishesList = [];
    widget.order!['dishes'].forEach((element) {
      dishesList.add(
        Container(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                height: 100,
                width: 130,
                child: Card(
                  child: Image.network(
                    element['imageURL'],
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(Icons.error_outline, color: Colors.green,),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(element['name'], style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, letterSpacing: 0.5, ),),
                  Text('${element['quantity']} X \u20b9${element['price']}', style: TextStyle(fontSize: 12),),
                  Text('Total - \u20b9${element['totalPrice']}', style: TextStyle(fontSize: 15, color: Colors.redAccent.shade100),),
                ],
              ),
            ],
          ),
        ),
        // ListTile(
        //   leading: Image.network(
        //     element['imageURL'],
        //     errorBuilder: (context, error, stackTrace) {
        //       return Center(
        //         child: Text('Image Not Available'),
        //       );
        //     },
        //     loadingBuilder: (context, child, loadingProgress) {
        //       return Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     },
        //   ),
        //   title: Text(element['name'], style: TextStyle(color: Colors.grey),),
        //   subtitle: Text('${element['quantity']} X ${element['price']} = ${element['totalPrice']}'),
        // ),
      );
    });
    return dishesList;
  }

  addToCart(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Id: ${widget.id.toString().substring(0, 7)}'),
        centerTitle: true,
        backgroundColor: Colors.redAccent.shade100,
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(10),
              height: 150,
              width: 150,
              child: Hero(
                tag: 'imageTag${widget.index}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset('hamburger.png', fit: BoxFit.fill,),
                ),
              ),
            ),
          ),
          // Divider(height: 40, thickness: 30,),
          Container(
            padding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
            height: 30,
            color: Colors.grey.shade300,
            child: Row(
              children: [
                Text('Delivery Time', style: TextStyle(fontWeight: FontWeight.bold,),),
                SizedBox(width: 15,),
                Text(widget.order!['timestamp'].toDate().toString().split(' ')[1]),
                SizedBox(width: 15,),
                Text(widget.order!['timestamp'].toDate().toString().split(' ')[0]),
              ],
            ),
          ),
          ...getDishesList(),
          Divider(height: 40, thickness: 30,),
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              top: 5,
              bottom: 5,
            ),
            child: Column(
              children: [
                Text(
                  'Grand Total - \u20b9${widget.order!['total'].toString()}',
                  style: TextStyle(
                      fontSize: 16,
                      // color: Colors.deepOrange.shade200,
                      color: Colors.black38,
                      letterSpacing: 0.5
                  ),
                ),
                Text(
                  'Address - ${widget.order!['address']}',
                  style: TextStyle(
                    fontSize: 16,
                    // color: Colors.deepOrange.shade200,
                    color: Colors.black38,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: (){
                    addToCart();
                  },
                  child: Text('Re-Order', style: TextStyle(color: Colors.white),),
                  style: TextButton.styleFrom(
                    elevation: 5,
                    backgroundColor: Colors.redAccent.shade100,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}