import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:blackpink/common/before_after/before_after.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../common/common.dart';
import 'package:flutter/material.dart';
import 'package:easy_model/easy_model.dart';
import 'package:dio/dio.dart';
import '../model/all_model.dart';

import 'package:clippy_flutter/ticket.dart';

// import '../showcase_timeline.dart';

class GenerationPage extends StatelessWidget {
  GlobalModel globalModel;
  ModelTwo modelTwo;

  bool isProcessing = false;
  bool isCompleted = false;

  _openGallery(BuildContext context, bool isGallery) async {
    ImageSource imgSrc;
    if (isGallery)
      imgSrc = ImageSource.gallery;
    else
      imgSrc = ImageSource.camera;
    var picture = await ImagePicker.platform.pickImage(source: imgSrc);

    print(picture.path);
    modelTwo.pathContentImg = picture.path;
    modelTwo.refresh();

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
                  // GestureDetector(
                  //   child: Text("Camera"),
                  //   onTap: () {
                  //     _openGallery(context, false);
                  //   },
                  // ),
                ],
              ),
            ),
          );
        });
  }

  void _loadStyleModelList() {
    globalModel = ModelGroup.findModel<GlobalModel>();
    // await globalModel.reloadStyleModel();
  }

  Future<void> _showChoiceStyleModelDialog(BuildContext context) async {
    // # waiting for reload model list
    await globalModel.reloadStyleModel();
    var images = globalModel.styleModelList;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select a style model!"),
            content: Container(
              padding: EdgeInsets.all(1.0),
              child: GridView.builder(
                itemCount: images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return FlatButton(
                    onPressed: () {
                      // print(images[index]['style_link']);
                      modelTwo.idStyleModel = index;
                      modelTwo.refresh();

                      isProcessing = false;
                      Navigator.of(context).pop();
                    },
                    child: CachedNetworkImage(
                      imageUrl:
                          '${globalModel.basehttpServer}${images[index]['style_link']}',
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  );
                },
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    modelTwo = ModelGroup.findModel<ModelTwo>();

    _loadStyleModelList();
    var images = globalModel.styleModelList;

    return Scaffold(
      appBar: AppBar(
        title: Text('annyeonghaseyo'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 250.0,
            height: 100.0,
            child: TyperAnimatedTextKit(
              onTap: () {
                print('Tap Event');
              },
              text: [
                'It is not enough to do your best,',
                'you must know what to do,',
                'and then do your best',
                '- W.Edwards Deming',
              ],
              textStyle: TextStyle(fontSize: 30.0, fontFamily: 'Bobbers'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tạo ảnh nghệ thuật",
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.red,
                    )),
                FlatButton(
                  onPressed: () {
                    // clear state
                    modelTwo.canFusion = true;
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxHeight: 350),
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                TimelineTile(
                  axis: TimelineAxis.horizontal,
                  alignment: TimelineAlign.manual,
                  lineXY: 0.9,
                  isFirst: true,
                  isLast: false,
                  startChild: Container(
                    constraints:
                        const BoxConstraints(maxWidth: 250, minWidth: 250),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        highlightColor: Colors.pink[100],
                        onPressed: () async {
                          if (isProcessing) return;
                          // isProcessing = true;

                          // var picture = await ImagePicker.platform
                          //     .pickImage(source: ImageSource.gallery);
                          // // print(picture.path);
                          // modelTwo.pathContentImg = picture.path;
                          // modelTwo.refresh();
                          _showChoiceDialog(context);
                          // isProcessing = false;
                          // print("OK");
                        },
                        child: Ticket(
                          radius: 20,
                          child: modelTwo.pathContentImg == ""
                              ? Icon(Icons.add_a_photo)
                              : Image.file(
                                  File('${modelTwo.pathContentImg}'),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                  ),
                  endChild: Center(
                    child: Text(
                      "Ảnh được chọn",
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                  beforeLineStyle: const LineStyle(
                    color: Colors.red,
                    thickness: 6,
                  ),
                  afterLineStyle: const LineStyle(
                    color: Colors.red,
                    thickness: 6,
                  ),
                  indicatorStyle: IndicatorStyle(
                    height: 20,
                    color: Colors.red,
                    padding: const EdgeInsets.all(1),
                    iconStyle: IconStyle(
                      color: Colors.white,
                      iconData: Icons.insert_emoticon,
                    ),
                  ),
                ), // 1
                TimelineTile(
                  axis: TimelineAxis.horizontal,
                  alignment: TimelineAlign.manual,
                  lineXY: 0.9,
                  isFirst: false,
                  isLast: false,
                  startChild: Container(
                    constraints: const BoxConstraints(
                      minWidth: 250,
                      maxWidth: 250,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        highlightColor: Colors.pink[100],
                        onPressed: () async {
                          if (isProcessing) return;
                          isProcessing = true;
                          _showChoiceStyleModelDialog(context);
                        },
                        child: Ticket(
                          radius: 20,
                          child: modelTwo.idStyleModel == -1
                              ? Icon(Icons.add_a_photo)
                              : CachedNetworkImage(
                                  // ${globalModel.basehttpServer}${images[0]['style_link']}
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      '${globalModel.basehttpServer}${globalModel.styleModelList[modelTwo.idStyleModel]['style_link']}',
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                        ),
                      ),
                    ),
                  ),
                  endChild: Center(
                    child: Text(
                      "Chọn phong cách",
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                  beforeLineStyle: const LineStyle(
                    color: Colors.red,
                    thickness: 6,
                  ),
                  afterLineStyle: const LineStyle(
                    color: Colors.red,
                    thickness: 6,
                  ),
                  indicatorStyle: IndicatorStyle(
                    height: 20,
                    color: Colors.red,
                    padding: const EdgeInsets.all(1),
                    iconStyle: IconStyle(
                      color: Colors.white,
                      iconData: Icons.insert_emoticon,
                    ),
                  ),
                ), //2
                TimelineTile(
                  axis: TimelineAxis.horizontal,
                  alignment: TimelineAlign.manual,
                  lineXY: 0.9,
                  isFirst: false,
                  isLast: true,
                  startChild: Container(
                    constraints:
                        const BoxConstraints(minWidth: 250, maxWidth: 250),
                    child: FlatButton(
                      highlightColor: Colors.pink[100],
                      onPressed: () async {
                        if (modelTwo.canFusion) {
                          //upload content image
                          if (modelTwo.pathContentImg == "") {
                            print("Have you pick a content image?");
                            return;
                          }
                          var upload = await globalModel
                              .uploadImageFile(modelTwo.pathContentImg);
                          if (upload == null || upload.statusCode != 200) {
                            print("Have you Uploaded?");
                            return;
                          }
                          // request gen image
                          var dataGenImage = {
                            'idimg_input': upload.data['idupimg'],
                            'idsm_input': globalModel
                                .styleModelList[modelTwo.idStyleModel]['idsm'],
                          };
                          // globalModel.postCreateGenImageData['idimg_input'] =
                          //     upload.data['idupimg'];
                          // globalModel.postCreateGenImageData['idsm_input'] =
                          //     globalModel.styleModelList[modelTwo.idStyleModel]
                          //         ['idsm'];
                          var idimg_input = upload.data['idupimg'];
                          var idsm_input = globalModel
                              .styleModelList[modelTwo.idStyleModel]['idsm'];
                          var response = await globalModel.createGenImageTask(
                              idimg_input, idsm_input);

                          print(response);
                          if (response != null && response.statusCode == 200) {
                            // modelTwo.canFusion =
                            //     false; // -> check isComplete of idgenimg
                            // modelTwo.refresh();
                          }
                          modelTwo.infoStyledImg = response.data;
                          print(modelTwo.infoStyledImg);
                          modelTwo.canFusion = false;
                          modelTwo.refresh();
                        } else {
                          // reload
                          // print(modelTwo.infoStyledImg);
                          // print(modelTwo.infoStyledImg['idgenimg'].runtimeType);
                          // print(modelTwo
                          //     .infoStyledImg['isCompleted'].runtimeType);
                          var response = await globalModel.getGenImageProgress(
                              modelTwo.infoStyledImg['idgenimg']);
                          // print(response);
                          if ((response != null) &&
                              (response.statusCode == 200)) {
                            modelTwo.infoStyledImg = response.data;
                            if (modelTwo.infoStyledImg['isCompleted']) {
                              // show output image
                              // modelTwo.infoStyledImg['output_img']
                              isCompleted = true;
                              modelTwo.refresh();

                              // show compare
                              var beforeImg = modelTwo.pathContentImg;

                              // var afterImg =
                              //     '${modelTwo.infoStyledImg['output_img']}';
                              var afterImg = CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl:
                                    '${modelTwo.infoStyledImg['output_img']}',
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              );

                              push(
                                  context,
                                  (ctx, model) => Compare2Image(
                                        beforeImg: beforeImg,
                                        afterImg: afterImg,
                                      ),
                                  () => ModelThree());
                            }
                            // print(response);
                          } // else {}

                          modelTwo.hasResult = true;
                          modelTwo.refresh();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Ticket(
                          radius: 20,
                          child: modelTwo.canFusion
                              ? Image.asset('assets/images/Polymerization.png')
                              // : !modelTwo.hasResult
                              : !modelTwo.infoStyledImg['isCompleted']
                                  ? Image.asset('assets/images/Reload.png')
                                  // : !modelTwo.infoStyledImg['isComplete']
                                  //     ? Image.asset('assets/images/Reload.png')
                                  : CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          '${modelTwo.infoStyledImg['output_img']}',
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                        ),
                      ),
                    ),
                  ),
                  endChild: Center(
                    child: Text(
                      "Kết quả",
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                  beforeLineStyle: const LineStyle(
                    color: Colors.red,
                    thickness: 6,
                  ),
                  afterLineStyle: const LineStyle(
                    color: Colors.red,
                    thickness: 6,
                  ),
                  indicatorStyle: IndicatorStyle(
                    height: 20,
                    color: Colors.red,
                    padding: const EdgeInsets.all(1),
                    iconStyle: IconStyle(
                      color: Colors.white,
                      iconData: Icons.access_time,
                    ),
                  ),
                ), //3
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Compare2Image extends StatefulWidget {
  final String beforeImg;
  final CachedNetworkImage afterImg;

  const Compare2Image({Key key, this.beforeImg, this.afterImg})
      : super(key: key);
  @override
  _Compare2ImageState createState() => _Compare2ImageState();
}

class _Compare2ImageState extends State<Compare2Image> {
  // String dirpath;
  // Future<String> getFilePath(uniqueFileName) async {
  //   String path = '';

  //   Directory dir = await getApplicationDocumentsDirectory();

  //   path = '${dir.path}/$uniqueFileName';

  //   return path;
  // }

  // Future<void> downloadFile(uri, fileName) async {
  //   // setState(() {
  //   //   downloading = true;
  //   // });

  //   String savePath = await getFilePath(fileName);
  //   dirpath = savePath;
  //   Dio dio = Dio();

  //   dio.download(
  //     uri,
  //     savePath,
  //     onReceiveProgress: (rcv, total) {
  //       // print(
  //       //     'received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');

  //       // setState(() {
  //       //   progress = ((rcv / total) * 100).toStringAsFixed(0);
  //       // });

  //       // if (progress == '100') {
  //       //   setState(() {
  //       //     isDownloaded = true;
  //       //   });
  //       // } else if (double.parse(progress) < 100) {}
  //     },
  //     deleteOnError: true,
  //   ).then((_) {
  //     // setState(() {
  //     //   if (progress == '100') {
  //     //     isDownloaded = true;
  //     //   }

  //     //   downloading = false;
  //     // });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // String uri = '${widget.afterImg}'; // url of the file to be downloaded

    // String filename = uri.split('/').last; // file name that you desire to keep

    // await downloadFile(uri, filename);

    return Scaffold(
      appBar: AppBar(
        title: Text('compare'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: BeforeAfter(
              beforeImage: Image.file(
                File(widget.beforeImg),
                // width: 400,
                // height: 400,
              ),
              afterImage: widget.afterImg, // Image.file(
              // File(dirpath),
              // width: 400,
              // height: 400,
              // ),
              // width: 400,
              // height: 400,
            ),
          ),
        ],
      ),
    );
  }
}
