import 'dart:io';
// import 'package:before_after/before_after.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slimy_card/slimy_card.dart';
import '../common/before_after/before_after.dart';

class MyImageTestPage extends StatefulWidget {
  @override
  _MyImageTestPageState createState() => _MyImageTestPageState();
}

class _MyImageTestPageState extends State<MyImageTestPage> {
  PickedFile image;
  PickedFile image_2;

  _openGallery(BuildContext context, bool isGallery) async {
    ImageSource imgSrc;
    if (isGallery)
      imgSrc = ImageSource.gallery;
    else
      imgSrc = ImageSource.camera;
    var picture = await ImagePicker.platform.pickImage(source: imgSrc);
    var picture_2 = await ImagePicker.platform.pickImage(source: imgSrc);

    print(picture.path);
    this.setState(() {
      image = picture;
      image_2 = picture_2;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a choice!"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      _openGallery(context, true);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                  ),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      _openGallery(context, false);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        // This streamBuilder reads the real-time status of SlimyCard.
        initialData: false,
        stream: slimyCard.stream, //Stream of SlimyCard
        builder: ((BuildContext context, AsyncSnapshot snapshot) {
          return ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(height: 100),

              // SlimyCard is being called here.
              SlimyCard(
                // In topCardWidget below, imagePath changes according to the
                // status of the SlimyCard(snapshot.data).
                topCardWidget: topCardWidget((snapshot.data)
                    ? 'assets/images/rock_aggresive.jpg'
                    : 'assets/images/rock_calm.jpg'),
                bottomCardWidget: bottomCardWidget(),
                // bottomCardHeight: 500,
              ),
              image == null
                  ? Text("nothing to show")
                  : Image.file(
                      File(image.path),
                      width: 400,
                      height: 400,
                    ),
              (image == null || image_2 == null)
                  ? Text("nothing to show")
                  : Expanded(
                      flex: 1,
                      child: BeforeAfter(
                        beforeImage: Image.file(
                          File(image.path),
                          width: 400,
                          height: 400,
                        ),
                        afterImage: Image.file(
                          File(image_2.path),
                          width: 400,
                          height: 400,
                        ),
                      ),
                    ),
              (image == null || image_2 == null)
                  ? Text("nothing to show")
                  : Expanded(
                      flex: 1,
                      child: BeforeAfter(
                        beforeImage: Image.file(
                          File(image.path),
                          width: 400,
                          height: 400,
                        ),
                        afterImage: Image.file(
                          File(image_2.path),
                          width: 400,
                          height: 400,
                        ),
                        isVertical: true,
                      ),
                    ),
            ],
          );
        }),
      ),
    );
  }

  // This widget will be passed as Top Card's Widget.
  Widget topCardWidget(String imagePath) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(image: AssetImage(imagePath)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
        Text(
          'The Rock',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        SizedBox(height: 15),
        Text(
          'He asks, what your name is. But!',
          style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  // This widget will be passed as Bottom Card's Widget.
  Widget bottomCardWidget() {
    return Column(
      children: [
        GestureDetector(
          child: Text(
            'It doesn\'t matter \nwhat your name is.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          onTap: () {
            _showChoiceDialog(context);
            print(image);
            setState(() {});
          },
        ),
      ],
    );
  }
}
