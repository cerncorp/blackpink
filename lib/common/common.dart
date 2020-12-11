export '../model/all_model.dart';
export '../pages/all_pages.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:soundpool/soundpool.dart';

import 'package:blackpink/api/api_helper.dart';
import 'package:easy_model/easy_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

void push<T extends Model>(BuildContext context, ChildBuilder<T> widget,
    ModelBuilder<T> modelBuilder) {
  Navigator.of(context).push(
    new MaterialPageRoute(
      builder: (ctx) {
        return ModelWidget<T>(
          childBuilder: widget,
          modelBuilder: modelBuilder,
        );
      },
    ),
  );
}

void pushTransition<T extends Model>(
    BuildContext context, ChildBuilder<T> widget, ModelBuilder<T> modelBuilder,
    {PageTransitionType type = PageTransitionType.fade}) {
  // Navigator.push(
  //     context,
  //     PageTransition(
  //         type: PageTransitionType.bottomToTop, child: DetailScreen()));

//   Navigator.of(context).push(
//     new MaterialPageRoute(
//       builder: (ctx) {
//         return ModelWidget<T>(
//           childBuilder: widget,
//           modelBuilder: modelBuilder,
//         );
//       },
//     ),
//   );
  Navigator.of(context).push(
    PageTransition<T>(
      type: type,
      child: ModelWidget<T>(
        childBuilder: widget,
        modelBuilder: modelBuilder,
      ),
    ),
  );
}

class Button extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final bool enableRandomColor;

  const Button(
      {Key key, this.onPressed, this.child, this.enableRandomColor = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: enableRandomColor ? randomColor : Theme.of(context).primaryColor,
      child: child ?? Text('Next Page', style: TextStyle(color: Colors.white)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      onPressed: onPressed,
    );
  }
}

Color get randomColor =>
    Colors.primaries[Random().nextInt(Colors.primaries.length)];

getRandomColor() => [
      Colors.blueAccent,
      Colors.redAccent,
      Colors.greenAccent,
    ][Random().nextInt(3)];

// "created": "2020-10-29T01:10:57.717981Z"
DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
DateTime dateParse(String date) => dateFormat.parse(date);

String date2TextVersion(DateTime date) {
  final df = new DateFormat('dd-MM-yyyy hh:mm a');
  final smallDF = new DateFormat('hh:mm a');
  var now = DateTime.now();
  var diff = DateTime(date.year, date.month, date.day)
      .difference(DateTime(now.year, now.month, now.day))
      .inDays;
  if (diff == -1) {
    return "Hôm qua - ${smallDF.format(date)}";
  } else if (diff == 0) {
    return "Hôm nay - ${smallDF.format(date)}";
  } else {
    return df.format(date);
  }
}

String parseStringDate2TextVersion(String date) =>
    date2TextVersion(dateParse(date));

final double MAXIMAGESIZE = 3200.0 * 2500.0;

// double max(double a, double b)

String recheckUrl(String url) {
  if (url.contains('http')) return url;
  return ApiHelper.baseUrl + url;
}

// final String soundClicked1 = 'sounds/clicked.wav';
final String soundClicked2 = 'assets/sounds/clicked.m4a';
// final String soundClicked3 = 'sounds/clicked.mp3';

final String soundTing = 'assets/sounds/ting.m4a';

// final AudioCache player = AudioCache()..loadAll([soundClicked2, soundTing]);

final Soundpool pool = Soundpool(streamType: StreamType.notification);
// final int soundId =
//     await rootBundle.load(soundClicked2).then((ByteData soundData) {
//   return pool.load(soundData);
// });
// int streamId = await pool.play(globalModel.soundId);
