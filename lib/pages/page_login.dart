// main.dart
import 'package:blackpink/api/login_helper.dart';
import 'package:blackpink/model/all_model.dart';
import 'package:easy_model/easy_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_login/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

const mockUsers = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
  'near.huscarl@gmail.com': 'subscribe to pewdiepie',
  '@.com': '.',
};

class LoginScreen extends StatelessWidget {
  // static const routeName = '/auth';

  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _loginUser(LoginData data) async {
    // if (!mockUsers.containsKey(data.name)) {
    //   return 'Username not exists';
    // }
    // if (mockUsers[data.name] != data.password) {
    //   return 'Password does not match';
    // }
    // post to server

    try {
      var result = await LoginApiHelper.postLogin(data.name, data.password);
      if (result['result']) {
        var modelGlobal = ModelGroup.findModel<GlobalModel>();
        print(result['detail']);
        // set authToken
        modelGlobal.authToken = result['token'];
        print(result['token']);
        return null;
      }
    } catch (e) {
      // return '[Tài khoản]|[Mật khẩu] không chính xác!';
    }
    // return Future.delayed(loginTime).then((_) {});
    return '[Tài khoản]|[Mật khẩu] không chính xác!';
  }

  Future<String> _signupUser(LoginData data) async {
    try {
      var result = await LoginApiHelper.postRegister(data.name, data.password);

      if (result['result']) {
        // var modelGlobal = ModelGroup.findModel<GlobalModel>();
        print(result['detail']);
        // Scaffold.of(context).showSnackBar(SnackBar(
        //   content: Text(result['detail']),
        // ));
        // set authToken
        // modelGlobal.authToken = result['token'];
        return null;
      }
    } catch (d) {
      print(d);
      // return 'Đăng kí không thành công, Xin Thử Lại Lần Nữa!';
    }
    return 'Tài khoản đã được dùng, mật khẩu ít nhất 8 kí tự, hãy thay đổi!';
    // print(result['username']);
    // return result['detail'];
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      // if (!mockUsers.containsKey(name)) {
      //   return 'Username not exists';
      // }
      if (true) {
        return 'Liên hệ admin@gmail.com';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = BorderRadius.vertical(
      bottom: Radius.circular(10.0),
      top: Radius.circular(20.0),
    );

    // return
    // ModelWidget<ModelLoginPage>(
    //   modelBuilder: () => ModelLoginPage(),
    //   childBuilder: (context, model) {
    return FlutterLogin(
      title: 'Hello;',
      // logo: 'assets/images/ecorp.png',
      logoTag: 'near.huscarl.loginsample.logo',
      titleTag: 'near.huscarl.loginsample.title',
      // messages: LoginMessages(
      //   usernameHint: 'Username',
      //   passwordHint: 'Pass',
      //   confirmPasswordHint: 'Confirm',
      //   loginButton: 'LOG IN',
      //   signupButton: 'REGISTER',
      //   forgotPasswordButton: 'Forgot huh?',
      //   recoverPasswordButton: 'HELP ME',
      //   goBackButton: 'GO BACK',
      //   confirmPasswordError: 'Not match!',
      //   recoverPasswordIntro: 'Don\'t feel bad. Happens all the time.',
      //   recoverPasswordDescription: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
      //   recoverPasswordSuccess: 'Password rescued successfully',
      // ),
      // theme: LoginTheme(
      //   primaryColor: Colors.teal,
      //   accentColor: Colors.yellow,
      //   errorColor: Colors.deepOrange,
      //   pageColorLight: Colors.indigo.shade300,
      //   pageColorDark: Colors.indigo.shade500,
      //   titleStyle: TextStyle(
      //     color: Colors.greenAccent,
      //     fontFamily: 'Quicksand',
      //     letterSpacing: 4,
      //   ),
      //   // beforeHeroFontSize: 50,
      //   // afterHeroFontSize: 20,
      //   bodyStyle: TextStyle(
      //     fontStyle: FontStyle.italic,
      //     decoration: TextDecoration.underline,
      //   ),
      //   textFieldStyle: TextStyle(
      //     color: Colors.orange,
      //     shadows: [Shadow(color: Colors.yellow, blurRadius: 2)],
      //   ),
      //   buttonStyle: TextStyle(
      //     fontWeight: FontWeight.w800,
      //     color: Colors.yellow,
      //   ),
      //   cardTheme: CardTheme(
      //     color: Colors.yellow.shade100,
      //     elevation: 5,
      //     margin: EdgeInsets.only(top: 15),
      //     shape: ContinuousRectangleBorder(
      //         borderRadius: BorderRadius.circular(100.0)),
      //   ),
      //   inputTheme: InputDecorationTheme(
      //     filled: true,
      //     fillColor: Colors.purple.withOpacity(.1),
      //     contentPadding: EdgeInsets.zero,
      //     errorStyle: TextStyle(
      //       backgroundColor: Colors.orange,
      //       color: Colors.white,
      //     ),
      //     labelStyle: TextStyle(fontSize: 12),
      //     enabledBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.blue.shade700, width: 4),
      //       borderRadius: inputBorder,
      //     ),
      //     focusedBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
      //       borderRadius: inputBorder,
      //     ),
      //     errorBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.red.shade700, width: 7),
      //       borderRadius: inputBorder,
      //     ),
      //     focusedErrorBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.red.shade400, width: 8),
      //       borderRadius: inputBorder,
      //     ),
      //     disabledBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.grey, width: 5),
      //       borderRadius: inputBorder,
      //     ),
      //   ),
      //   buttonTheme: LoginButtonTheme(
      //     splashColor: Colors.purple,
      //     backgroundColor: Colors.pinkAccent,
      //     highlightColor: Colors.lightGreen,
      //     elevation: 9.0,
      //     highlightElevation: 6.0,
      //     shape: BeveledRectangleBorder(
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      //     // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      //     // shape: CircleBorder(side: BorderSide(color: Colors.green)),
      //     // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
      //   ),
      // ),
      emailValidator: (value) {
        // if (!value.contains('@') || !value.endsWith('.com')) {
        //   return "Email must contain '@' and end with '.com'";
        // }
        if (value.isEmpty) {
          return "Tài khoản, please!";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value.isEmpty) {
          return 'Hãy nhập mật khẩu';
        }
        if (value.length < 8) {
          return "Mật khẩu cần ít nhất 8 kí tự!";
        }
        return null;
      },
      onLogin: (loginData) {
        print('Login info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return _loginUser(loginData);
      },
      onSignup: (loginData) {
        print('Signup info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return _signupUser(loginData);
      },
      onSubmitAnimationCompleted: () async {
        // Navigator.of(context).pushReplacement(FadePageRoute(
        //   builder: (context) => DashboardScreen(),
        // ));

        var modelGlobal = ModelGroup.findModel<GlobalModel>();
        if (modelGlobal.authToken != "") {
          // print(GlobalModel.prefs);
          if (GlobalModel.prefs == null)
            GlobalModel.prefs = await SharedPreferences.getInstance();
          await GlobalModel.prefs.setString('authToken', modelGlobal.authToken);
        }
        Navigator.of(context).pop();
      },
      onRecoverPassword: (name) {
        print('Recover password info');
        print('Name: $name');
        return _recoverPassword(name);
        // Show new password dialog
      },
      showDebugButtons: false,
    );
    // },
    // );
  }
}
