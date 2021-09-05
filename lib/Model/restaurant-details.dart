class Restaurant{
  String? name;
  String? categories;
  int? pricePerPerson;
  double? ratings;
  String? imageURL;

  Restaurant({this.name, this.categories, this.pricePerPerson, this.ratings, this.imageURL});

  toMap() => {
    'name' : name,
    'categories' : categories,
    'pricePerPerson' : pricePerPerson,
    'ratings' : ratings,
    'imageURL' : imageURL,
  };

  @override
  String toString() {
    return 'Restaurant{name: $name, categories: $categories, pricePerPerson: $pricePerPerson, ratings: $ratings, url: $imageURL}';
  }
}