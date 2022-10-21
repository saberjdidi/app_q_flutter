import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Utils/custom_colors.dart';
import '../../../../Utils/shared_preference.dart';
import '../../../../Utils/snack_bar.dart';
import '../../../Controllers/api_controllers_call.dart';
import '../../../Models/incident_environnement/type_cause_incident_model.dart';
import '../../../Models/incident_securite/site_lesion_model.dart';
import '../../../Models/type_cause_model.dart';
import '../../../Services/incident_securite/incident_securite_service.dart';
import '../../../Services/incident_securite/local_incident_securite_service.dart';
import '../../../Validators/validator.dart';
import 'type_cause_incident_securite_page.dart';

class NewTypeCauseIncidentSecurite extends StatefulWidget {
  final numIncident;

  const NewTypeCauseIncidentSecurite({Key? key, required this.numIncident}) : super(key: key);

  @override
  State<NewTypeCauseIncidentSecurite> createState() => _NewTypeCauseIncidentSecuriteState();
}

class _NewTypeCauseIncidentSecuriteState extends State<NewTypeCauseIncidentSecurite> {
  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();

  TextEditingController  ncController = TextEditingController();

  int? selectedCodeType = 0;
  String? typeCause = "";
  TypeCauseIncidentModel? typeCauseModel = null;

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
        title: Text("New Type Cause Of Incident",textAlign: TextAlign.center,
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
                                child: DropdownSearch<TypeCauseIncidentModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Type Cause *",
                                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) => getTypeCause(filter),
                                  onChanged: (data) {
                                    typeCauseModel = data;
                                    selectedCodeType = data?.idTypeCause;
                                    typeCause = data?.typeCause;
                                    debugPrint('type cause: ${typeCause}, code: ${selectedCodeType}');
                                  },
                                  dropdownBuilder: _customDropDownTypeCause,
                                  popupItemBuilder: _customPopupItemBuilderTypeCause,
                                  validator: (u) =>
                                  u == null ? "Type Cause is required " : null,
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
        if(connection == ConnectivityResult.none) {
          int max_id = await LocalIncidentSecuriteService().getMaxNumTypeCauseIncSecRattacher();
          int? id_inc_cause = max_id + 1;
          var model = TypeCauseIncidentModel();
          model.online = 0;
          model.idIncident = widget.numIncident;
          model.idIncidentCause = id_inc_cause;
          model.idTypeCause = selectedCodeType;
          model.typeCause = typeCause;
          //save data
          await LocalIncidentSecuriteService().saveTypeCauseIncSecRattacher(model);
          Get.to(TypeCauseIncidentSecuritePage(numIncident: widget.numIncident,));
        }
        else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile){
          await IncidentSecuriteService().saveTypeCauseByIncident({
            "idIncident": widget.numIncident,
            "idCause": selectedCodeType
          }).then((resp) async {
            ShowSnackBar.snackBar("Successfully", "Type Cause added", Colors.green);
            //Get.back();
            Get.to(TypeCauseIncidentSecuritePage(numIncident: widget.numIncident,));
            await ApiControllersCall().getTypeCauseIncidentSecRattacher();
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

  Future<List<TypeCauseIncidentModel>> getTypeCause(filter) async {
    try {
      List<TypeCauseIncidentModel> _typeList = await List<TypeCauseIncidentModel>.empty(growable: true);
      List<TypeCauseIncidentModel> _typeFilter = await List<TypeCauseIncidentModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await LocalIncidentSecuriteService().readTypeCauseIncSecARattacher(widget.numIncident);
        response.forEach((data){
          var model = TypeCauseIncidentModel();
          model.idTypeCause = data['idTypeCause'];
          model.typeCause = data['typeCause'];
          _typeList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        await IncidentSecuriteService().getTypeCauseIncSecARattacher(widget.numIncident, matricule).then((resp) async {
          resp.forEach((data) async {
            var model = TypeCauseIncidentModel();
            model.idTypeCause = data['id_cause'];
            model.typeCause = data['cause'];
            _typeList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      _typeFilter = _typeList.where((u) {
        var query = u.typeCause!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _typeFilter;

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  Widget _customDropDownTypeCause(BuildContext context, TypeCauseIncidentModel? item) {
    if (item == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item.typeCause}'),
        ),
      );
    }
  }
  Widget _customPopupItemBuilderTypeCause(
      BuildContext context,TypeCauseIncidentModel item, bool isSelected) {
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
        title: Text(item.typeCause ?? ''),
      ),
    );
  }
}
