import 'dart:io';

import 'package:disease_detection/welcome/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class AcneDetectionPage extends StatefulWidget {
  final File? image;

  const AcneDetectionPage({required this.image, Key? key}) : super(key: key);

  @override
  _AcneDetectionPageState createState() => _AcneDetectionPageState();
}

class _AcneDetectionPageState extends State<AcneDetectionPage> {
  late File? _image;
  List _classifiedResult = [];

  @override
  void initState() {
    _image = widget.image;
    super.initState();
    loadModel();
    predictImage(_image!);
  }

  Future loadModel() async {
    Tflite.close();
    String result;
    result = (await Tflite.loadModel(
      model: 'assets/machine_learning/acne/model.tflite',
      labels: 'assets/machine_learning/acne/labels.txt',
    ))!;
    print(result);
  }

  Future<List> predictImage(File image) async {
    print(image.path);
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 3,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _classifiedResult = output!;
    });
    print(output);
    return output!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 400,
              child: Center(
                child: Image.file(_image!),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                '${_classifiedResult[0]['confidence'].round() * 100}% ${_classifiedResult[0]['label'].substring(1)}!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => (WelcomePage())));
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 70),
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
                    "Home Page",
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
}
