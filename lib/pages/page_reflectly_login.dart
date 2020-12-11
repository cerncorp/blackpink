import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:blackpink/common/common.dart';
import 'package:blackpink/common/delayed_animation.dart';
import 'package:blackpink/common/glitch.dart';
import 'package:blackpink/pages/page_queue.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:easy_model/easy_model.dart';

import 'package:blackpink/model/all_model.dart';
import 'package:blackpink/pages/all_pages.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   SystemChrome.setEnabledSystemUIOverlays([]);
//   runApp(ReflectlyLoginPage());
// }

class ReflectlyLoginPage extends StatefulWidget {
  @override
  _ReflectlyLoginPageState createState() => _ReflectlyLoginPageState();
}

class _ReflectlyLoginPageState extends State<ReflectlyLoginPage>
    with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  double _scale;
  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.white;
    _scale = 1 - _controller.value;
    return Scaffold(
        backgroundColor: Colors.black, //Color(0xFF8185E2),
        body: SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    var globalModel = ModelGroup.findModel<GlobalModel>();
                    await pool.play(globalModel.soundIdTing);
                  },
                  child: AvatarGlow(
                    endRadius: 120,
                    duration: Duration(seconds: 2),
                    glowColor: Colors.white24,
                    repeat: true,
                    repeatPauseDuration: Duration(seconds: 2),
                    startDelay: Duration(seconds: 1),
                    child: GlithEffect(
                      child: Material(
                        elevation: 8.0,
                        shape: CircleBorder(),
                        // color: Colors.white,
                        // borderOnForeground: true,
                        shadowColor: Colors.white,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          // child: Image.asset(
                          //   'assets/images/odin.png',
                          //   fit: BoxFit.cover,
                          // ),
                          backgroundImage: AssetImage(
                            'assets/images/rain_princess_small.jpg',
                          ),
                          radius: 70.0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                  height: 20.0,
                ),

                DelayedAnimation(
                  child: SizedBox(
                    width: 300.0,
                    height: 300.0,
                    child: TypewriterAnimatedTextKit(
                      isRepeatingAnimation: true,
                      speed: Duration(milliseconds: 100),
                      pause: Duration(seconds: 2),
                      repeatForever: true,
                      // onTap: () {
                      //   print("Tap Event");
                      // },
                      text: [
                        "",
                        'Annyeonghaseyo!',
                        'Tôi hỏi lũ sâu xanh\n“lá có gì mà thích?“\nLũ sâu cười khúc khích\n“thích-đâu cần lý do?“',
                        "",
                        'Đường đi khó không khó vì ngăn sông cách núi, mà khó vì lòng người ngại núi e sông.', // \nNguyễn Bá Học',
                        "",
                        "don't just get the gist, you'll hit a wall",
                        "Không có việc gì quá khó cả,\nChỉ cần bạn không làm nữa là xongggg!",
                        "",
                        // "-Ngày mai trong đám xuân xanh ấy,\nCó kẻ theo chồng bỏ cuộc chơi...",
                        "Sayonara",
                      ],
                      textStyle: TextStyle(fontSize: 28.0, fontFamily: "Agne"),
                    ),
                  ),
                  delay: delayedAmount + 1000,
                ),
                // DelayedAnimation(
                //   child: Text(
                //     "I'm Reflectly",
                //     style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 35.0,
                //         color: color),
                //   ),
                //   delay: delayedAmount + 2000,
                // ),
                // SizedBox(
                //   height: 30.0,
                // ),
                // DelayedAnimation(
                //   child: Text(
                //     "Your New Personal",
                //     style: TextStyle(fontSize: 20.0, color: color),
                //   ),
                //   delay: delayedAmount + 3000,
                // ),
                // DelayedAnimation(
                //   child: Text(
                //     "Journaling  companion",
                //     style: TextStyle(fontSize: 20.0, color: color),
                //   ),
                //   delay: delayedAmount + 3000,
                // ),
                // SizedBox(
                //   height: 100.0,
                // ),
                DelayedAnimation(
                  child: GestureDetector(
                    onTapDown: _onTapDown,
                    onTapUp: _onTapUp,
                    child: Transform.scale(
                      scale: _scale,
                      child: _animatedButtonUI,
                    ),
                  ),
                  delay: delayedAmount + 4000,
                ),
                // SizedBox(
                //   height: 50.0,
                // ),
                // DelayedAnimation(
                //   child: Text(
                //     "I Already have An Account".toUpperCase(),
                //     style: TextStyle(
                //         fontSize: 20.0,
                //         fontWeight: FontWeight.bold,
                //         color: color),
                //   ),
                //   delay: delayedAmount + 5000,
                // ),
              ],
            ),
          ),
        )
        //  Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     Text('Tap on the Below Button',style: TextStyle(color: Colors.grey[400],fontSize: 20.0),),
        //     SizedBox(
        //       height: 20.0,
        //     ),
        //      Center(

        //   ),
        //   ],

        // ),

        );
  }

  Widget get _animatedButtonUI => Container(
        height: 60,
        width: 270,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Colors.white,
        ),
        child: Center(
          child: BorderedText(
            strokeWidth: 2.0,
            strokeColor: Colors.black,
            child: Text(
              'Hello; Art',
              style: TextStyle(
                decoration: TextDecoration.none,
                decorationColor: Colors.pink,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Text(
          //   'Hello;',
          //   style: TextStyle(
          //     fontSize: 20.0,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.blueAccent, //Color(0xFF8185E2),
          //   ),
          // ),
        ),
      );

  void _onTapDown(TapDownDetails details) async {
    _controller.forward();
    var globalModel = ModelGroup.findModel<GlobalModel>();
    await pool.play(globalModel.soundIdClicked2);
  }

  Future<void> _onTapUp(TapUpDetails details) async {
    _controller.reverse();

    var globalModel = ModelGroup.findModel<GlobalModel>();
    // globalModel.prefs = await SharedPreferences.getInstance();
    // globalModel.authToken = globalModel.prefs.getString('authToken') ?? "";
    // print('${globalModel.authToken}');
    // if (globalModel.authToken == "")
    // login
    // push(context, (ctx, model) => HelloPage(), () => ModelHelloPage());

    await globalModel.reloadHelloPageImages();

    if (globalModel.helloPageImages != null &&
        globalModel.helloPageImages.length > 0)
      // Navigator.push(context,
      //     PageTransition(type: PageTransitionType.fade, child: HelloPage()));
      pushTransition(
          context, (ctx, model) => HelloPage(), () => ModelHelloPage(),
          type: PageTransitionType.fade);
    else {
      final snackBar = SnackBar(
        content: Text('Lỗi: Không thể kết nối đến máy chủ! Mở Settings'),
        backgroundColor: Colors.pinkAccent,
      );
      Scaffold.of(context).showSnackBar(snackBar);
      print('error: connection error');

      pushTransition(
          context, (ctx, model) => SettingsPage(), () => ModelSettings(),
          type: PageTransitionType.scale);
    }
    // pushTransition(
    //     context, (ctx, model) => UserDetailsPage(), () => ModelLoginPage(),
    //     type: PageTransitionType.scale);

    // pushTransition(context, (ctx, model) => QueuePage(), () => ModelQueue(),
    //     type: PageTransitionType.scale);

    // else {
    // push(context, (ctx, model) => LoginScreen(), () => ModelLoginPage());
    // Navigator.push(
    //     context,
    //     PageTransition(
    //         type: PageTransitionType.rightToLeftWithFade,
    //         child: LoginScreen()));
    // }
  }
}
