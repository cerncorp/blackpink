import 'package:easy_model/easy_model.dart';
import 'package:flutter/material.dart';

import 'package:blackpink/model/all_model.dart';
import 'package:blackpink/pages/all_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ModelWidget<GlobalModel>(
      childBuilder: (context, model) {
        return MaterialApp(
          title: 'Art',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(brightness: model.brightness),
          home: PageRoot(),
        );
      },
      modelBuilder: () => GlobalModel(),
    );
  }
}
