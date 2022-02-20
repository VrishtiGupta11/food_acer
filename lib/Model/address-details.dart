import 'package:cloud_firestore/cloud_firestore.dart';

class UserAddress{
  String? label;
  GeoPoint? location;
  String? address;

  UserAddress({this.label, this.location, this.address});

  @override
  String toString() {
    return 'UserAddress{label: $label, location: $location, address: $address}';
  }

  toMap() => {
    'label': label,
    'location': location,
    'address': address,
  };
}