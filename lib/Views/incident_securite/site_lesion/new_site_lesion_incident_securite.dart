import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Utils/custom_colors.dart';
import '../../../../Utils/shared_preference.dart';
import '../../../../Utils/snack_bar.dart';
import '../../../Controllers/api_controllers_call.dart';
import '../../../Models/incident_securite/site_lesion_model.dart';
import '../../../Services/incident_securite/incident_securite_service.dart';
import '../../../Services/incident_securite/local_incident_securite_service.dart';
import '../../../Validators/validator.dart';
import 'site_lesion_incident_securite_page.dart';

class NewSiteLesionIncidentSecurite extends StatefulWidget {
  final numIncident;

  const NewSiteLesionIncidentSecurite({Key? key, required this.numIncident}) : super(key: key);

  @override
  State<NewSiteLesionIncidentSecurite> createState() => _NewSiteLesionIncidentSecuriteState();
}

class _NewSiteLesionIncidentSecuriteState extends State<NewSiteLesionIncidentSecurite> {
  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();

  TextEditingController  ncController = TextEditingController();

  int? selectedCodeSiteLesion = 0;
  String? siteLesion = '';
  SiteLesionModel? siteLesionModel = null;

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  @override
  void initState(){
    ncController.text = widget.numIncident.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: TextButton(
          onPressed: (){
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: Colors.white,),
        ),
        title: Text("New Site Lesion Of Incident",textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16.0),),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: SingleChildScrollView(
                child: Form(
                    key: _addItemFormKey,
                    child: Padding(
                        padding: EdgeInsets.all(25.0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 8.0,),
                            TextFormField(
                              enabled: false,
                              controller: ncController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value) => Validator.validateField(
                                  value: value!
                              ),
                              decoration: InputDecoration(
                                  labelText: 'Incident N°',
                                  hintText: 'incident',
                                  labelStyle: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10.0,
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  )
                              ),
                              style: TextStyle(fontSize: 14.0),
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                                visible: true,
                                child: DropdownSearch<SiteLesionModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Site Lesion *",
                                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) => getSiteLesion(filter),
                                  onChanged: (data) {
                                    siteLesionModel = data;
                                    selectedCodeSiteLesion = data?.codeSiteLesion;
                                    siteLesion = data?.siteLesion;
                                    print('site Lesion: $siteLesion, code: ${selectedCodeSiteLesion}');
                                  },
                                  dropdownBuilder: _customDropDownSiteLesion,
                                  popupItemBuilder: _customPopupItemBuilderSiteLesion,
                                  validator: (u) =>
                                  u == null ? "Site Lesion is required " : null,
                                )
                            ),
                            SizedBox(height: 20.0,),
                            _isProcessing
                                ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  CustomColors.firebaseOrange,
                                ),
                              ),
                            )
                                :
                            ElevatedButton(
                              onPressed: () async {
                                saveBtn();
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  CustomColors.googleBackground,
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Save',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.firebaseWhite,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                    )
                ),
              ),
            ),
          )
      ),
    );
  }

  Future saveBtn() async {
    if(_addItemFormKey.currentState!.validate()){
      try {
        setState(()  {
          _isProcessing = true;
        });
        var connection = await Connectivity().checkConnectivity();
        if(connection == ConnectivityResult.none){
          int max_id = await LocalIncidentSecuriteService().getMaxNumSiteLesionIncSecRattacher();
          int? id_inc_site_lision = max_id + 1;
          var model = SiteLesionModel();
          model.online = 0;
          model.idIncident = widget.numIncident;
          model.idIncCodeSiteLesion = id_inc_site_lision;
          model.codeSiteLesion = selectedCodeSiteLesion;
          model.siteLesion = siteLesion;
          await LocalIncidentSecuriteService().saveSiteLesionIncSecRattacher(model);
          Get.to(SiteLesionIncidentSecuritePage(numIncident: widget.numIncident,));
        }
        else if (connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile){
          await IncidentSecuriteService().saveSiteLesionByIncident({
            "idIncident": widget.numIncident,
            "idSiteLesion": selectedCodeSiteLesion
          }).then((resp) async {
            ShowSnackBar.snackBar("Successfully", "Site Lesion added", Colors.green);
            //Get.back();
            Get.to(SiteLesionIncidentSecuritePage(numIncident: widget.numIncident,));
            await ApiControllersCall().getSiteLesionIncSecRattacher();
          }, onError: (err) {
            setState(()  {
              _isProcessing = false;
            });
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          });
        }

      }
      catch (ex){
        setState(()  {
          _isProcessing = false;
        });
        AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.ERROR,
          body: Center(child: Text(
            ex.toString(),
            style: TextStyle(fontStyle: FontStyle.italic),
          ),),
          title: 'Error',
          btnCancel: Text('Cancel'),
          btnOkOnPress: () {
            Navigator.of(context).pop();
          },
        )..show();
        print("throwing new error " + ex.toString());
        throw Exception("Error " + ex.toString());
      }
      finally{
        setState(()  {
          _isProcessing = false;
        });
      }
    }
  }

  Future<List<SiteLesionModel>> getSiteLesion(filter) async {
    try {
      List<SiteLesionModel> _lesionList = await List<SiteLesionModel>.empty(growable: true);
      List<SiteLesionModel> _lesionFilter = await List<SiteLesionModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await LocalIncidentSecuriteService().readSiteLesionIncSecARattacherByIncident(widget.numIncident);
        response.forEach((data){
          var model = SiteLesionModel();
          model.codeSiteLesion = data['codeSiteLesion'];
          model.siteLesion = data['siteLesion'];
          _lesionList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await IncidentSecuriteService().getSiteLesionIncidentSecurite(widget.numIncident, matricule).then((resp) async {
          resp.forEach((data) async {
            var model = SiteLesionModel();
            model.codeSiteLesion = data['code_siteDeLesion'];
            model.siteLesion = data['siteDeLesion'];
            _lesionList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      _lesionFilter = _lesionList.where((u) {
        var query = u.siteLesion!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _lesionFilter;

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  Widget _customDropDownSiteLesion(BuildContext context, SiteLesionModel? item) {
    if (item == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item.siteLesion}'),
          //subtitle: Text('${item?.codetypecause.toString()}'),
        ),
      );
    }
  }
  Widget _customPopupItemBuilderSiteLesion(
      BuildContext context,SiteLesionModel item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.siteLesion ?? ''),
        //subtitle: Text(item.codetypecause.toString() ?? ''),
      ),
    );
  }
}
