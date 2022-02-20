import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_acer/Model/address-details.dart';
import 'package:food_acer/Util/constants.dart';
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class AddAddressPage extends StatefulWidget {
  double? lat, long;
  AddAddressPage({Key? key, this.lat, this.long}) : super(key: key);

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {

  Location location = new Location();
  GeoCode geoCode = GeoCode();
  Address? address;
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  Completer<GoogleMapController> _controller = Completer();
  // TextEditingController labelController = TextEditingController(text: 'Place');
  String selectedValue = 'Other';
  GoogleMapController? controller1;

  CameraPosition initPlace = CameraPosition(
    target: LatLng(30.9024779, 75.8201934),
    zoom: 16,
  );

  checkPermissionAndFetchLocation() async{
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    print("Fetching Location");
    _locationData = await location.getLocation();
    print('Location Fetched');

    print("Fetching Address..");
    var addresses = await geoCode.reverseGeocoding(latitude: _locationData!.latitude as double, longitude: _locationData!.longitude as double);
    print('Address Fetched');
    print("Address: $address");

    setState(() {
      address = addresses;
      initPlace = CameraPosition(
        target: LatLng(_locationData!.latitude!, _locationData!.longitude!),
        zoom: 20,
      );

      controller1!.animateCamera(
        CameraUpdate.newCameraPosition(
            initPlace
        ),
      );

    });
  }

  addToDatabase() async{
    var dataToSave = UserAddress(
      label: selectedValue,
      address: address.toString(),
      location: GeoPoint(_locationData!.latitude!, _locationData!.longitude!),
    );

    print('Adding data to database');
    FirebaseFirestore.instance.collection(Util.USER_COLLECTION).doc(Util.appUser!.uid).collection(Util.ADDRESS_COLLECTION).doc().set(await dataToSave.toMap());
    print('Data added to database');
  }

  var items = ['Other', 'Home Place', 'Work Place',];

  @override
  Widget build(BuildContext context) {
    checkPermissionAndFetchLocation();
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
            'Add Address',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height*0.35,
                width: MediaQuery.of(context).size.width,
                child: widget.lat==null ? GoogleMap(
                  initialCameraPosition: initPlace,
                  mapType: MapType.normal,
                  trafficEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    controller1 = controller;
                  },
                  markers: {
                    Marker(
                      markerId: MarkerId('atpl'),
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                      onTap: (){},
                      position: LatLng(_locationData!=null ? _locationData!.latitude as double : 30.9024779, _locationData!=null? _locationData!.longitude as double : 75.8201934),
                      // position: _locationData!=null? LatLng(_locationData!.latitude!, _locationData!.longitude!): LatLng(30.9024779, 75.8201934),
                      infoWindow: InfoWindow(
                        title: address!=null? address!.streetAddress : "",
                        snippet: address!=null? address!.countryName: "",
                        onTap: (){},
                      ),
                    ),
                  },
                ) : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(widget.lat as double, widget.long as double),
                      zoom: 20,
                    ),
                    mapType: MapType.normal,
                    trafficEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers: {
                      Marker(
                        markerId: MarkerId('atpl'),
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                        position: LatLng(widget.lat as double, widget.long as double),
                      ),
                    }
                )
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Divider(height: 20, thickness: 20,),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    margin: EdgeInsets.only(top: 20,),
                    child: address!=null? Column(
                      children: [
                        Text('Current Location - ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                        Text('${address!.streetAddress}'),
                        Text('${address!.city}'),
                        Text('${address!.region}'),
                        Text('${address!.postal}'),
                        Text('${_locationData!.latitude}, ${_locationData!.longitude}'),
                      ],
                    ) : CupertinoActivityIndicator(),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // SizedBox(height: 15,),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 52,
                                width: 300,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.deepPurple.shade50,
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.label_important, color: Colors.grey,),
                                    SizedBox(width: 15,),
                                    Container(
                                      width: 290,
                                      child: DropdownButtonFormField(
                                        isExpanded: true,
                                        decoration: InputDecoration.collapsed(hintText: 'hintText'),
                                        isDense: true,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        value: selectedValue,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedValue = value as String;
                                          });
                                        },
                                        items: items.map((e) {
                                          return DropdownMenuItem(
                                            child: Text(e, style: TextStyle(color: Colors.black54),),
                                            value: e,
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Container(
                          height: 35,
                          width: 100,
                          child: TextButton(
                            onPressed: () {
                              addToDatabase();
                              Navigator.popAndPushNamed(context, '/manageAddress');
                            },
                            child: Text('SAVE', style: TextStyle(color: Colors.white),),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              elevation: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
