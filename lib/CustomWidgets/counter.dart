import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_acer/Model/dish-details.dart';
import 'package:food_acer/Util/constants.dart';

class Counter extends StatefulWidget {
  Map? dish;
  Counter({Key? key, this.dish}) : super(key: key);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {

  var initialValue = 0;
  fetchDishes(){
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection(Util.USER_COLLECTION).doc(Util.appUser!.uid).collection(Util.CART_COLLECTION).snapshots();
    return stream;
  }
  updateDishInCart() async{
    Dish cartDish = Dish(
      name: widget.dish!['name'],
      price: widget.dish!['price'],
      quantity: initialValue,
      totalPrice: widget.dish!['price']*initialValue,
      ratings: widget.dish!['ratings'],
      discountType: widget.dish!['discountType'],
      flatDiscount: widget.dish!['flatDiscount'],
      percentDiscount: widget.dish!['percentDiscount'],
      imageURL: widget.dish!['imageURL'],
      restaurantName: widget.dish!['restaurantName'],
    );
    await FirebaseFirestore.instance.collection(Util.USER_COLLECTION).doc(Util.appUser!.uid).collection(Util.CART_COLLECTION).doc(widget.dish!['docID']).set(cartDish.toMap());
  }
  deleteDishFromCart() async{
    await FirebaseFirestore.instance.collection(Util.USER_COLLECTION).doc(Util.appUser!.uid).collection(Util.CART_COLLECTION).doc(widget.dish!['docID']).delete();
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
            child: Container(),
          );
        }
        List snapshots = snapshot.data.docs;
        snapshots.forEach((document) {
          Map map = document.data();
          map['docID'] = document.id.toString();
          if(map['docID'] == widget.dish!['docID']){
            initialValue = map['quantity'];
          }
        });

        return Container(
            width: 160,
            height: 48,
            child: (initialValue==0) ? OutlinedButton(
              // style: OutlinedButton.styleFrom(backgroundColor: Colors.blueGrey[200]),
              onPressed: (){
                setState(() {
                  initialValue++;
                  updateDishInCart();
                  // showModalBottomSheet(context: context, builder: (context) {
                  //   return Container(
                  //     height: 50,
                  //   );
                  // },enableDrag: true);
                });
              },
              child: Text("ADD", style: TextStyle(color: Colors.redAccent.shade100, fontWeight: FontWeight.bold),),

            ) : Container(
              height: 46,
              width: 160,
              // color: Colors.blueGrey[200],
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.all(Radius.circular(3)),
                // color: Colors.redAccent[100],
              ),
              child: Row(
                children: [
                  TextButton(
                    // style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.redAccent.shade100)),
                    onPressed: (){
                      setState(() async{
                        if(initialValue<=0){
                          initialValue = 0;
                        }else if(initialValue == 1){
                          initialValue--;
                          await updateDishInCart();
                          deleteDishFromCart();
                        }else{
                          initialValue--;
                          updateDishInCart();
                        }
                      });
                    },
                    child: Container(
                      height: 50,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [Text("-", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),],
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(initialValue.toString(), style: TextStyle(color: Colors.black),),
                  // Text(map['quantity'].toString()),
                  Spacer(),
                  TextButton(
                    onPressed: (){
                      setState(() {
                        initialValue++;
                        updateDishInCart();
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [Text("+", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),],
                      ),
                    ),
                  ),
                ],
              ),
            )
        );
      },
    );
  }
}
