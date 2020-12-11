import 'all_pages.dart';
import 'package:easy_model/easy_model.dart';

import '../common/common.dart';
import 'package:flutter/material.dart';

class PageRoot extends StatelessWidget {
  GlobalModel globalModel;

  @override
  Widget build(BuildContext context) {
    globalModel = ModelGroup.findModel<GlobalModel>();
//  //  nen ping toi server cho chac an
//     if (globalModel.authToken != "") {
//       // login
//       push(context, (ctx, model) => HelloPage(), () => ModelHelloPage());
//     }
    return Scaffold(
      body: ReflectlyLoginPage(),
    );
  }
}
