import 'dart:math';
import 'dart:typed_data';

import 'package:blackpink/api/all_api_helper.dart';
import 'package:blackpink/model/all_model.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_model/easy_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class UserLibraryPage extends StatefulWidget {
  @override
  _UserLibraryPageState createState() => _UserLibraryPageState();
}

class _UserLibraryPageState extends State<UserLibraryPage> {
  final fullName = "Samurai";

  GlobalModel globalModel;

  ModelImageLibPage model;

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  void _fetchImages() async {
    globalModel = ModelGroup.findModel<GlobalModel>();
    model = ModelGroup.findModel<ModelImageLibPage>();
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
    // model = ModelGroup.findModel<ModelImageLibPage>();
    // globalModel.uploadImages = globalModel.uploadImages;

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
          itemCount: globalModel.uploadImages.length > 10
              ? 10
              : globalModel.uploadImages.length,
          itemBuilder: (BuildContext context, int index) => new Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: globalModel.uploadImages.length > 0
                          ? CachedNetworkImageProvider(
                              '${ApiHelper.baseUrl}${globalModel.uploadImages[index]['uploadfile']}',
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
          staggeredTileBuilder: (int index) =>
              new StaggeredTile.count(2, index.isEven ? 2 : 1),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
      ),
    );
  }
}
