import 'package:easy_model/easy_model.dart';

class ModelTwo extends Model {
  @override
  void initState() {
    pathContentImg = "";
    idStyleModel = -1;
    canFusion = true;
    hasResult = false;
    uploadprogress = 0;
    print('${this.runtimeType} initState');
  }

  @override
  void dispose() {
    print('${this.runtimeType} dispose');
  }

  ModelTwo() {
    print('${this.runtimeType} create');
  }

  int pageValue = 0;
  int partValue = 0;

  String pathContentImg;
  int idStyleModel; // in globalModel list
  bool canFusion;
  bool hasResult;

  double uploadprogress;
  Map<String, dynamic> infoStyledImg;
}
