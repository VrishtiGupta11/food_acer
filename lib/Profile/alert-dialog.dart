import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_acer/Util/constants.dart';

class AlertDialogIcon extends StatefulWidget {
  var docId;
  AlertDialogIcon({Key? key, this.docId}) : super(key: key);

  @override
  _AlertDialogIconState createState() => _AlertDialogIconState();
}

class _AlertDialogIconState extends State<AlertDialogIcon> {

  // DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        icon: Icon(Icons.delete, color: Colors.grey,),
        onPressed: () async{
          return showDialog(
              barrierDismissible: false,
              // barrierColor: Colors.redAccent.shade100,
              context: context,
              builder: (context){
                return AlertDialog(
                  title: Text('Delete Address'),
                  content: Container(
                    height: 50,
                    child: Column(
                      children: [
                        Text('Are you sure you want to Delete this Address?', style: TextStyle(color: Colors.grey),),
                        // SizedBox(height: 4.0,),
                        // Text(''),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel', style: TextStyle(color: Colors.redAccent.shade100),),
                    ),
                    TextButton(
                      onPressed: (){
                        FirebaseFirestore.instance.collection(Util.USER_COLLECTION).doc(Util.appUser!.uid).collection(Util.ADDRESS_COLLECTION).doc(widget.docId).delete();
                        Navigator.of(context).pop();
                      },
                      child: Text('Delete', style: TextStyle(color: Colors.redAccent.shade100),),
                    ),
                  ],
                );
                // return DatePickerDialog(initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now());
              }
          );
        },
      ),
    );
  }
}
