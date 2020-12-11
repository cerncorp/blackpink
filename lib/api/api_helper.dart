import 'dart:io';

import 'package:dio/dio.dart';

class ApiHelper {
  // bdbe244f5ba0.ngrok.io
  // 192.168.100.5:8000
  static String baseUrl = 'http://cd92af62742b.ngrok.io';

  static final String loginUrl = '/api/v2/accounts/login/';
  static final String registerUrl = '/api/v2/accounts/register/';

  static final String listImageUrl = '/api/v2/image-upload/?UserGetData=True';

  static final String imageGenUrl = '/api/v2/test/gen-image/';
  static final String styleGenUrl = '/api/v2/test/style-model/';

  static final String genImageTaskUrl = '/api/v2/test/gen-image/';
  static final String genStyleModelTaskUrl = '/api/v2/test/style-model/';

  static final String uploadImageUrl = '/api/v2/image-upload/';

  static final String getUpImgUrl = '/api/v2/test/image-upload/';

  static final String uploadVideoUrl = '/api/v2/video-upload/';

  static Future<bool> canConnectToServer() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected internet');
        final connectToServer =
            await InternetAddress.lookup(ApiHelper.baseUrl.split('//')[1]);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('connected to Server');
          return true;
        } else {
          print('Can not connect to Server');
        }
      }
    } on SocketException catch (_) {
      print('not connected to Internet or Server');
    }
    return false;
  }

  static Future<dynamic> loadStyleModel(String authToken) async {
    Dio dio = new Dio();
    try {
      dio.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
        var customHeaders = {
          'content-type': 'application/json',
          // other headers
          'authorization': "Token ${authToken}",
        };
        options.headers.addAll(customHeaders);
        return options;
      }));
      var listSMResponse = await dio.get(
        '${baseUrl}${styleGenUrl}',
      );
      // print(listSMResponse);

      dio.close();

      return listSMResponse;
    } on DioError catch (e) {
      // <<<<< IN THIS LINE
      if (e.response.statusCode == 404) {
        print(e.response.statusCode);
      } else {
        print(e.message);
        print(e.request);
      }
    }

    return null;
  }

  static Future<dynamic> postData(
      String url, String authToken, Map<String, dynamic> data) async {
    Dio dio = new Dio();

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      var customHeaders = {
        'content-type': 'application/json',
        // other headers
        'authorization': "Token ${authToken}",
      };

      options.headers.addAll(customHeaders);
      return options;
    }));
    var response = await dio.post(
      '$url',
      data: data,
    );
    // print(listSMResponse);
    dio.close();
    return response;
  }

  static Future<dynamic> getData(
      String url, String authToken, Map<String, dynamic> params) async {
    Dio dio = new Dio();

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      var customHeaders = {
        'content-type': 'application/json',
        // other headers
        'authorization': "Token ${authToken}",
      };

      options.headers.addAll(customHeaders);
      return options;
    }));
    var response = await dio.get(
      '$url',
      queryParameters: params,
    );
    // print(listSMResponse);
    dio.close();
    return response;
  }

  static Future<dynamic> uploadFile(
      String url, String authToken, String file_path,
      {void Function(int, int) onReceivedProgress,
      void Function(int, int) onSentProgress}) async {
    Dio dio = new Dio();

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      var customHeaders = {
        'content-type': 'application/json',
        // other headers
        'authorization': "Token ${authToken}",
      };
      options.headers.addAll(customHeaders);
      return options;
    }));
    // content picture

    FormData formData = FormData.fromMap({
      "uploadfile": await MultipartFile.fromFile(file_path,
          filename: file_path.split('/').last)
    });
    dynamic upload;
    try {
      // upload image and get idupimg
      upload = await dio.post(
        '$url',
        data: formData,
        onReceiveProgress: onReceivedProgress,
        onSendProgress: onSentProgress,
      );
      // if (upload.statusCode == 200) {
      //   return upload;
      // }
      // print(upload);
    } on DioError catch (e) {
      print(e.message);
    } finally {
      dio.close();
    }
    return upload;
  }
}
