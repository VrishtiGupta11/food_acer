import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({Key? key}) : super(key: key);

  @override
  _PaymentMethodsPageState createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {

  fetchPaymentMethods() {
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection(
        "extras").doc('payment-methods').collection('methods').snapshots();
    return stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Methods'),
        centerTitle: true,
        backgroundColor: Colors.redAccent.shade100,
      ),
      body: StreamBuilder(
        stream: fetchPaymentMethods(),
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
          return ListView(
            children: snapshot.data.docs.map<Widget>((DocumentSnapshot document){
              Map<String, dynamic> map = document.data() as Map<String, dynamic>;
              map['docID'] = document.id.toString();

              return ListTile(
                leading: Image.network(map['imageURL'], height: 35, width: 35,),
                title: Text(map['name']),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: (){
                  Navigator.pop(context, map['name']);
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
