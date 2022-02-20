import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_acer/Util/constants.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPage extends StatefulWidget {
  String? folderName, imageName;
  ImagePickerPage({Key? key, this.folderName, this.imageName}) : super(key: key);

  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {

  String imagePath = "NA";
  final ImagePicker _picker = ImagePicker();
  String text = 'Choose';

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    try {
      await FirebaseStorage.instance
          .ref(widget.folderName!+'/'+widget.imageName.toString()+'.png')
          .putFile(file);
      await FirebaseStorage.instance
          .ref(widget.folderName!+'/'+widget.imageName.toString()+'.png')
          .getDownloadURL()
          .then((value) => imagePath = value.toString());
      text = 'Selected';
      print(imagePath);
      print("UPLOAD SUCCESS");
      ShowSnackBar(message: 'UPLOAD SUCCESS', context: context);

      setState(() {});
      imagePath=='NA'? CircularProgressIndicator()
      : Navigator.pop(context, {'imageURL': imagePath, 'imageName': widget.imageName=='' ? 'image' : widget.imageName.toString()+'.png'});

    } on FirebaseException catch (e) {
      print("UPLOAD FAILED");
      ShowSnackBar(message: 'UPLOAD FAILED', context: context);
    }
  }


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
              child: Text('Pick Image', style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Click on "Choose" button to Select Image', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),),
                OutlinedButton(
                  onPressed: () async {
                    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                    uploadFile(image!.path);
                  },
                  child: Text(text, style: TextStyle(color: Colors.white),),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                  ),
                ),
              ],
            ),
          ),
        );
        /*return Container(
          height: 55,
          width: 300,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.grey.shade100,
          ),
          child: Row(
            children: [
              OutlinedButton(
                onPressed: () async {
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  uploadFile(image!.path);

                  setState(() {
                    // imagePath = image!.path;
                    text = imagePath;
                  });

                  // Navigator.pop(context, imagePath);

                },
                child: Text('Choose', style: TextStyle(color: Colors.white),),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                ),
              ),
              Container(
                width: 200,
                height: 35,
                child: Center(
                  child: Text(text, style: TextStyle(color: Colors.grey),),
                ),
              ),
            ],
          ),
        );*/
  }
}
