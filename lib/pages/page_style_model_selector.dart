import 'dart:math';
import 'dart:typed_data';

import 'package:blackpink/api/all_api_helper.dart';
import 'package:blackpink/common/common.dart';
import 'package:blackpink/model/all_model.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_model/easy_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class StyleModelSelectorPage extends StatefulWidget {
  @override
  _StyleModelSelectorPageState createState() => _StyleModelSelectorPageState();
}

class _StyleModelSelectorPageState extends State<StyleModelSelectorPage> {
  final fullName = "Samurai";

  GlobalModel globalModel;

  ModelImageStyleTransfer istStepperModel;

  ModelStyleModelSelector model;

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  void _fetchImages() async {
    globalModel = ModelGroup.findModel<GlobalModel>();
    istStepperModel = ModelGroup.findModel<ModelImageStyleTransfer>();

    model = ModelGroup.findModel<ModelStyleModelSelector>();

    // globalModel.uploadImages =
    //     await ImageApiHelper.getImagesLib(globalModel.authToken);
    // try {
    // model.reloadImages(globalModel.authToken);
    // } catch (e) {
    //   print(e);
    //   return;
    // }

    // model.images = globalModel.uploadImages;
    // print(globalModel.uploadImages);
    // model.refresh();
  }

  Widget _spacing(BuildContext context) {
    final responsive = MediaQuery.of(context).size.height;
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new SizedBox(
            height: responsive * 0.01,
            width: 500.0,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double responsive = MediaQuery.of(context).size.height;
    // var userState = Provider.of<UserState>(context);
    globalModel = ModelGroup.findModel<GlobalModel>();
    istStepperModel = ModelGroup.findModel<ModelImageStyleTransfer>();
    // model = ModelGroup.findModel<ModelImageLibPage>();
    // globalModel.uploadImages = globalModel.uploadImages;
    var images = istStepperModel.styleSelector;

    return Scaffold(
      appBar: AppBar(
        title: Text('ảnh đẹp không'),
        backgroundColor: Colors.black,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: images.length > 25 ? 25 : images.length,
          itemBuilder: (BuildContext context, int index) => FlatButton(
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
            highlightColor: Colors.red[200],
            onPressed: () async {
              await pool.play(globalModel.soundIdClicked2);
              istStepperModel.indexStyleSelected = images[index];
              print('selected: ${istStepperModel.indexStyleSelected}');
              istStepperModel.refresh();
              Navigator.of(context).pop();
            },
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: images.length > 0
                            ? CachedNetworkImageProvider(
                                '${ApiHelper.baseUrl}${images[index]['style_link']}',
                                scale: 0.2,
                                errorListener: () {
                                  final snackBar = SnackBar(
                                      content: Text(
                                          'Một số hình ảnh không thể hiển thị'));
                                  Scaffold.of(context).showSnackBar(snackBar);
                                },
                              )
                            : AssetImage('assets/images/instagram_logo.png'),
                        fit: BoxFit.cover))),
          ),
          staggeredTileBuilder: (int index) =>
              new StaggeredTile.count(2, index.isEven ? 2 : 1),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
      ),
    );
  }
}
