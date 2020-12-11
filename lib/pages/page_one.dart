import 'package:blackpink/pages/dio_usage.dart';
import 'package:blackpink/pages/image_example.dart';
import 'package:blackpink/pages/page_flip_card.dart';
import 'package:blackpink/pages/page_generation.dart';
import 'package:blackpink/pages/page_generation_video.dart';
import 'package:blackpink/pages/page_hello.dart';
import 'package:blackpink/pages/page_login.dart';
import 'package:blackpink/pages/page_profile.dart';
import 'package:blackpink/pages/page_reflectly_login.dart';
import 'package:blackpink/pages/page_stories.dart';
import 'package:blackpink/pages/page_test_image.dart';
import 'package:blackpink/pages/page_tinder_swipe.dart';
import 'package:blackpink/pages/page_trending_card.dart';
import 'package:blackpink/pages/page_user_detail.dart';
import 'package:blackpink/pages/page_user_library.dart';
import 'package:blackpink/pages/stepper_usage.dart';
import 'package:easy_model/easy_model.dart';

import '../common/common.dart';
import 'package:flutter/material.dart';

class PageOne extends StatelessWidget {
  GlobalModel globalModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Annyeonghaseyo'),
      ),
      body: Center(
        child: ListView(
          children: [
            Button(
              child: Text('Style models loade',
                  style: TextStyle(color: Colors.black)),
              onPressed: () async {
                globalModel = ModelGroup.findModel<GlobalModel>();
                await globalModel.reloadStyleModel();
                print("Style models loaded");
              },
            ),
            Button(
              onPressed: () {
                push(context, (ctx, model) => PageTwo(), () => ModelTwo());
              },
            ),
            Button(
              child:
                  Text('Stepper Usage', style: TextStyle(color: Colors.white)),
              onPressed: () {
                push(context, (ctx, model) => StepperUsage(), () => ModelTwo());
              },
            ),
            Button(
              child:
                  Text('Profile Page', style: TextStyle(color: Colors.white)),
              onPressed: () {
                push(
                    context, (ctx, model) => MyProfilePage(), () => ModelTwo());
              },
            ),
            // Button(
            //   child: Text('Image Test Page',
            //       style: TextStyle(color: Colors.black)),
            //   onPressed: () {
            //     push(context, (ctx, model) => MyImageTestPage(),
            //         () => ModelTwo());
            //   },
            // ),
            // Button(
            //   child: Text('Image Test Page Dio',
            //       style: TextStyle(color: Colors.black)),
            //   onPressed: () {
            //     push(context, (ctx, model) => DioTest(), () => ModelTwo());
            //   },
            // ),
            Button(
              child: Text('Generation Image page',
                  style: TextStyle(color: Colors.pink)),
              onPressed: () {
                push(context, (ctx, model) => GenerationPage(),
                    () => ModelTwo());
              },
            ),
            Button(
              child: Text('Generation Video page',
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                push(context, (ctx, model) => GenerationVideoPage(),
                    () => ModelTwo());
              },
            ),
            Button(
              child: Text('Generation Style Model page',
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                push(context, (ctx, model) => GenerationVideoPage(),
                    () => ModelTwo());
              },
            ),
            Button(
              child: Text('Reflectly Login Page',
                  style: TextStyle(color: Colors.black)),
              onPressed: () {
                push(context, (ctx, model) => ReflectlyLoginPage(),
                    () => ModelTwo());
              },
            ),
            Button(
              child: Text('Login Page', style: TextStyle(color: Colors.black)),
              onPressed: () {
                push(context, (ctx, model) => LoginScreen(), () => ModelTwo());
              },
            ),
            Button(
              child: Text('Story Page', style: TextStyle(color: Colors.black)),
              onPressed: () {
                push(context, (ctx, model) => StoriesPage(), () => ModelTwo());
              },
            ),
            Button(
              child: Text('Tinder Swipe Page',
                  style: TextStyle(color: Colors.black)),
              onPressed: () {
                push(context, (ctx, model) => TinderSwipePage(),
                    () => ModelTwo());
              },
            ),
            Button(
              child:
                  Text('Flip Card Page', style: TextStyle(color: Colors.black)),
              onPressed: () {
                push(context, (ctx, model) => FlipCardPage(), () => ModelTwo());
              },
            ),
            Button(
              child: Text('User Detail Card Page',
                  style: TextStyle(color: Colors.black)),
              onPressed: () {
                push(context, (ctx, model) => UserDetailsPage(),
                    () => ModelTwo());
              },
            ),
            // Button(
            //   child: Text('Trending Card Page',
            //       style: TextStyle(color: Colors.black)),
            //   onPressed: () {
            //     push(context, (ctx, model) => TrendingCardPage(),
            //         () => ModelTwo());
            //   },
            // ),
            Button(
              child: Text('HelloPage Card Page',
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                push(context, (ctx, model) => HelloPage(), () => ModelTwo());
              },
            ),
            Button(
              child: Text('user library Page',
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                push(context, (ctx, model) => UserLibraryPage(),
                    () => ModelTwo());
              },
            ),
          ],
        ),
      ),
    );
  }
}
