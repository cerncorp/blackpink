import 'package:blackpink/api/all_api_helper.dart';
import 'package:blackpink/common/common.dart';
import 'package:blackpink/common/constant.dart';
import 'package:blackpink/pages/page_queue.dart';
import 'package:blackpink/pages/page_train_style_model.dart';

import 'package:blackpink/pages/page_trending_card.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/material.dart';
import 'package:easy_model/easy_model.dart';
import 'package:flutter_speed_dial_material_design/flutter_speed_dial_material_design.dart';
import 'package:page_transition/page_transition.dart';
import 'package:story_view/story_view.dart';
import 'package:blackpink/model/all_model.dart';

class HelloPage extends StatelessWidget {
  // final StoryController controller = StoryController();
  SpeedDialController _controller = SpeedDialController();

  @override
  Widget build(BuildContext context) {
    var globalModel = ModelGroup.findModel<GlobalModel>();
    var modelHello = ModelGroup.findModel<ModelHelloPage>();

    modelHello.images = globalModel.helloPageImages;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          // Add the app bar to the CustomScrollView.
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: BorderedText(
                  strokeWidth: 2.0,
                  child: Text(
                    'Hello;',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      decorationColor: Colors.pink,
                    ),
                  ),
                ),

                // Text("Hello;",
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 16.0,
                //     )),
                background: Image.asset(
                  "assets/images/rain_princess_small.jpg",
                  fit: BoxFit.cover,
                )),
            actions: [
              IconButton(
                icon: Icon(Icons.local_florist),
                onPressed: () async {
                  // Navigator.push(
                  //     context,
                  //     PageTransition(
                  //         type: PageTransitionType.rightToLeftWithFade,
                  //         child: UserDetailsPage(
                  //           isMyUserDetail: true,
                  //         )));
                  var globalModel = ModelGroup.findModel<GlobalModel>();
                  await pool.play(globalModel.soundIdClicked2);
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeftWithFade,
                          child: MyProfilePage()));
                },
              ),
            ],
          ),
          // Next, create a SliverList
          SliverList(
            // Use a delegate to build items as they're scrolled on screen.
            delegate: SliverChildBuilderDelegate(
              // The builder function returns a ListTile with a title that
              // displays the index of the current item.
              (context, index) {
                return TrendingItem(
                  beforeImg:
                      '${ApiHelper.baseUrl}${modelHello.images[index]['content_img']}',
                  afterImg:
                      '${ApiHelper.baseUrl}${modelHello.images[index]['output_img']}',
                );
              },
              // Builds 1000 ListTiles
              childCount:
                  modelHello.images.length > 10 ? 10 : modelHello.images.length,
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: _buildBottomBar(context),
      //  FloatingActionButton(
      //   onPressed: () {
      //     print('pressed');
      //   },
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.green,
      // ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    final icons = [
      SpeedDialAction(child: Icon(Icons.train)),
      SpeedDialAction(child: Icon(Icons.movie_creation)),
      SpeedDialAction(child: Icon(Icons.add_photo_alternate)),
    ];

    return SpeedDialFloatingActionButton(
      actions: icons,
      // Make sure one of child widget has Key value to have fade transition if widgets are same type.
      childOnFold: Icon(Icons.event_note, key: UniqueKey()),
      childOnUnfold: Icon(Icons.add),
      useRotateAnimation: true,
      onAction: (int selectedActionIndex) async {
        print('$selectedActionIndex Selected');
        var globalModel = ModelGroup.findModel<GlobalModel>();
        await pool.play(globalModel.soundIdClicked2);
        if (selectedActionIndex == 0) {
          // model train

          pushTransition(context, (ctx, model) => TrainStyleModelPage(),
              () => ModelImageStyleTransfer(),
              type: PageTransitionType.scale);
        } else if (selectedActionIndex == 1) {
          // video transfer
        } else {
          //  image transfer

          pushTransition(context, (ctx, model) => ImageSTPage(),
              () => ModelImageStyleTransfer(),
              type: PageTransitionType.scale);
        }
      },
      controller: _controller,
    );
  }

  // _onSpeedDialAction(int selectedActionIndex) {
  //   print('$selectedActionIndex Selected');
  //   if (selectedActionIndex == 0) {
  //     // model train

  //   } else if (selectedActionIndex == 1) {
  //     // video transfer
  //   } else {
  //     //  image transfer

  //     pushTransition(context, (ctx, model) => ImageSTPage(),
  //         () => ModelImageStyleTransfer(),
  //         type: PageTransitionType.scale);
  //   }
  // }

  Widget _buildBottomBar(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.art_track),
              onPressed: () async {
                var globalModel = ModelGroup.findModel<GlobalModel>();

                var model = ModelGroup.findModel<ModelHelloPage>();
                await pool.play(globalModel.soundIdClicked2);
                var hasResult =
                    await model.reloadImageGen(globalModel.authToken);

                if (hasResult) {
                  pushTransition(
                      context, (ctx, model) => QueuePage(), () => ModelQueue(),
                      type: PageTransitionType.scale);
                } else {
                  // thong bao
                  print('khong the load danh sach imageGen');
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () async {
                var globalModel = ModelGroup.findModel<GlobalModel>();
                await pool.play(globalModel.soundIdClicked2);
                pushTransition(context, (ctx, model) => SettingsPage(),
                    () => ModelSettings(),
                    type: PageTransitionType.scale);
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                var globalModel = ModelGroup.findModel<GlobalModel>();

                var modelHello = ModelGroup.findModel<ModelHelloPage>();
                await pool.play(globalModel.soundIdClicked2);

                await globalModel.reloadHelloPageImages();

                modelHello.images = globalModel.helloPageImages;
                modelHello.refresh();
              },
            ),
          ],
        ),
      ),
    );
  }
}
