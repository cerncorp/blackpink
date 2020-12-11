import 'package:blackpink/common/common.dart';
import 'package:blackpink/model/all_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_model/easy_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:blackpink/api/all_api_helper.dart';
import 'package:path_provider/path_provider.dart';

class QueuePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Have fun!'),
      ),
      body: ListView(
        children: [
          ImageLogs(),
          // ImageLogs(),
          // ImageLogs(),
        ],
      ),
    );
  }
}

class ImageLogs extends StatelessWidget {
  // List items = [
  //   {
  //     'img': 'https://www.uit.edu.vn/sites/vi/files/uploads/images/hcld.png',
  //     'time': '11:11',
  //     'status': 'chờ xử lý',
  //   },
  //   {
  //     'img': 'https://www.uit.edu.vn/sites/vi/files/uploads/images/hcld.png',
  //     'time': '11:11',
  //     'status': 'chờ xử lý',
  //   },
  //   {
  //     'img': 'https://www.uit.edu.vn/sites/vi/files/uploads/images/hcld.png',
  //     'time': '11:11',
  //     'status': 'chờ xử lý',
  //   },
  //   {
  //     'img': 'https://www.uit.edu.vn/sites/vi/files/uploads/images/hcld.png',
  //     'time': '11:11',
  //     'status': 'chờ xử lý',
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    var model = ModelGroup.findModel<ModelHelloPage>();
    var items = model.imageGenQueue;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        children: <Widget>[
          Align(
            child: Text(
              "Image Style Transfer",
              style: TextStyle(fontSize: 40.0),
            ), //so big text
            alignment: FractionalOffset.topLeft,
          ),
          Column(
            children: ItemTile.generator(
              items,
              items.length > 20 ? 20 : items.length,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              //add some actions, icons...etc
              // FlatButton(onPressed: () {}, child: Text("EDIT")),
              FlatButton(
                  onPressed: () {},
                  child: Text(
                    "Làm mới",
                    style: TextStyle(color: Colors.redAccent),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}

enum ItemStatus {
  download,
  wait,
}

class ItemTile extends StatelessWidget {
  const ItemTile(
      {Key key,
      this.imgUrl,
      this.time,
      this.status,
      this.imgStyleUrl,
      this.imgOutputUrl})
      : super(key: key);
  static final String download = 'Tải về';
  static final String wait = 'Chờ xử lý';

  static List<Widget> generator(List items, int count) {
    List<Widget> genWidgets = new List<Widget>();
    for (var item in items) {
      genWidgets.add(new ItemTile(
        imgUrl: '${item['content_img']}',
        imgStyleUrl: '${item['style_img']}',
        imgOutputUrl: '${item['output_img']}',
        time: '${parseStringDate2TextVersion(item['updated'])}',
        status: item['isCompleted'] ? ItemStatus.download : ItemStatus.wait,
      ));
    }
    return genWidgets;
  }

  final String imgUrl;
  final String imgStyleUrl;
  final String imgOutputUrl;
  final String time;
  final ItemStatus status;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: Colors.blue,
        ),
        Align(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 30, maxHeight: 30),
                  child: CachedNetworkImage(
                    imageUrl: imgUrl,
                    errorWidget: (_, __, ___) => Image.asset(
                      'assets/images/rezise1.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(time),
                status == ItemStatus.download
                    ? IconButton(
                        icon: Icon(Icons.download_rounded),
                        iconSize: 30,
                        onPressed: () async {
                          // String file = await _findPath(imgUrl);
                          // print('download $file');
                          // final directory =
                          //     await getApplicationDocumentsDirectory();

                          final extDir = await getExternalStorageDirectory();
                          // print(directory.path);
                          print(extDir.path);

                          // return directory.path;
                          String fileName = this.imgOutputUrl.split('/').last;
                          print(fileName);
                          bool result = await ImageApiHelper.downloadUrl(
                              imgOutputUrl,
                              '${extDir.path}/StyleTransfer/$fileName',
                              (_, __) {});
                          if (result) {
                            print('downloaded $fileName');
                            return;
                          }
                          print('Something error when downloaded $fileName');
                        },
                      )
                    : Text('chờ xử lý'),
              ],
            ),
          ),
          alignment: FractionalOffset.topLeft,
        ),
      ],
    );
  }

  Future<String> _findPath(String imageUrl) async {
    // final cache = await CacheManager.getInstance();
    // final file = await DefaultCacheManager().getSingleFile(imageUrl);
    final file = await DefaultCacheManager().getSingleFile(imageUrl);
    return file.path;
  }
}
