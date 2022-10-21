import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Utils/custom_colors.dart';
import '../../../../Utils/shared_preference.dart';
import '../../../../Utils/snack_bar.dart';
import '../../../Controllers/api_controllers_call.dart';
import '../../../Models/incident_securite/cause_typique_model.dart';
import '../../../Models/type_consequence_model.dart';
import '../../../Services/incident_securite/incident_securite_service.dart';
import '../../../Services/incident_securite/local_incident_securite_service.dart';
import '../../../Validators/validator.dart';
import 'cause_typique_incident_securite_page.dart';

class NewCauseTypiqueIncidentSecurite extends StatefulWidget {
  final numIncident;

  const NewCauseTypiqueIncidentSecurite({Key? key, required this.numIncident}) : super(key: key);

  @override
  State<NewCauseTypiqueIncidentSecurite> createState() => _NewCauseTypiqueIncidentSecuriteState();
}

class _NewCauseTypiqueIncidentSecuriteState extends State<NewCauseTypiqueIncidentSecurite> {
  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();

  TextEditingController  ncController = TextEditingController();

  int? selectedCodeCauseTypique = 0;
  String? causeTypique = '';
  CauseTypiqueModel? causeTypiqueModel = null;

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
        leading: RaisedButton(
          onPressed: (){
            Get.back();
          },
          elevation: 0.0,
          child: Icon(Icons.arrow_back, color: Colors.white,),
          color: Colors.blue,
        ),
        title: Text("New Cause Typique Of Incident",textAlign: TextAlign.center,
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
                                child: DropdownSearch<CauseTypiqueModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Cause Typique *",
                                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) => getCauseTypique(filter),
                                  onChanged: (data) {
                                    causeTypiqueModel = data;
                                    selectedCodeCauseTypique = data?.idCauseTypique;
                                    causeTypique = data?.causeTypique;
                                    print('cause typique : $causeTypique, code: ${selectedCodeCauseTypique}');
                                  },
                                  dropdownBuilder: _customDropDownCauseTypique,
                                  popupItemBuilder: _customPopupItemBuilderCauseTypique,
                                  validator: (u) =>
                                  u == null ? "Cause Typique is required " : null,
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
          int max_id = await LocalIncidentSecuriteService().getMaxNumCauseTypiqueIncSecRattacher();
          int? id_inc_cause_typique = max_id + 1;
          var model = CauseTypiqueModel();
          model.online = 0;
          model.idIncidentCauseTypique = id_inc_cause_typique;
          model.causeTypique = causeTypique;
          model.idCauseTypique = selectedCodeCauseTypique;
          model.idIncident = widget.numIncident;
          //save table in db local
          await LocalIncidentSecuriteService().saveCauseTypiqueIncSecRattacher(model);
          Get.to(CauseTypiqueIncidentSecuritePage(numIncident: widget.numIncident,));
        }
        else if(connection == ConnectivityResult.mobile || connection == ConnectivityResult.wifi){
          await IncidentSecuriteService().saveCauseTypiqueByIncident({
            "idIncident": widget.numIncident,
            "idCauseTypique": selectedCodeCauseTypique
          }).then((resp) async {
            ShowSnackBar.snackBar("Successfully", "Cause Typique added", Colors.green);
            //Get.back();
            Get.to(CauseTypiqueIncidentSecuritePage(numIncident: widget.numIncident,));
            await ApiControllersCall().getCauseTypiqueIncSecRattacher();
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
  
  Future<List<CauseTypiqueModel>> getCauseTypique(filter) async {
    try {
      List<CauseTypiqueModel> _typeList = await List<CauseTypiqueModel>.empty(growable: true);
      List<CauseTypiqueModel> _typeFilter = await List<CauseTypiqueModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await LocalIncidentSecuriteService().readCauseTypiqueIncSecARattacherByIncident(widget.numIncident);
        response.forEach((data){
          var model = CauseTypiqueModel();
          model.idIncidentCauseTypique = data['idTypeCause'];
          model.causeTypique = data['causeTypique'];
          model.idCauseTypique = data['idCauseTypique'];
          _typeList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        await IncidentSecuriteService().getCauseTypiqueIncSecARattacher(widget.numIncident, matricule).then((resp) async {
          resp.forEach((data) async {
            var model = CauseTypiqueModel();
            model.idIncidentCauseTypique = data['id_TypeCause'];
            model.causeTypique = data['causeTypique'];
            model.idCauseTypique = data['id_CauseTypique'];
            _typeList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      _typeFilter = _typeList.where((u) {
        var query = u.causeTypique!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _typeFilter;

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  Widget _customDropDownCauseTypique(BuildContext context, CauseTypiqueModel? item) {
    if (item == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item.causeTypique}'),
        ),
      );
    }
  }
  Widget _customPopupItemBuilderCauseTypique(
      BuildContext context,CauseTypiqueModel item, bool isSelected) {
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
        title: Text(item.causeTypique ?? ''),
      ),
    );
  }
}
