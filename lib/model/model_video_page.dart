import 'package:easy_model/easy_model.dart';

class ModelVideoPage extends Model {
  @override
  void initState() {
    print('${this.runtimeType} initState');
  }

  @override
  void dispose() {
    print('${this.runtimeType} dispose');
  }

  ModelVideoPage() {
    print('${this.runtimeType} create');
  }

  int value = 0;
}
