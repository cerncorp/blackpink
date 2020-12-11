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

class ImageSTPage extends StatefulWidget {
  @override
  _ImageSTPageState createState() => _ImageSTPageState();
}

class _ImageSTPageState extends State<ImageSTPage> {
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
  ModelImageStyleTransfer istStepperModel;
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
    istStepperModel = ModelGroup.findModel<ModelImageStyleTransfer>();

    return
        // Theme(
        //     data: ThemeData(
        //         primaryColor: Colors.teal, accentColor: Colors.teal.shade800),
        //     child:
        Scaffold(
      appBar: AppBar(
        title: Text("Image Style Transfer Stepper"),
      ),
      body: SingleChildScrollView(
        child: Stepper(
          steps: reloadSteps,
          currentStep: currentActiveState,
          onStepCancel: () {
            setState(() {
              pool.play(globalModel.soundIdClicked2);

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
            var globalModel = ModelGroup.findModel<GlobalModel>();

            await pool.play(globalModel.soundIdClicked2);
            istStepperModel.refresh();
            // chi gui 1 lan thoi
            // can reset lai isProcessing khi muon doi sang kieu khac
            if (currentActiveState == 3 &&
                istStepperModel.isProcessing == false) {
              print(
                  "Dang xu ly... ${istStepperModel.indexSelected['idupimg']} - ${istStepperModel.indexStyleSelected['idsm']}");
              // gen image task
              var result = await ImageApiHelper.postGenImageTask(
                globalModel.authToken,
                istStepperModel.indexSelected['idupimg'],
                istStepperModel.indexStyleSelected['idsm'],
              );
              if (result != null) {
                if (result.statusCode == 201) {
                  istStepperModel.isProcessing = true;
                  print("create successfully image gen task");
                  print(result.data);
                  istStepperModel.outputImage = result.data;
                } else {
                  print(result);
                  return;
                }
              } else
                return;
            }
            if (currentActiveState == 4) {
              // reload check isComplete isSucessful
              var idGenImg = istStepperModel.outputImage['idgenimg'];
              var result = await ImageApiHelper.getGenImageTask(
                globalModel.authToken,
                idGenImg,
              );
              if (result != null && result.statusCode == 200) {
                print(result.data);
                istStepperModel.outputImage = result.data;
              }
              // print(result);
            }
            _shouldContinue();
            istStepperModel.refresh();
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
        if (istStepperModel.indexSelected != null) {
          errorFlag = false;
          currentActiveState = 1;
        } else {
          errorFlag = true;
        }
        break;
      case 1:
        if (istStepperModel.indexStyleSelected != null) {
          errorFlag = false;
          currentActiveState = 2;
        } else {
          errorFlag = true;
        }
        break;
      case 2:
        if (istStepperModel.indexSelected != null &&
            istStepperModel.indexStyleSelected != null) {
          // key0.currentState.save();
          errorFlag = false;
          currentActiveState = 3;
        } else {
          errorFlag = true;
        }
        break;
      case 3:
        if (istStepperModel.isProcessing) {
          errorFlag = false;
          currentActiveState = 4;
        } else {
          errorFlag = true;
        }
        break;
      case 4:
        currentActiveState = 4;
        break;
    }
  }

  List<Step> buildStepperSteps() {
    var myStepList = [
      Step(
          title: Text("Chọn ảnh nè"),
          content: buildImageSelector(),
          isActive: true,
          subtitle: istStepperModel.indexSelected != null
              ? Text("Choice: ${istStepperModel.indexSelected['idupimg']}")
              : Text('chọn đi bro'),
          state: _stateUpdate(0)),
      Step(
          title: Text("Chọn phong cách nghệ thuật nè"),
          content: buildStyleModelSelector(),
          isActive: true,
          subtitle: istStepperModel.indexStyleSelected != null
              ? Text(
                  "Choice :${istStepperModel.indexStyleSelected['outputmodel']}")
              : Text('Hãy chọn một tấm ảnh'),
          state: _stateUpdate(1)),
      Step(
          title: Text("Kiểm tra nè"),
          content: buildImageStyleTransferInfo(),
          isActive: true,
          subtitle: Text("content + style"),
          state: _stateUpdate(2)),
      Step(
          title: Text("Tạo Ảnh Phong Cách Thôi"),
          content: buildFinishStage(),
          isActive: true,
          subtitle: Text("Good luck!"),
          state: _stateUpdate(3)),
      Step(
          title: Text("Xem kết quả nè"),
          content: buildReloadOutputStage(),
          subtitle: Text("Tiến trình: đang xử lý"),
          isActive: true,
          state: _stateUpdate(4)),
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
    var istModel = ModelGroup.findModel<ModelImageStyleTransfer>();
    ImageSource imgSrc;
    await pool.play(globalModel.soundIdClicked2);
    if (choice == 0)
      imgSrc = ImageSource.gallery;
    else if (choice == 1)
      imgSrc = ImageSource.camera;
    else if (choice == 2) {
      var result = await ImageApiHelper.getImagesLib(globalModel.authToken);

      if (result != null && result.statusCode == 200) {
        istModel.imagesSelector = result.data;
        print(istModel.imagesSelector);
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

    istModel.pathContentImg = picture.path;

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
      istModel.pathContentImg = pathResult;
      print(pathResult);
      // istModel.pathContentImg = pathResult;
    }

    // upload content
    var response = await ImageApiHelper.uploadFile(
      ApiHelper.baseUrl + ApiHelper.uploadImageUrl,
      globalModel.authToken,
      istModel.pathContentImg,
      onSentProgress: (sent, total) async {
        if (total > 0) {
          print('$sent / $total');

          // setState(() {
          istModel.uploadValue = sent / total * 100.0;
          istModel.uploadValue = istModel.uploadValue.floorToDouble();
          // });
          istModel.refresh();

          if (istModel.uploadValue >= 100.0)
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
        istModel.indexSelected = imgContent.data;
        // istModel.refresh();
      }
    }
    istModel.refresh();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    var istModel = ModelGroup.findModel<ModelImageStyleTransfer>();

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
                      width: 100,
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
                      width: 100,
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
                      width: 100,
                    ),
                    onPressed: () {
                      _openGallery(context, 2);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildImageSelector() {
    istStepperModel = ModelGroup.findModel<ModelImageStyleTransfer>();

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
                  // var globalModel = ModelGroup.findModel<GlobalModel>();
                  // var istModel =
                  //     ModelGroup.findModel<ModelImageStyleTransfer>();
                  // var result =
                  //     await ImageApiHelper.getImagesLib(globalModel.authToken);

                  // if (result != null && result.statusCode == 200) {
                  //   istModel.imagesSelector = result.data;
                  //   print(istModel.imagesSelector);
                  //   pushTransition(
                  //       myContext,
                  //       (ctx, model) => ImageSelectorPage(),
                  //       () => ModelImageLibPage(),
                  //       type: PageTransitionType.scale);
                  // } else {
                  //   print('ModelImageStyleTransfer getImagesLib error');
                  // }
                },
              ),
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 100, maxWidth: 150),
            child: istStepperModel.uploadValue > 0 &&
                    istStepperModel.uploadValue < 100
                ? Text('${istStepperModel.uploadValue}%')
                : istStepperModel.indexSelected != null
                    ? CachedNetworkImage(
                        imageUrl: recheckUrl(
                            istStepperModel.indexSelected['uploadfile']),
                        errorWidget: (_, __, ___) => Icon(Icons.adb),
                      )
                    : Icon(Icons.airline_seat_individual_suite),
          ),
        ],
      ),
    );
  }

  Widget buildStyleModelSelector() {
    istStepperModel = ModelGroup.findModel<ModelImageStyleTransfer>();

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
                  var globalModel = ModelGroup.findModel<GlobalModel>();
                  var istModel =
                      ModelGroup.findModel<ModelImageStyleTransfer>();
                  var result =
                      await ApiHelper.loadStyleModel(globalModel.authToken);

                  if (result != null && result.statusCode == 200) {
                    var listFilter = List<Map<String, dynamic>>();
                    for (var item in result.data) {
                      if (item['isCompleted'] && item['isSuccess'])
                        listFilter.add(item);
                    }

                    istModel.styleSelector = listFilter;
                    print(istModel.styleSelector);
                    pushTransition(
                        myContext,
                        (ctx, model) => StyleModelSelectorPage(),
                        () => ModelStyleModelSelector(),
                        type: PageTransitionType.scale);
                  } else {
                    print('ModelImageStyleTransfer getImagesLib error');
                  }
                },
              ),
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 100, maxWidth: 150),
            child: istStepperModel.indexStyleSelected != null
                ? CachedNetworkImage(
                    imageUrl: recheckUrl(
                        istStepperModel.indexStyleSelected['style_link']),
                    errorWidget: (_, __, ___) => Icon(Icons.adb),
                  )
                : Icon(Icons.airline_seat_individual_suite),
          ),
        ],
      ),
    );
  }

  Widget buildImageStyleTransferInfo() {
    istStepperModel = ModelGroup.findModel<ModelImageStyleTransfer>();

    return Container(
      child: Row(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(maxHeight: 100, maxWidth: 150),
            child: istStepperModel.indexSelected != null
                ? CachedNetworkImage(
                    imageUrl:
                        recheckUrl(istStepperModel.indexSelected['uploadfile']),
                    errorWidget: (_, __, ___) => Icon(Icons.adb),
                  )
                : Icon(Icons.airline_seat_individual_suite),
          ),
          SizedBox(
            width: 30,
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 100, maxWidth: 150),
            child: istStepperModel.indexStyleSelected != null
                ? CachedNetworkImage(
                    imageUrl: recheckUrl(
                        istStepperModel.indexStyleSelected['style_link']),
                    errorWidget: (_, __, ___) => Icon(Icons.adb),
                  )
                : Icon(Icons.airline_seat_individual_suite),
          ),
        ],
      ),
    );
  }

// buildFinishStage
  Widget buildFinishStage() {
    istStepperModel = ModelGroup.findModel<ModelImageStyleTransfer>();

    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 100, maxWidth: 230),
            child: Text('Hãy gửi yêu cầu chuyển phong cách đến máy chủ xử lý.'),
          ),
        ],
      ),
    );
  }

  Widget buildReloadOutputStage() {
    istStepperModel = ModelGroup.findModel<ModelImageStyleTransfer>();

    return Container(
      child: Row(
        children: <Widget>[
          // SizedBox(
          //   width: 10,
          // ),
          Container(
            constraints: BoxConstraints(maxHeight: 100, maxWidth: 200),
            // child: Container(
            // constraints: BoxConstraints(maxHeight: 100, maxWidth: 150),
            child: istStepperModel.outputImage != null &&
                    istStepperModel.outputImage['idimg_output'] != null
                ? CachedNetworkImage(
                    imageUrl:
                        recheckUrl(istStepperModel.outputImage['output_img']),
                    errorWidget: (_, __, ___) => Icon(Icons.adb),
                  )
                : Text("Đang đợi máy chủ trả về thông điệp thân thương..."),
          ),
          // ),

          SizedBox(width: 15),
          istStepperModel.outputImage != null &&
                  istStepperModel.outputImage['idimg_output'] != null
              ? IconButton(
                  icon: istStepperModel.downloadValue == -1.0
                      ? Icon(Icons.download_rounded)
                      : istStepperModel.downloadValue < 100
                          ? CircularProgressIndicator(
                              backgroundColor: Colors.grey,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.green),
                              value: istStepperModel.downloadValue,
                            )
                          : Icon(Icons.download_done_outlined),
                  iconSize: 30,
                  onPressed: () async {
                    // String file = await _findPath(imgUrl);
                    // print('download $file');
                    var globalModel = ModelGroup.findModel<GlobalModel>();
                    await pool.play(globalModel.soundIdClicked2);
                    if (istStepperModel.downloadValue >= 100) {
                      print("file downloaded, unnessesary!");
                      return;
                    }

                    // final directory = await getApplicationDocumentsDirectory();

                    final extDir = await getExternalStorageDirectory();

                    // return directory.path;
                    String fileName = istStepperModel.outputImage['output_img']
                        .split('/')
                        .last;
                    print(fileName);
                    bool result = await ImageApiHelper.downloadUrl(
                      istStepperModel.outputImage['output_img'],
                      '${extDir.path}/StyleTransfer/$fileName',
                      (received, total) async {
                        if (total != -1) {
                          var percent = (received / total * 100);
                          print(percent.toStringAsFixed(0) + "%");
                          istStepperModel.downloadValue = percent;
                          istStepperModel.refresh();
                          if (percent >= 100) {
                            var globalModel =
                                ModelGroup.findModel<GlobalModel>();
                            await pool.play(globalModel.soundIdTing);
                          }
                        }
                      },
                    );
                    if (result) {
                      print('downloaded $fileName');
                      istStepperModel.refresh();

                      return;
                    }
                    print('Something error when downloaded $fileName');
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  // Widget buildDropDownCategories() {
  //   return Container(
  //     child: Row(
  //       children: <Widget>[
  //         Icon(StepperCodeHelper.iconBuilderCategory(selectedCategory)),
  //         SizedBox(
  //           width: 60,
  //         ),
  //         DropdownButton<String>(
  //           items: categories.map((item) {
  //             return DropdownMenuItem<String>(
  //               child: Text(item),
  //               value: item,
  //             );
  //           }).toList(),
  //           onChanged: (selection) {
  //             setState(() {
  //               selectedCategory = selection;
  //               subCategorylist =
  //                   StepperCodeHelper.fillSubCategoryList(selectedCategory);
  //             });
  //           },
  //           value: selectedCategory == null ||
  //                   !categories.contains(selectedCategory)
  //               ? categories[0]
  //               : selectedCategory,
  //         )
  //       ],
  //     ),
  //   );
  // }

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

  // Widget buildDropDownSubCategories() {
  //   return Container(
  //     child: Row(
  //       children: <Widget>[
  //         Icon(StepperCodeHelper.iconBuilderSubCategory(selectedSubCategory)),
  //         SizedBox(
  //           width: 60,
  //         ),
  //         DropdownButton<String>(
  //           items: subCategorylist.map((item) {
  //             return DropdownMenuItem<String>(
  //               child: Text(item),
  //               value: item,
  //             );
  //           }).toList(),
  //           onChanged: (selection) {
  //             setState(() {
  //               selectedSubCategory = selection;
  //             });
  //           },
  //           value: selectedSubCategory == null ||
  //                   !subCategorylist.contains(selectedSubCategory)
  //               ? subCategorylist[0]
  //               : selectedSubCategory,
  //         )
  //       ],
  //     ),
  //   );
  // }

  // Widget buildProductDescribe() {
  //   return TextFormField(
  //     key: key0,
  //     decoration: InputDecoration(
  //       hintText: "For example: Iphone 11 250 Gb",
  //       border: OutlineInputBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(15))),
  //     ),
  //     // ignore: missing_return
  //     validator: (value) {
  //       if (value.length < 6) return "Cannot lower then 6 characters";
  //     },
  //     onSaved: (value) {
  //       productDescription = value;
  //     },
  //   );
  // }

  // Widget buildProductPrice() {
  //   return TextFormField(
  //     key: key1,
  //     decoration: InputDecoration(
  //       hintText: "100 TL",
  //       border: OutlineInputBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(15))),
  //     ),
  //     // ignore: missing_return
  //     validator: (value) {
  //       if (value.length < 6) {
  //         return "Cannot lower then 6 characters";
  //       }
  //     },
  //     onSaved: (value) {
  //       productPrice = value;
  //     },
  //   );
  // }
}
