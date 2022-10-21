import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Models/employe_model.dart';
import '../../../../Services/action/action_service.dart';
import '../../../../Services/action/local_action_service.dart';
import '../../../../Utils/custom_colors.dart';
import '../../../../Utils/shared_preference.dart';
import '../../../../Utils/snack_bar.dart';
import '../../../Models/type_cause_model.dart';
import '../../../Route/app_route.dart';
import '../../../Services/api_services_call.dart';
import '../../../Services/pnc/pnc_service.dart';
import '../../../Validators/validator.dart';
import 'types_causes_pnc_page.dart';

class NewTypeCausePNC extends StatefulWidget {
  final nnc;

  const NewTypeCausePNC({Key? key, required this.nnc}) : super(key: key);

  @override
  State<NewTypeCausePNC> createState() => _NewTypeCausePNCState();
}

class _NewTypeCausePNCState extends State<NewTypeCausePNC> {
  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();

  TextEditingController  ncController = TextEditingController();

  int? selectedTypeCode = 0;
  TypeCauseModel? typeCauseModel = null;

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  @override
  void initState(){
    ncController.text = widget.nnc.toString();
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
        title: Text("New Type Cause Of N.C",textAlign: TextAlign.center,),
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
                                  labelText: 'PNC N°',
                                  hintText: 'n.c',
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
                                child: DropdownSearch<TypeCauseModel>(
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
                                  onFind: (String? filter) => getTypesCause(filter),
                                  onChanged: (data) {
                                    typeCauseModel = data;
                                    selectedTypeCode = data?.codetypecause;
                                    print('type cause: ${typeCauseModel?.typecause}, code: ${selectedTypeCode}');
                                  },
                                  dropdownBuilder: _customDropDownTypeCause,
                                  popupItemBuilder: _customPopupItemBuilderTypeCause,
                                  validator: (u) =>
                                  u == null ? "Type cause is required " : null,
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
        await PNCService().addTypeCauseByNNC({
          "nnc": widget.nnc,
          "codetypecause": selectedTypeCode
        }).then((resp) async {
          ShowSnackBar.snackBar("Successfully", "Type Cause added", Colors.green);
          //Get.back();
          Get.to(TypesCausesPNCPage(nnc: widget.nnc,));
        }, onError: (err) {
          setState(()  {
            _isProcessing = false;
          });
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
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
  //types cause
  Future<List<TypeCauseModel>> getTypesCause(filter) async {
    try {
      List<TypeCauseModel> typeCauseList = await List<TypeCauseModel>.empty(growable: true);
      List<TypeCauseModel> typeCauseFilter = await <TypeCauseModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await LocalActionService().readTypeCauseAction();
        response.forEach((data){
          var model = TypeCauseModel();
          model.codetypecause = data['codetypecause'];
          model.typecause = data['typecause'];
          typeCauseList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getTypeCauseAction({
          "act": "",
          "typeC": "",
          "mat": matricule.toString(),
          "prov": ""
        }).then((resp) async {
          resp.forEach((data) async {
            var model = TypeCauseModel();
            model.codetypecause = data['codetypecause'];
            model.typecause = data['typecause'];
            typeCauseList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }

      typeCauseFilter = typeCauseList.where((u) {
        var name = u.codetypecause.toString().toLowerCase();
        var description = u.typecause!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return typeCauseFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  Widget _customDropDownTypeCause(BuildContext context, TypeCauseModel? item) {
    if (item == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item.typecause}'),
          //subtitle: Text('${item?.codetypecause.toString()}'),
        ),
      );
    }
  }
  Widget _customPopupItemBuilderTypeCause(
      BuildContext context, TypeCauseModel item, bool isSelected) {
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
        title: Text(item.typecause ?? ''),
        //subtitle: Text(item.codetypecause.toString() ?? ''),
      ),
    );
  }
}
