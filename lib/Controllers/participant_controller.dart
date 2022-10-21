import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';

import '../Models/participant.dart';
import '../Services/participant_service.dart';
import '../Utils/constants.dart';

class ParticipantController extends GetxController {

  final ParticipantService service = ParticipantService();
  bool _isLoading = false;
  bool get isloading=>_isLoading;
  List<dynamic> _myData = [];
  List<dynamic> get myData=>_myData;
  List<Participant> listParticipant = List<Participant>.empty(growable: true);
  //RxList<Participant> participantList = List<Participant>.empty(growable: true).obs;

  @override
  void onInit() async {
    getData();
    //getParticipants();
    super.onInit();
  }

  Future<void> getData() async {
    try {
    _isLoading = true;
    Response response = await service.getData(AppConstants.PATICIPANT_URL);
    if(response.statusCode == 200){
      _myData = response.body['fetchedParticipants'];
     /* var data = response.body['fetchedParticipants'];
      data.forEach((action){
        var model = Participant(id: action['_id'], fullName: action['fullName'], email: action['email'], job: action['job'], createdAt: action['createdAt']);
        listParticipant.add(model);
        //print('length ${listParticipant.length}');
      }); */
      print('get data');
      update();
    }
    else {
      print('An error has occured');
    }
    }
    catch (ex){
      Get.snackbar(
        "Error",
        "Error " + ex.toString(),
        snackPosition: SnackPosition.BOTTOM,

      );
      print("throwing new error " + ex.toString());
      throw Exception("Error " + ex.toString());
      _isLoading = false;
    }
    finally {
      _isLoading = false;
    }
  }

  /*void getParticipants() async {
    try {
      _isLoading = true;
      var result = await ParticipantService().getParticipantService();
      if (result != null) {
        participantList.assignAll(popularParticipantListFromJson(result.body));
        print(participantList.length);
        print('get data');
      }
    }
    catch (ex){
      Get.snackbar(
        "Error",
        "Error " + ex.toString(),
        snackPosition: SnackPosition.BOTTOM,

      );
    print("throwing new error " + ex.toString());
    throw Exception("Error " + ex.toString());
    _isLoading = false;
    }
    finally {
      _isLoading = false;
    }
  }*/

  Future<void> postData(String fullName, String email, String job) async {
    try {
      _isLoading = true;
      Response response = await service.postData(
          AppConstants.PATICIPANT_URL,
          {
            "fullName":fullName,
            "email":email,
            "job":job
          });
      if(response.statusCode == 200){
        update();
        getData();
      }
      else {
        print('An error has occured');
      }
    }
    catch (ex){
      print("throwing new error " + ex.toString());
      throw Exception("Error " + ex.toString());
    }
    _isLoading = false;
  }

  Future<void> getDataById(String id) async {
    _isLoading = true;
    Response response = await service.getData('${AppConstants.PATICIPANT_URL}/${id}');
    if(response.statusCode == 200){
      //_myData = response.body['fetchedParticipants'];
      print('get data');
      update();
    }
    else {
      print('An error has occured');
    }
    _isLoading = false;
  }

  Future<void> deleteData(String id) async {
    //_isLoading = true;
    Response response = await service.deleteData('${AppConstants.PATICIPANT_URL}/${id}');
    if(response.statusCode == 200){
      print('data deleted');
      update();
      getData();
    }
    else {
      print('An error has occured');
    }
    //_isLoading = false;
  }
}