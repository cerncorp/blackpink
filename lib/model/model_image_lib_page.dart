import 'package:blackpink/api/all_api_helper.dart';
import 'package:easy_model/easy_model.dart';

class ModelImageLibPage extends Model {
  @override
  void initState() {
    // canConnectToServer
    // this.images = [];
    print('${this.runtimeType} initState');
  }

  @override
  void dispose() {
    print('${this.runtimeType} dispose');
  }

  ModelImageLibPage() {
    print('${this.runtimeType} create');
  }

  int value = 0;
  dynamic images;

  void reloadImages(String authToken) async {
    this.images = await ImageApiHelper.getImagesLib(authToken);
    print(images);
  }
}
