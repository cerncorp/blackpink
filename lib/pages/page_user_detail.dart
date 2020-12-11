import 'dart:ui';

import 'package:blackpink/api/all_api_helper.dart';
import 'package:blackpink/model/all_model.dart';
import 'package:blackpink/pages/page_user_library.dart';
import 'package:easy_model/easy_model.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:snaplist/snaplist.dart';

class UserDetailsPage extends StatefulWidget {
  final bool isMyUserDetail;

  const UserDetailsPage({Key key, this.isMyUserDetail}) : super(key: key);

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final fullName = "Samurai";

  GlobalModel globalModel;

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  void _fetchImages() async {
    globalModel = ModelGroup.findModel<GlobalModel>();
    // model = ModelGroup.findModel<ModelImageLibPage>();
    var response = await ImageApiHelper.getImagesLib(globalModel.authToken);

    if (response != null && response.statusCode == 200) {
      globalModel.uploadImages = response.data;
      print(globalModel.uploadImages);
      return;
    }
    print('fetch image error');

    // try {
    // model.reloadImages(globalModel.authToken);
    // } catch (e) {
    //   print(e);
    //   return;
    // }

    // model.images = globalModel.uploadImages;
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
    return ModelWidget<ModelUserDetail>(
      modelBuilder: () => ModelUserDetail(),
      childBuilder: (context, model) {
        return Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.black,
            title: Text('Thư viện cá nhân'),
            centerTitle: false,
          ),
          body: new ListView(
            children: <Widget>[
              new Stack(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.all(0.0),
                    height: responsive * 0.2,
                    decoration: new BoxDecoration(
                        image: DecorationImage(
                      image:
                          AssetImage('assets/images/rain_princess_small.jpg'),
                      // NetworkImage("https://iambharat.tk/images/hiretpp.jpg"),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      repeat: ImageRepeat.noRepeat,
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Container(
                      padding: new EdgeInsets.only(top: responsive * 0.15),
                      child: new Card(
                        child: Container(
                          padding: new EdgeInsets.only(
                              top: responsive * 0.15,
                              bottom: responsive * 0.05),
                          child: new Column(
                            children: <Widget>[
                              Center(
                                child: new Text(
                                  fullName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40.0),
                                ),
                              ),
                              _spacing(context),
                              new Text(
                                fullName,
                                style: new TextStyle(color: Colors.grey),
                              ),
                              _spacing(context),
                              new Text(fullName),
                              _spacing(context),
                              new Text(
                                fullName,
                              ),
                              _spacing(context),
                              _spacing(context),
                              new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  InkWell(
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child: Image.asset(
                                        'assets/images/facebook_logo.png', //"images/icons/facebook_logo.png",
                                        width: 30.0,
                                      ),
                                    ),
                                    onTap: () {},
                                  ),
                                  InkWell(
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child: Image.asset(
                                        'assets/images/instagram_logo.png', //"images/icons/instagram_logo.png",
                                        width: 30.0,
                                      ),
                                    ),
                                    onTap: () {
                                      print("H");
                                    },
                                  ),
                                  InkWell(
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child: Image.asset(
                                        'assets/images/website_logo.png', //"images/icons/website_logo.png",
                                        width: 30.0,
                                      ),
                                    ),
                                    onTap: () {},
                                  ),
                                  InkWell(
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child: Image.asset(
                                        'assets/images/linkedin_logo.png', //"images/icons/linkedin_logo.png",
                                        width: 30.0,
                                      ),
                                    ),
                                    onTap: () {},
                                  ),
                                  InkWell(
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child: Image.asset(
                                        'assets/images/twitter_logo.png', //"images/icons/twitter_logo.png",
                                        width: 30.0,
                                      ),
                                    ),
                                    onTap: () {},
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        elevation: 5.0,
                      ),
                    ),
                  ),
                  Card(
                    elevation: 10.0,
                    shape: CircleBorder(),
                    color: Colors.transparent,
                    child: Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.only(top: responsive * 0.02),
                      child: new Center(
                        child: CircleAvatar(
                          radius: 100.0,
                          backgroundImage:
                              AssetImage('assets/images/rock_calm.jpg'),
                          // new NetworkImage(
                          //     userState.currentSelected.pictureLarge),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: responsive * 0.2,
                        left: MediaQuery.of(context).size.width * 0.8),
                    child: IconButton(
                      icon: Icon(Icons.logout),
                      iconSize: 30,
                      onPressed: () {
                        print('Thoat');
                      },
                    ),
                  ),
                ],
              ),
              Container(
                height: 170,
                child: SnapList(
                  padding: EdgeInsets.only(
                      left: (MediaQuery.of(context).size.width -
                              Size(200.0, 150.0).width) /
                          2),
                  sizeProvider: (index, data) => Size(200.0, 150.0),
                  separatorProvider: (index, data) => Size(40.0, 10.0),
                  builder: (context, index, data) => GestureDetector(
                    onTap: () {
                      print('$index');
                      if (globalModel.uploadImages != null &&
                          globalModel.uploadImages.length > 0) {
                        print(globalModel.uploadImages);
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                child: UserLibraryPage()));
                      }
                    },
                    child: Container(
                      constraints: BoxConstraints.expand(),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/christina.jpg'),
                              fit: BoxFit.cover)),
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.grey.withOpacity(0.1),
                            child: Text(
                              "Ảnh nghệ thuật",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  count: 3,
                  // snaplistController: controller,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
