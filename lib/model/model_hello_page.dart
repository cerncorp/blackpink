import 'package:blackpink/api/all_api_helper.dart';
import 'package:easy_model/easy_model.dart';

class ModelHelloPage extends Model {
  @override
  void initState() {
    print('${this.runtimeType} initState');
  }

  @override
  void dispose() {
    print('${this.runtimeType} dispose');
  }

  ModelHelloPage() {
    print('${this.runtimeType} create');
  }

  Future<bool> reloadImageGen(String authToken) async {
    var list = await ImageApiHelper.getImageGenList(authToken);

    if (list != null && list.statusCode == 200) {
      this.imageGenQueue = new List();
      for (var item in list.data) {
        var transfer = new Map<String, dynamic>();
        if (item['idimg_output'] != null) {
          // transfer['img'] = '${ApiHelper.baseUrl}${item['content_img']}';
          transfer['output_img'] = '${ApiHelper.baseUrl}${item['output_img']}';
        } else {
          transfer['output_img'] =
              'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Question_mark.svg/220px-Question_mark.svg.png';
        }

        transfer['content_img'] = '${ApiHelper.baseUrl}${item['content_img']}';

        transfer['style_img'] = '${ApiHelper.baseUrl}${item['style_img']}';

        transfer['updated'] = item['updated'];

        transfer['isSuccess'] = item['isSuccess'];
        transfer['isCompleted'] = item['isCompleted'];
        transfer['isCancel'] = item['isCancel'];
        transfer['isShared'] = item['isShared'];
        transfer['progress'] = item['progress'];
        transfer['order'] = item['order'];
        transfer['idgenimg'] = item['idgenimg'];
        transfer['idUser'] = item['idUser'];
        transfer['idimg_input'] = item['idimg_input'];
        transfer['idsm_input'] = item['idsm_input'];
        transfer['idimg_output'] = item['idimg_output'];
        this.imageGenQueue.add(transfer);
      }
      return true;
    }

    // this.styleModelList = listSMResponse.data;
    return false;
  }

  List<Map<String, dynamic>> imageGenQueue;

  dynamic images;

  int value = 0;
}
