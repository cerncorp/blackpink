import 'package:blackpink/api/all_api_helper.dart';

import 'package:blackpink/model/all_model.dart';
import 'package:easy_model/easy_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController _controller1;
  TextEditingController _controller2;
  TextEditingController _controller3;
  bool isSwitched;
  @override
  void initState() {
    super.initState();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    _controller3 = TextEditingController();
    _loadPrefs();
    isSwitched = false;
  }

  void _loadPrefs() async {
    // load preferrence ?
    if (GlobalModel.prefs != null) {
      if (GlobalModel.prefs.containsKey('baseUrl')) {
        _controller1.text = GlobalModel.prefs.getString('baseUrl');
        ApiHelper.baseUrl = _controller1.text;
      }
      if (GlobalModel.prefs.containsKey('username')) {
        _controller2.text = GlobalModel.prefs.getString('username');
      }
      if (GlobalModel.prefs.containsKey('password')) {
        _controller3.text = GlobalModel.prefs.getString('password');
      }
      if (GlobalModel.prefs.containsKey('authToken')) {
        var authToken = GlobalModel.prefs.getString('authToken');
        var modelGlobal = ModelGroup.findModel<GlobalModel>();
        modelGlobal.authToken = authToken;
      }
    }
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('cài đặt chút'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              // save baseurl
              ApiHelper.baseUrl = _controller1.text;
              var username = _controller2.text;
              var password = _controller3.text;
              //save preferrence

              if (GlobalModel.prefs == null)
                GlobalModel.prefs = await SharedPreferences.getInstance();
              await GlobalModel.prefs.setString('baseUrl', _controller1.text);

              // login ? get authToken?
              if (!isSwitched) return;
              await GlobalModel.prefs.setString('username', username);
              await GlobalModel.prefs.setString('password', password);
              try {
                var result = await LoginApiHelper.postLogin(username, password);
                if (result != null && result['result']) {
                  var modelGlobal = ModelGroup.findModel<GlobalModel>();
                  print(result['detail']);
                  // set authToken
                  modelGlobal.authToken = result['token'];
                  await GlobalModel.prefs
                      .setString('authToken', result['token']);
                  print(result['token']);
                  // final snackBar =
                  //     SnackBar(content: Text('đăng nhập thành công'));
                  // Scaffold.of(context).showSnackBar(snackBar);
                  return;
                }
              } catch (e) {
                print(e);
              }
              // final snackBar = SnackBar(
              //     backgroundColor: Colors.red,
              //     content:
              //         Text('Tài khoản hoặc mật khẩu không đúng! Vậy thôi!'));
              // Scaffold.of(context).showSnackBar(snackBar);
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _controller1,
            onSubmitted: (String value) async {},
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w300),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.self_improvement_rounded),
              suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _controller1.clear();
                  }),
              hintText: 'http://cd92af62742b.ngrok.io',
              labelText: 'máy chủ',
            ),
          ),
          SizedBox(height: 30),
          Switch(
            value: isSwitched ?? false,
            onChanged: (value) {
              setState(() {
                isSwitched = value;
                print(isSwitched);
              });
            },
          ),
          SizedBox(height: 10),
          TextField(
            enabled: isSwitched,
            controller: _controller2,
            onSubmitted: (String value) async {},
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.self_improvement_rounded),
              suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _controller2.clear();
                  }),
              hintText: 'user1',
              labelText: 'Tài khoản',
            ),
          ),
          SizedBox(height: 10),
          TextField(
            enabled: isSwitched,
            controller: _controller3,
            onSubmitted: (String value) async {},
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.self_improvement_rounded),
              suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _controller3.clear();
                  }),
              hintText: 'Rock2345@',
              labelText: 'mật khẩu',
            ),
          ),
        ],
      ),
    );
  }
}
