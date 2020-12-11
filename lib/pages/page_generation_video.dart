import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../common/common.dart';
import 'package:flutter/material.dart';
import 'package:easy_model/easy_model.dart';
import 'package:dio/dio.dart';
import '../model/all_model.dart';

import 'package:clippy_flutter/ticket.dart';

import 'package:video_player/video_player.dart';

// import '../showcase_timeline.dart';

class GenerationVideoPage extends StatefulWidget {
  @override
  _GenerationVideoPageState createState() => _GenerationVideoPageState();
}

class _GenerationVideoPageState extends State<GenerationVideoPage> {
  GlobalModel globalModel;

  ModelTwo modelTwo;

  bool isProcessing = false;

  bool isCompleted = false;

  String status = "Sa rang hê!";

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  VideoPlayerController _controller_output;
  Future<void> _initializeVideoPlayerFuture_output;

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
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
              // padding: EdgeInsets.all(2.0),
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
        title: Text('Xào nấu'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PartModelWidget<ModelTwo>(
            childBuilder: (ctx, model) => Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${this.status}",
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.red,
                      )),
                ],
              ),
            ),
            partKey: 'ModelTwo.progress',
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tạo phim nghệ thuật",
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.red,
                    )),
                FlatButton(
                  onPressed: () {
                    // clear state
                    modelTwo.canFusion = true;
                    isCompleted = false;
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
                          // FilePickerResult video =
                          //     await FilePicker.platform.pickFiles(
                          //   type: FileType.custom,
                          //   allowedExtensions: ['mp4'],
                          // );
                          var video = await FilePicker.getFilePath(
                              type: FileType.custom,
                              allowedExtensions: ['mp4']);
                          // print(picture.path);
                          if (video != null) {
                            //  File file = File(result.files.single.path);
                            modelTwo.pathContentImg = video;

                            _controller = VideoPlayerController.file(
                                File('${modelTwo.pathContentImg}'));
                            _initializeVideoPlayerFuture =
                                _controller.initialize();

                            // Use the controller to loop the video.
                            _controller.setLooping(true);
                            modelTwo.refresh();
                            this.status = "Chọn ảnh nghệ thuật?";
                            modelTwo.refreshPart('ModelTwo.progress');
                            //upload test
                            print(modelTwo.pathContentImg);
                            // if (modelTwo.pathContentImg == "") {
                            //   print("Have you pick a content image?");
                            //   return;
                            // }

                          } else {
                            // User canceled the picker
                            print('user canceled the picker');
                            return;
                          }
                          // modelTwo.pathContentImg = picture.path;

                          // isProcessing = false;
                          // print("OK");
                        },
                        child: Ticket(
                          radius: 20,
                          child: modelTwo.pathContentImg == ""
                              ? Icon(Icons.add_a_photo)
                              : FutureBuilder(
                                  future: _initializeVideoPlayerFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      // If the VideoPlayerController has finished initialization, use
                                      // the data it provides to limit the aspect ratio of the video.
                                      return AspectRatio(
                                        aspectRatio:
                                            _controller.value.aspectRatio,
                                        // Use the VideoPlayer widget to display the video.
                                        child: VideoPlayer(_controller),
                                      );
                                    } else {
                                      // If the VideoPlayerController is still initializing, show a
                                      // loading spinner.
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
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
                    height: 50,
                    width: 50,
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
                          if (modelTwo.pathContentImg == "" &&
                              modelTwo.idStyleModel >= 0) {
                            print("Have you pick a content image?");
                            return;
                          }
                          // var upload = await globalModel
                          //     .uploadImageFile(modelTwo.pathContentImg);
                          // if (upload == null || upload.statusCode != 200) {
                          //   print("Have you Uploaded?");
                          //   return;
                          // }
                          var upload = await globalModel.uploadVideoFile(
                            modelTwo.pathContentImg,
                            onSentProgress: (int sent, int total) {
                              modelTwo.uploadprogress = sent / total * 100;
                              this.status =
                                  "Uploaded Video: ${modelTwo.uploadprogress.floor()}";
                              modelTwo.refreshPart('ModelTwo.progress');
                              print("Sent: $sent $total");
                            },
                            onReceivedProgress: (int sent, int total) {
                              print("Received: $sent $total");
                            },
                          );
                          if (upload == null || upload.statusCode != 200) {
                            print("Have you Uploaded?");
                            return;
                          }
                          // request gen image
                          // var dataGenImage = {
                          //   'idvid_input': upload.data['idupvid'],
                          //   'idsm_input': globalModel
                          //       .styleModelList[modelTwo.idStyleModel]['idsm'],
                          // };
                          // globalModel.postCreateGenImageData['idimg_input'] =
                          //     upload.data['idupimg'];
                          // globalModel.postCreateGenImageData['idsm_input'] =
                          //     globalModel.styleModelList[modelTwo.idStyleModel]
                          //         ['idsm'];
                          var idvid_input = upload.data['idupvid'];
                          var idsm_input = globalModel
                              .styleModelList[modelTwo.idStyleModel]['idsm'];

                          var response = await globalModel.createGenVideoTask(
                              idvid_input, idsm_input);

                          print(response);
                          if (response != null && response.statusCode == 201) {
                            // modelTwo.canFusion =
                            //     false; // -> check isComplete of idgenimg
                            // modelTwo.refresh();
                            modelTwo.infoStyledImg = response.data;
                            print(modelTwo.infoStyledImg);
                            modelTwo.canFusion = false;
                            modelTwo.refresh();
                          } else {
                            // createTask fail
                          }
                        } else {
                          // reload
                          print(modelTwo.infoStyledImg);
                          // print(modelTwo.infoStyledImg['idgenvid'].runtimeType);
                          // print(modelTwo
                          //     .infoStyledImg['isCompleted'].runtimeType);
                          var response = await globalModel.getGenVideoProgress(
                              modelTwo.infoStyledImg['idgenvid'].toInt());
                          // print(response);
                          if ((response != null) &&
                              (response.statusCode == 200)) {
                            modelTwo.infoStyledImg = response.data;
                            if (modelTwo.infoStyledImg['isCompleted']) {
                              // show output image
                              // modelTwo.infoStyledImg['output_img']
                              if (!isCompleted) {
                                isCompleted = true;

                                _controller_output = VideoPlayerController.network(
                                    '${modelTwo.infoStyledImg['idvid_output_link']}');
                                _initializeVideoPlayerFuture_output =
                                    _controller_output.initialize();

                                // Use the controller to loop the video.
                                _controller_output.setLooping(true);

                                modelTwo.refresh();
                              } else {
                                print('play pause');
                                //play pause
                                setState(() {
                                  // If the video is playing, pause it.
                                  if (_controller_output.value.isPlaying) {
                                    _controller_output.pause();
                                  } else {
                                    // If the video is paused, play it.
                                    _controller_output.play();
                                  }
                                });
                              }
                            } else {
                              // modelTwo.uploadprogress =
                              //     modelTwo.infoStyledImg['progress'].toDouble();
                              this.status =
                                  "GenVideo: ${modelTwo.infoStyledImg['progress']}";
                              modelTwo.refreshPart('ModelTwo.progress');
                              // print("Sent: $sent $total");
                            }
                            // print(response);
                          } // else {}

                          // modelTwo.hasResult = true;
                          // modelTwo.refresh();
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
                                  : FutureBuilder(
                                      future:
                                          _initializeVideoPlayerFuture_output,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          // If the VideoPlayerController has finished initialization, use
                                          // the data it provides to limit the aspect ratio of the video.
                                          return AspectRatio(
                                            aspectRatio: _controller_output
                                                .value.aspectRatio,
                                            // Use the VideoPlayer widget to display the video.
                                            child:
                                                VideoPlayer(_controller_output),
                                          );
                                        } else {
                                          // If the VideoPlayerController is still initializing, show a
                                          // loading spinner.
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it.
              _controller.play();
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
