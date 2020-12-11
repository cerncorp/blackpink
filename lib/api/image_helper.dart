import 'package:dio/dio.dart';
import 'api_helper.dart';

class ImageApiHelper {
  static Future<dynamic> getImagesLib(String authToken) async {
    try {
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
      var list = await dio.get(
        '${ApiHelper.baseUrl}${ApiHelper.listImageUrl}',
      );
      // print(listSMResponse);
      dio.close(force: false);
      return list;
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

  static Future<dynamic> getImagesWithID(String authToken, int idupimg) async {
    try {
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
      var list = await dio.get(
        "${ApiHelper.baseUrl}${ApiHelper.getUpImgUrl}$idupimg/",
      );
      // print(listSMResponse);
      dio.close(force: false);
      return list;
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

  static Future<dynamic> getImageGenList(String authToken) async {
    try {
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
      print('${ApiHelper.baseUrl}${ApiHelper.imageGenUrl}');
      var list = await dio.get(
        '${ApiHelper.baseUrl}${ApiHelper.imageGenUrl}',
      ); //.whenComplete(() => null);
      // print(listSMResponse);
      dio.close(force: false);

      return list;
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

  static Future<bool> downloadUrl(
    String url,
    String savePath,
    void Function(int, int) onReceiveProgress,
  ) async {
    Dio dio = new Dio();
    CancelToken cancelToken = CancelToken();
    try {
      await dio.download(url, savePath,
          onReceiveProgress: onReceiveProgress, cancelToken: cancelToken);
      return true;
    } catch (e) {
      print(e);
    } finally {
      dio.close(force: false);
    }
    return false;
  }

  static void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  static Future<dynamic> postGenImageTask(
      String authToken, int idImage, int idStyleModel) async {
    Map<String, dynamic> data = {
      'idimg_input': idImage,
      'idsm_input': idStyleModel,
    };
    try {
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
        '${ApiHelper.baseUrl}${ApiHelper.genImageTaskUrl}',
        data: data,
      );
      dio.close();
      return response;
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

  static Future<dynamic> postGenStyleModelTask(
      String authToken, int idStyleImage) async {
    Map<String, dynamic> data = {
      'inputlink': idStyleImage,
      'isShared': true,
      'outputmodel': 'x',
    };
    try {
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
        '${ApiHelper.baseUrl}${ApiHelper.genStyleModelTaskUrl}',
        data: data,
      );
      dio.close(force: false);
      return response;
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

  static Future<dynamic> getGenImageTask(String authToken, int idgenimg) async {
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
      var response = await dio.get(
        '${ApiHelper.baseUrl}${ApiHelper.genImageTaskUrl}$idgenimg/',
      );
      // print(listSMResponse);
      dio.close();
      return response;
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

    try {
      dynamic upload;
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

      return upload;
    } on DioError catch (e) {
      print(e.message);
    } finally {
      dio.close();
    }
    return null;
  }
}
