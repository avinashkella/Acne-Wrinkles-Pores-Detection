import 'dart:io';

import 'package:disease_detection/diseases/skin_types.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SkinTypesPicture extends StatefulWidget {
  const SkinTypesPicture({Key? key}) : super(key: key);

  @override
  _SkinTypesPictureState createState() => _SkinTypesPictureState();
}

class _SkinTypesPictureState extends State<SkinTypesPicture> {
  File? _avatarImage;
  ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
            ),
            Center(
              child: GestureDetector(
                onTap: () => _displayPicker(context),
                child: CircleAvatar(
                  radius: 110,
                  // ignore: unnecessary_null_comparison
                  child: _avatarImage != null
                      ? ClipOval(
                          child: SizedBox(
                            width: 210,
                            height: 210,
                            child: Image.file(
                              _avatarImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          width: 180,
                          height: 180,
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.lightBlue.shade300,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              (SkinTypesDetection(image: _avatarImage))));
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 40),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [(Colors.blue), (Colors.lightBlue.shade300)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight),
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 50,
                          color: Color(0xffEEEEEE)),
                    ],
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future pickImageFromGallery() async {
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    setState(() {
      _avatarImage = File(pickedFile!.path);
    });
  }

  Future pickImageFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    setState(() {
      _avatarImage = pickedFile as File;
    });
  }

  void _displayPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Gallery'),
                    onTap: () {
                      pickImageFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    pickImageFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
