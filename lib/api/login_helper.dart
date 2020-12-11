import 'package:dio/dio.dart';
import 'api_helper.dart';

class LoginApiHelper {
  static Future<Map<String, dynamic>> postLogin(
      String user, String password) async {
    Dio dio = new Dio();

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      var customHeaders = {
        'content-type': 'application/json',
        // other headers
        // 'authorization': "Token ${authToken}",
      };

      options.headers.addAll(customHeaders);
      return options;
    }));

    Map<String, dynamic> data = {
      'login': user,
      'password': password,
    };

    String url = ApiHelper.baseUrl + ApiHelper.loginUrl;
    var response = await dio.post(
      '$url',
      data: data,
    );
    // print(listSMResponse);

    dio.close(force: false);

    if (response != null && response.statusCode == 200) {
      return {
        'result': true,
        'detail': response.data['detail'],
        'token': response.data['token']
      };
    }
    return {
      'result': false,
      'detail': 'error: username or password is incorrect!'
    };
  }

  static Future<dynamic> postRegister(String user, String password) async {
    Dio dio = new Dio();

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      var customHeaders = {
        'content-type': 'application/json',
        // other headers
        // 'authorization': "Token ${authToken}",
      };

      options.headers.addAll(customHeaders);
      return options;
    }));

    Map<String, dynamic> data = {
      'username': user,
      'password': password,
      'password_confirm': password,
      'first_name': 'Ano',
      'last_name': 'hana',
      'email': user + '@lol.com',
    };

    // print(data);
    String url = ApiHelper.baseUrl + ApiHelper.registerUrl;
    // print(url);
    var response;
    // try {
    response = await dio.post(
      '$url',
      data: data,
    );
    print(response);
    // return response;
    // print(response.data);
    if (response != null && response.statusCode == 201) {
      return {
        'result': true,
        'detail': 'Đăng ký thành công',
      };
    }
    // } on DioError catch (e) {
    //   print(e);
    //   print(response);
    //   // print(response.data);
    // }

    await dio.close(force: false);
// {
//     "id": 5,
//     "username": "user4",
//     "first_name": "robin",
//     "last_name": "cute",
//     "email": "abc@gom.com"
// }
//     {
//     "username": [
//         "A user with that username already exists."
//     ]
// }
    return {
      'result': false,
      'detail': 'Đăng ký thất bại;',
      // 'username': response.data['username'][0],
    };
  }
}
