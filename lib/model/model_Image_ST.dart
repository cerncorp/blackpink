import 'package:easy_model/easy_model.dart';

class ModelImageStyleTransfer extends Model {
  @override
  void initState() {
    print('${this.runtimeType} initState');
  }

  @override
  void dispose() {
    print('${this.runtimeType} dispose');
  }

  ModelImageStyleTransfer() {
    print('${this.runtimeType} create');
  }

  int value = 0;

  bool isProcessing = false;
  double downloadValue = -1.0;

  double uploadValue = -1.0;

  String pathContentImg;

  List<dynamic> imagesSelector;

// image need to transfer
  Map<String, dynamic> indexSelected;

// style
  List<dynamic> styleSelector;
  Map<String, dynamic> indexStyleSelected;

  Map<String, dynamic> outputImage;

// trainmodel
  String resultTrainRegistration = 'chưa đăng kí';
  Map<String, dynamic> genStyleTrainInfo;

  void resetValue() {
    isProcessing = false;
    downloadValue = -1.0;
  }
}
