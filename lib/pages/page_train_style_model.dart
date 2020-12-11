import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:blackpink/api/all_api_helper.dart';
import 'package:blackpink/common/common.dart';
import 'package:blackpink/pages/page_image_style_transfer_selector.dart';
import 'package:blackpink/pages/page_style_model_selector.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_model/easy_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blackpink/common/stepper_code_helper.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class TrainStyleModelPage extends StatefulWidget {
  @override
  _TrainStyleModelPageState createState() => _TrainStyleModelPageState();
}

class _TrainStyleModelPageState extends State<TrainStyleModelPage> {
  var currentActiveState = 0;
  // String selectedCategory;
  // static String selectedSubCategory;
  // String productDescription;
  // String productPrice;
  List<Step> reloadSteps;
  // List<String> subCategorylist;
  bool errorFlag = false;
  bool stepPassingFlag = false;
  // var categories = StepperCodeHelper.categories;

  BuildContext myContext;
  ModelImageStyleTransfer model;
  GlobalModel globalModel;

  // var key0 = GlobalKey<FormFieldState>();
  // var key1 = GlobalKey<FormFieldState>();

  @override
  void initState() {
    // TODO: implement initState
    // subCategorylist = StepperCodeHelper.fillSubCategoryList(selectedCategory);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    reloadSteps = buildStepperSteps();
    myContext = context;
    globalModel = ModelGroup.findModel<GlobalModel>();
    model = ModelGroup.findModel<ModelImageStyleTransfer>();

    return
        // Theme(
        //     data: ThemeData(
        //         primaryColor: Colors.teal, accentColor: Colors.teal.shade800),
        //     child:
        Scaffold(
      appBar: AppBar(
        title: Text("Đăng kí tạo style"),
      ),
      body: SingleChildScrollView(
        child: Stepper(
          steps: reloadSteps,
          currentStep: currentActiveState,
          onStepCancel: () async {
            await pool.play(globalModel.soundIdClicked2);

            setState(() {
              if (currentActiveState > 0) {
                errorFlag = false;
                currentActiveState--;
              } else {
                currentActiveState = 0;
              }
            });
          },
          onStepContinue: () async {
            // setState(() {
            await pool.play(globalModel.soundIdClicked2);

            model.refresh();
            // chi gui 1 lan thoi
            // can reset lai isProcessing khi muon doi sang kieu khac
            if (currentActiveState == 1 && model.isProcessing == false) {
              // gen image task
              var result = await ImageApiHelper.postGenStyleModelTask(
                globalModel.authToken,
                model.indexSelected['idupimg'],
              );

              if (result != null) {
                if (result.statusCode == 201) {
                  model.isProcessing = true;
                  print("create successfully train style model gen task");
                  print(result.data);
                  model.genStyleTrainInfo = result.data;
                  await pool.play(globalModel.soundIdTing);
                } else {
                  print(result);
                  return;
                }
              } else
                return;
            }
            // if (currentActiveState == 4) {
            //   // reload check isComplete isSucessful
            //   var idGenImg = model.outputImage['idgenimg'];
            //   var result = await ImageApiHelper.getGenImageTask(
            //     globalModel.authToken,
            //     idGenImg,
            //   );
            //   if (result != null && result.statusCode == 200) {
            //     print(result.data);
            //     model.outputImage = result.data;
            //   }
            //   // print(result);
            // }
            _shouldContinue();
            model.refresh();
            // });
          },
        ),
      ),
      // ),
    );
  }

  void _shouldContinue() {
    print(currentActiveState);
    switch (currentActiveState) {
      case 0:
        if (model.indexSelected != null) {
          errorFlag = false;
          currentActiveState = 1;
        } else {
          errorFlag = true;
        }
        break;
      case 1:
        if (model.genStyleTrainInfo != null) {
          errorFlag = false;
          currentActiveState = 2;
        } else {
          errorFlag = true;
        }
        break;
      case 2:
        if (model.genStyleTrainInfo != null) {
          // key0.currentState.save();
          errorFlag = false;
          currentActiveState = 2;
        } else {
          errorFlag = true;
        }
        break;
    }
  }

  List<Step> buildStepperSteps() {
    var myStepList = [
      Step(
          title: Text("Chọn ảnh cho style nè"),
          content: buildImageSelector(),
          isActive: true,
          subtitle: model.indexSelected != null
              ? Text("Choice: ${model.indexSelected['idupimg']}")
              : Text('chọn đi bro'),
          state: _stateUpdate(0)),
      Step(
          title: Text("Đăng kí huấn luyện style nè"),
          content: buildTrainStyleModelQueue(),
          isActive: true,
          subtitle: Text('Hãy chọn một tấm ảnh'),
          state: _stateUpdate(1)),
      Step(
          title: Text("Kết quả đăng kí"),
          content: buildTrainStyleQueueResult(),
          isActive: true,
          subtitle: Text("Chúc mừng bạn đăng kí roài"),
          state: _stateUpdate(2)),
    ];
    return myStepList;
  }

  Future<Size> _calculateImageDimension(String imgFile) {
    Completer<Size> completer = Completer();
    Image image = Image.file(File(imgFile));

    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
        },
      ),
    );

    return completer.future;
  }

  _openGallery(BuildContext context, int choice) async {
    var globalModel = ModelGroup.findModel<GlobalModel>();
    var model = ModelGroup.findModel<ModelImageStyleTransfer>();
    ImageSource imgSrc;
    await pool.play(globalModel.soundIdClicked2);

    if (choice == 0)
      imgSrc = ImageSource.gallery;
    else if (choice == 1)
      imgSrc = ImageSource.camera;
    else if (choice == 2) {
      var result = await ImageApiHelper.getImagesLib(globalModel.authToken);

      if (result != null && result.statusCode == 200) {
        model.imagesSelector = result.data;
        print(model.imagesSelector);
        Navigator.of(context).pop();
        pushTransition(myContext, (ctx, model) => ImageSelectorPage(),
            () => ModelImageLibPage(),
            type: PageTransitionType.scale);
      } else {
        print('ModelImageStyleTransfer getImagesLib error');
      }

      // Navigator.of(myContext).pop();
      // Navigator.pop(context);
      return;
    }

    var picture = await ImagePicker.platform.pickImage(source: imgSrc);

    if (picture == null) return;
    print(picture.path);

    model.pathContentImg = picture.path;

    Navigator.of(context).pop();

    // check size
    var size = await _calculateImageDimension(picture.path);
    var multiply = size.width * size.height;
    print('${size.width} - ${size.height}');
    if (multiply > MAXIMAGESIZE) {
      var str =
          "Độ phân giải hình ảnh vượt quá giới hạn, đang tiến hành resize ảnh!";
      // final snackBar = SnackBar(content: Text(str));
      // Scaffold.of(myContext).showSnackBar(snackBar);
      print(str);
      img.Image image_resize =
          img.decodeImage(new File(picture.path).readAsBytesSync());

      img.Image thumbnail;
      if (size.width > 3000) {
        thumbnail = img.copyResize(image_resize, width: 2500);
      } else {
        thumbnail = img.copyResize(image_resize, height: 2500);
      }

      final extDir = await getExternalStorageDirectory();
      var fileName = picture.path.split('/').last;
      var noExtension = fileName.split('.').first;
      var pathResult = '${extDir.path}/${noExtension}_resized.jpg';
      new File(pathResult)..writeAsBytesSync(img.encodeJpg(thumbnail));
      model.pathContentImg = pathResult;
      print(pathResult);
      // model.pathContentImg = pathResult;
    }

    // upload content
    var response = await ImageApiHelper.uploadFile(
      ApiHelper.baseUrl + ApiHelper.uploadImageUrl,
      globalModel.authToken,
      model.pathContentImg,
      onSentProgress: (sent, total) async {
        if (total > 0) {
          print('$sent / $total');

          // setState(() {
          model.uploadValue = sent / total * 100.0;
          model.uploadValue = model.uploadValue.floorToDouble();
          // });
          model.refresh();
          if (model.uploadValue >= 100)
            await pool.play(globalModel.soundIdTing);
        }
      },
    );
    print(response);
    print(response.statusCode);

    if (response != null && response.statusCode == 200) {
      print(response.data);

      var imgContent = await ImageApiHelper.getImagesWithID(
          globalModel.authToken, response.data['idupimg']);
      if (imgContent != null && imgContent.statusCode == 200) {
        print(imgContent.data);
        model.indexSelected = imgContent.data;
        // model.refresh();
      }
    }
    model.refresh();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    var model = ModelGroup.findModel<ModelImageStyleTransfer>();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a choice!"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  FlatButton(
                    child: Container(
                      child: Text("Gallery"),
                      width: 200,
                    ),
                    onPressed: () {
                      _openGallery(context, 0);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                  ),
                  FlatButton(
                    child: Container(
                      child: Text("Camera"),
                      width: 200,
                    ),
                    onPressed: () {
                      _openGallery(context, 1);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                  ),
                  FlatButton(
                    child: Container(
                      child: Text("Library"),
                      width: 200,
                    ),
                    onPressed: () {
                      _openGallery(context, 2);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildImageSelector() {
    model = ModelGroup.findModel<ModelImageStyleTransfer>();

    return Container(
      child: Row(
        children: <Widget>[
          AvatarGlow(
            endRadius: 40,
            duration: Duration(seconds: 2),
            glowColor: Colors.redAccent,
            repeat: true,
            child: Container(
              constraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                iconSize: 40,
                onPressed: () async {
                  _showChoiceDialog(context);
                },
              ),
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 100, maxWidth: 150),
            child: model.uploadValue > 0 && model.uploadValue < 100
                ? Text('${model.uploadValue}%')
                : model.indexSelected != null
                    ? CachedNetworkImage(
                        imageUrl: recheckUrl(model.indexSelected['uploadfile']),
                        errorWidget: (_, __, ___) => Icon(Icons.adb),
                      )
                    : Icon(Icons.airline_seat_individual_suite),
          ),
        ],
      ),
    );
  }

  Widget buildTrainStyleModelQueue() {
    model = ModelGroup.findModel<ModelImageStyleTransfer>();

    return Container(
      child: Row(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(maxWidth: 200),
            child: model.genStyleTrainInfo != null
                ? Text('Gửi yêu cầu tạo phong cách mới thành công')
                : Text('CONTINUE! để gửi yêu cầu nha bro'),
          ),
        ],
      ),
    );
  }

  Widget buildTrainStyleQueueResult() {
    model = ModelGroup.findModel<ModelImageStyleTransfer>();

    return Container(
      child: Row(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(maxHeight: 100, maxWidth: 150),
            child: model.indexSelected != null
                ? CachedNetworkImage(
                    imageUrl: recheckUrl(model.indexSelected['uploadfile']),
                    errorWidget: (_, __, ___) => Icon(Icons.adb),
                  )
                : Icon(Icons.airline_seat_individual_suite),
          ),
          SizedBox(
            width: 30,
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 150),
            child: model.genStyleTrainInfo != null
                ? Text('số thứ tự: ${model.genStyleTrainInfo['idsm']}')
                : Icon(Icons.cloud_queue),
          ),
        ],
      ),
    );
  }

  StepState _stateUpdate(int stateNumber) {
    if (currentActiveState == stateNumber) {
      if (errorFlag) {
        return StepState.error;
      } else {
        return StepState.editing;
      }
    } else {
      return StepState.complete;
    }
  }
}
