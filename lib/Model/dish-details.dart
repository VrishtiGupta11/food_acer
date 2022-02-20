class Dish{
  String? name;
  double? price;
  String? discountType;
  double? flatDiscount;
  double? percentDiscount;
  String? imageURL;
  double? ratings;
  int? quantity;
  double? totalPrice;
  String? restaurantName;
  String? restaurantID;

  Dish({this.name, this.price, this.discountType, this.flatDiscount, this.percentDiscount, this.imageURL, this.ratings, this.quantity, this.totalPrice, this.restaurantName, this.restaurantID});


  @override
  String toString() {
    return 'Dish{name: $name, price: $price, discountType: $discountType, flatDiscount: $flatDiscount, percentDiscount: $percentDiscount, imageURL: $imageURL, ratings: $ratings, quantity: $quantity, totalPrice: $totalPrice, restaurantName: $restaurantName, restaurantID: $restaurantID}';
  }

  toMap() => {
    'name': name,
    'price': price,
    'discountType': discountType,
    'flatDiscount': flatDiscount,
    'percentDiscount': percentDiscount,
    'imageURL': imageURL,
    'ratings': ratings,
    'quantity': quantity,
    'totalPrice': totalPrice,
    'restaurantName': restaurantName,
    'restaurantID': restaurantID,
  };
}