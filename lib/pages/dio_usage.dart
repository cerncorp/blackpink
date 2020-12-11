import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../common/common.dart';
import 'package:flutter/material.dart';
import 'package:easy_model/easy_model.dart';
import 'package:dio/dio.dart';
import '../model/all_model.dart';

class DioTest extends StatelessWidget {
  // List
  GlobalModel globalModel;

  // void _loadStyleModel() async {
  //   Dio dio = new Dio();

  //   dio.interceptors
  //       .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
  //     var customHeaders = {
  //       'content-type': 'application/json',
  //       // other headers
  //       'authorization': "Token ${globalModel.authToken}",
  //     };
  //     options.headers.addAll(customHeaders);
  //     return options;
  //   }));
  //   var listSMResponse = await dio.get(
  //     '${globalModel.httpServer}api/v2/test/style-model/',
  //   );
  //   print(listSMResponse);
  //   dio.close();
  // }

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
              padding: EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 1.0,
                    mainAxisSpacing: 1.0),
                itemBuilder: (BuildContext context, int index) {
                  return FlatButton(
                    onPressed: () {
                      print(images[index]['style_link']);
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
    globalModel = ModelGroup.findModel<GlobalModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('DIO test'),
      ),
      body: Center(
        child: Column(
          children: [
            RaisedButton(
              onPressed: () async {
                Dio dio = new Dio();
                dio.options.headers['content-Type'] = 'application/json';
                // dio.options.headers["authorization"] =
                //     "Token ${globalModel.authToken}";

                var response = await dio.post(globalModel.postLoginUrl,
                    data: globalModel.postLoginData,
                    onReceiveProgress: (received, total) {
                  print('$received / $total');
                });
                print(response);
              },
              child: Text("test post get token"),
            ),
            RaisedButton(
              onPressed: () async {
                Dio dio = new Dio();
                dio.options.headers['content-Type'] = 'application/json';
                dio.options.headers["authorization"] =
                    "Token ${globalModel.authToken}";
                var response = await dio.get(globalModel.getImageListUrl,
                    queryParameters: globalModel.getImageListParams,
                    onReceiveProgress: (received, total) {
                  print('$received / $total');
                });
                print(response);
              },
              child: Text("test get image list"),
            ),
            RaisedButton(
              onPressed: () async {
                var picture = await ImagePicker.platform
                    .pickImage(source: ImageSource.gallery);
                print(picture.path);

                FormData formData = FormData.fromMap({
                  "uploadfile": await MultipartFile.fromFile(picture.path,
                      filename: picture.path.split('/').last)
                });

                Dio dio = new Dio();

                dio.interceptors.add(InterceptorsWrapper(
                    onRequest: (RequestOptions options) async {
                  var customHeaders = {
                    'content-type': 'application/json',
                    // other headers
                    'authorization': "Token ${globalModel.authToken}",
                  };
                  options.headers.addAll(customHeaders);
                  return options;
                }));
                // dio.options.headers['content-Type'] = 'application/json';
                // dio.options.headers["authorization"] =
                //     "Token ${globalModel.authToken}";

                try {
                  var response = await dio.post(
                    globalModel.getImageListUrl,
                    data: formData,
                  );

                  print(response);
                } on DioError catch (e) {
                  print(e.message);
                }
              },
              child: Text("test upload image"),
            ),
            RaisedButton(
              onPressed: () async {
                // get style model
                _showChoiceStyleModelDialog(context);

                return;

                // var myDio = globalModel.myDio;
                Dio dio = new Dio();

                dio.interceptors.add(InterceptorsWrapper(
                    onRequest: (RequestOptions options) async {
                  var customHeaders = {
                    'content-type': 'application/json',
                    // other headers
                    'authorization': "Token ${globalModel.authToken}",
                  };
                  options.headers.addAll(customHeaders);
                  return options;
                }));
                // content picture
                var picture = await ImagePicker.platform
                    .pickImage(source: ImageSource.gallery);
                print(picture.path);

                FormData formData = FormData.fromMap({
                  "uploadfile": await MultipartFile.fromFile(picture.path,
                      filename: picture.path.split('/').last)
                });

                Dio dio_genimage = new Dio();
                try {
                  // upload image and get idupimg
                  var upload = await dio.post(
                    '${globalModel.httpServer}api/v2/image-upload/',
                    data: formData,
                  );
                  if (upload.statusCode == 200) {
                    print(upload.data['message']);
                    print(upload.data['idupimg']);

                    var data = {
                      'idimg_input': upload.data['idupimg'],
                      'idsm_input': 1, // style model
                    };

                    dio_genimage.interceptors.add(InterceptorsWrapper(
                        onRequest: (RequestOptions options) async {
                      var customHeaders = {
                        'content-type': 'application/json',
                        // other headers
                        'authorization': "Token ${globalModel.authToken}",
                      };
                      options.headers.addAll(customHeaders);
                      return options;
                    }));
                    var genimage = await dio_genimage.post(
                      '${globalModel.httpServer}api/v2/test/gen-image/',
                      data: data,
                    );

                    // print(genimage);
                  }
                  // print(upload);
                } on DioError catch (e) {
                  print(e.message);
                } finally {
                  dio.close();
                  dio_genimage.close();
                }
              },
              child: Text("test post new queue generate image"),
            ),
          ],
        ),
      ),
    );
  }
}
