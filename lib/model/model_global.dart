import 'dart:io';

import 'package:blackpink/api/all_api_helper.dart';
import 'package:blackpink/api/api_helper.dart';
import 'package:blackpink/common/common.dart';
import 'package:dio/dio.dart';
import 'package:easy_model/easy_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalModel extends Model {
  Brightness brightness = Brightness.light;

  String authToken;
  String httpServer;
  String basehttpServer;

  Map<String, bool> getImageListParams;

  String getImageListUrl;

  String postLoginUrl;

  Map<String, String> postLoginData;

  String postCreateGenImageUrl;
  // Map<String, int> postCreateGenImageData;

  String getGenImageUrl;

  String uploadImageUrl;

  String uploadVideoUrl;

  String postCreateGenVideoUrl;
  String getGenVideoUrl;
  // Dio myDio;

  dynamic styleModelList;

  dynamic uploadImages;

  dynamic helloPageImages;

  static SharedPreferences prefs;

  int soundIdClicked2;
  int soundIdTing;

  @override
  void initState() {
    print('${this.runtimeType} initState');
  }

  @override
  void dispose() {
    // myDio.close();
    print('${this.runtimeType} dispose');
  }

  GlobalModel() {
    // laptop: a897007270fc1b6e8f64c076ae91dcf9051cdd52
    // home: 421e1daee4a58b5956689905db5ecb340779c070
    // e5525cb02f27.ngrok.io
    this.authToken = "421e1daee4a58b5956689905db5ecb340779c070";

// test url
    this.httpServer = "${ApiHelper.baseUrl}/";
    this.basehttpServer = "${ApiHelper.baseUrl}";
// 5deb587f7daa.ngrok.io
    this.getImageListUrl = basehttpServer + '/api/v2/image-upload/';
    this.getImageListParams = {'UserGetData': true};

    this.postLoginUrl = basehttpServer + '/api/v2/accounts/login/';
    this.postLoginData = {'login': 'user1', 'password': 'robinson1235'};

    this.postCreateGenImageUrl = basehttpServer + '/api/v2/test/gen-image/';
    // this.postCreateGenImageData = {
    //   'idimg_input': 1,
    //   'idsm_input': 1,
    // };

    this.getGenImageUrl = basehttpServer + '/api/v2/test/gen-image/';

    this.uploadImageUrl = basehttpServer + '/api/v2/image-upload/';

    this.uploadVideoUrl = basehttpServer + '/api/v2/video-upload/';

    this.postCreateGenVideoUrl = basehttpServer + '/api/v2/test/gen-video/';
    this.getGenVideoUrl = basehttpServer + '/api/v2/test/gen-video/';

    // _anonymouosLogin();
    // reloadStyleModel();
    checkConnection();

    print('${this.runtimeType} create');
  }
  void checkConnection() async {
    prefs = await SharedPreferences.getInstance();

    soundIdClicked2 =
        await rootBundle.load(soundClicked2).then((ByteData soundData) {
      return pool.load(soundData);
    });
    soundIdTing = await rootBundle.load(soundTing).then((ByteData soundData) {
      return pool.load(soundData);
    });
    // int streamId = await pool.play(globalModel.soundId);

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected internet');
        final connectToServer =
            await InternetAddress.lookup(ApiHelper.baseUrl.split('//')[1]);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('connected to Server');
          // get auth token

          // await prefs.setInt('counter', counter);
          // check login auth token

          // reloadStyleModel();
        } else {
          print('Can not connect to Server');
        }
      }
    } on SocketException catch (_) {
      print('not connected to Internet or Server');
    }
  }

  void _anonymouosLogin() async {
    Map<String, dynamic> data = {
      'login': 'user1',
      'password': 'Rock2345@@',
    };
    var response = await ApiHelper.postData(this.postLoginUrl, '', data);
    if (response != null && response.statusCode == 200) {
      this.authToken = response.data['token'];
      return;
    }
    print("Dang nhap that bai.");
  }

  Future<bool> reloadHelloPageImages() async {
    var list = await ImageApiHelper.getImageGenList(this.authToken);
    // print(list);
    if (list != null && list.statusCode == 200) {
      print(list.statusCode);
      this.helloPageImages = new List();
      for (var item in list.data) {
        if (item['idimg_output'] == null) continue;
        this.helloPageImages.add(item);
      }
      return true;
    }

    // this.styleModelList = listSMResponse.data;
    return false;
  }

  Future<bool> reloadStyleModel() async {
    var listSMResponse = await ApiHelper.loadStyleModel(this.authToken);

    if (listSMResponse != null && listSMResponse.statusCode == 200) {
      this.styleModelList = listSMResponse.data;
      return true;
    }
    // this.styleModelList = listSMResponse.data;
    return false;
  }

  Future<dynamic> createGenImageTask(int idupimg, int idsm) async {
    Map<String, dynamic> data = {
      'idimg_input': idupimg,
      'idsm_input': idsm,
    };
    var response = await ApiHelper.postData(
        this.postCreateGenImageUrl, this.authToken, data);
    return response;
  }

  Future<dynamic> createGenVideoTask(int idupvid, int idsm) async {
    Map<String, dynamic> data = {
      'idvid_input': idupvid,
      'idsm_input': idsm,
    };
    var response = await ApiHelper.postData(
        this.postCreateGenVideoUrl, this.authToken, data);
    return response;
  }

  Future<dynamic> getGenVideoProgress(int id) async {
    var response = await ApiHelper.getData(
        '${this.getGenVideoUrl}$id/', this.authToken, {});
    return response;
  }

  Future<dynamic> getGenImageTask(Map<String, dynamic> params) async {
    var response =
        await ApiHelper.getData(this.getGenImageUrl, this.authToken, params);
    return response;
  }

  Future<dynamic> getGenImageProgress(int id) async {
    var response = await ApiHelper.getData(
        '${this.getGenImageUrl}$id/', this.authToken, {});
    return response;
  }

  Future<dynamic> uploadImageFile(String file_path) async {
    var upload = await ApiHelper.uploadFile(
        this.uploadImageUrl, this.authToken, file_path);
    return upload;
  }

  Future<dynamic> uploadVideoFile(String file_path,
      {void Function(int, int) onReceivedProgress,
      void Function(int, int) onSentProgress}) async {
    var upload = await ApiHelper.uploadFile(
        this.uploadVideoUrl, this.authToken, file_path,
        onReceivedProgress: onReceivedProgress, onSentProgress: onSentProgress);
    return upload;
  }
}
