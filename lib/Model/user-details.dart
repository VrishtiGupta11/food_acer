class AppUser{
  String? uid;
  String? name;
  String? phoneNumber;
  String? email;
  bool? isAdmin;
  String? imageURL;

  AppUser({this.uid, this.name, this.phoneNumber, this.email, this.isAdmin, this.imageURL});

  @override
  String toString() {
    return 'User{uid: $uid, name: $name, phoneNumber: $phoneNumber, email: $email, isAdmin: $isAdmin, imageURL: $imageURL}';
  }

  Map<String, dynamic> toMap(){
    return {
      "uid": uid,
      "name": name,
      "phoneNumber": phoneNumber,
      "email": email,
      "isAdmin": isAdmin,
      "imageURL": imageURL,
    };
  }
}