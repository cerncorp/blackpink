import 'package:blackpink/common/common.dart';
import 'package:blackpink/common/constant.dart';
import 'package:blackpink/common/flip_card.dart';
import 'package:blackpink/model/all_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_model/easy_model.dart';
import 'package:flutter/material.dart';

// class TrendingCardPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0.0,
//         title: Text("Trending Restaurants"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
//         child: ListView(
//           children: <Widget>[
//             // SearchCard(),
//             SizedBox(height: 10.0),
//             ListView.builder(
//               primary: false,
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: restaurants == null ? 0 : restaurants.length,
//               itemBuilder: (BuildContext context, int index) {
//                 Map restaurant = restaurants[index];

//                 return TrendingItem(
//                   img: restaurant["img"],
//                   title: restaurant["title"],
//                   address: restaurant["address"],
//                   rating: restaurant["rating"],
//                 );
//               },
//             ),
//             SizedBox(height: 10.0),
//           ],
//         ),
//       ),
//     );
//   }
// }

class TrendingItem extends StatefulWidget {
  // final String img;
  // final String title;
  // final String address;
  // final String rating;
  final String beforeImg;
  final String afterImg;

  TrendingItem({
    Key key,
    @required this.beforeImg,
    @required this.afterImg,
  }) : super(key: key);

  @override
  _TrendingItemState createState() => _TrendingItemState();
}

class _TrendingItemState extends State<TrendingItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Container(
        // height: MediaQuery.of(context).size.height / 2.5,
        width: MediaQuery.of(context).size.width,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 3.0,
          child: Stack(
            children: [
              FlipCard(
                direction: FlipDirection.HORIZONTAL,
                speed: 1000,
                onFlipDone: (status) async {
                  var globalModel = ModelGroup.findModel<GlobalModel>();
                  await pool.play(globalModel.soundIdTing);
                  print(status);
                },
                front: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF006666),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: widget.beforeImg == null
                      ? Image.asset(
                          'assets/images/rock_calm.jpg',
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(imageUrl: widget.beforeImg),
                ),
                back: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF006666),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: widget.afterImg == null
                      ? Image.asset(
                          'assets/images/rock_aggresive.jpg',
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(imageUrl: widget.afterImg),
                ),
              ),
              // Positioned(
              //   top: 6.0,
              //   right: 6.0,
              //   child: FlatButton(
              //     onPressed: () {
              //       print('clicked');
              //     },
              //     child: Padding(
              //       padding: EdgeInsets.all(2.0),
              //       child: Row(
              //         children: <Widget>[
              //           Icon(
              //             Icons.verified_user,
              //             color: Colors.yellow,
              //             size: 20.0,
              //           ),
              //           Text("more",
              //               style: TextStyle(
              //                 fontSize: 20.0,
              //               )),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          // Column(
          //   children: <Widget>[
          //   Stack(
          // children: <Widget>[
          // Container(
          // height: MediaQuery.of(context).size.height / 3.5,
          //   width: MediaQuery.of(context).size.width,
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(10),
          //       topRight: Radius.circular(10),
          //     ),
          //     child: Image.asset(
          //       "${widget.img}",
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          // Positioned(
          //   top: 6.0,
          //   right: 6.0,
          //   child: Card(
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(4.0)),
          //     child: Padding(
          //       padding: EdgeInsets.all(2.0),
          //       child: Row(
          //         children: <Widget>[
          //           Icon(
          //             Icons.star,
          //             color: Colors.yellow,
          //             size: 10.0,
          //           ),
          //           Text(
          //             " ${widget.rating} ",
          //             style: TextStyle(
          //               fontSize: 10.0,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // Positioned(
          //   top: 6.0,
          //   left: 6.0,
          //   child: Card(
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(3.0)),
          //     child: Padding(
          //       padding: EdgeInsets.all(4.0),
          //       child: Text(
          //         " OPEN ",
          //         style: TextStyle(
          //           fontSize: 10.0,
          //           color: Colors.green,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          //   ],
          // ),
          // SizedBox(height: 7.0),
          // Padding(
          //   padding: EdgeInsets.only(left: 15.0),
          //   child: Container(
          //     width: MediaQuery.of(context).size.width,
          //     child: Text(
          //       "${widget.title}",
          //       style: TextStyle(
          //         fontSize: 20.0,
          //         fontWeight: FontWeight.w800,
          //       ),
          //       textAlign: TextAlign.left,
          //     ),
          //   ),
          // ),
          // SizedBox(height: 7.0),
          // Padding(
          //   padding: EdgeInsets.only(left: 15.0),
          //   child: Container(
          //     width: MediaQuery.of(context).size.width,
          //     child: Text(
          //       "${widget.address}",
          //       style: TextStyle(
          //         fontSize: 12.0,
          //         fontWeight: FontWeight.w300,
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(height: 10.0),
          // ],
          // ),
        ),
      ),
    );
  }
}
