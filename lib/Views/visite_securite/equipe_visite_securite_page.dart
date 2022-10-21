import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../Models/employe_model.dart';
import '../../../../Models/pnc/traitement_decision_model.dart';
import '../../../../Services/action/local_action_service.dart';
import '../../../../Services/pnc/pnc_service.dart';
import '../../../../Utils/custom_colors.dart';
import '../../../../Utils/shared_preference.dart';
import '../../../../Utils/snack_bar.dart';
import '../../Models/visite_securite/equipe_visite_securite_model.dart';
import '../../Route/app_route.dart';
import '../../Services/visite_securite/local_visite_securite_service.dart';
import 'new_visite_sec_page.dart';
import 'new_visite_securite.dart';


class EquipeVisiteSecuritePage extends StatefulWidget {

  EquipeVisiteSecuritePage({Key? key}) : super(key: key);

  @override
  State<EquipeVisiteSecuritePage> createState() => _EquipeVisiteSecuritePageState();
}

class _EquipeVisiteSecuritePageState extends State<EquipeVisiteSecuritePage> {
  final _addItemFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();
  LocalVisiteSecuriteService localVisiteSecuriteService = LocalVisiteSecuriteService();

  String? employeMatricule = "";
  String? employeNompre = "";

  var traite = 3;
  onChangeCloture(var value){
    setState(() {
      traite = value;
      print('incident traite : ${traite}');
    });
  }

  @override
  void initState(){

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3E5E3),
      key: _globalKey,
     /* appBar: AppBar(
        leading: RaisedButton(
          onPressed: (){
            Get.back();
          },
          elevation: 0.0,
          child: Icon(Icons.arrow_back, color: Colors.white,),
          color: Colors.blue,
        ),
        title: Center(
          child: Text("Equipe Visite Securite"),
        ),
        backgroundColor: Colors.blue,
      ), */
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
                            SizedBox(height: 10.0,),
                            Center(child: Text('Equipe Visite Securité',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),),
                            SizedBox(height: 20.0,),
                            DropdownSearch<EmployeModel>(
                              showSelectedItems: true,
                              showClearButton: true,
                              showSearchBox: true,
                              isFilteredOnline: true,
                              compareFn: (i, s) => i?.isEqual(s) ?? false,
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Employe *",
                                contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                border: OutlineInputBorder(),
                              ),
                              onFind: (String? filter) => getEmploye(filter),
                              onChanged: (data) {
                                employeMatricule = data?.mat;
                                employeNompre = data?.nompre;
                                print('employe: ${employeNompre}, mat: ${employeMatricule}');
                              },
                              dropdownBuilder: customDropDownEmploye,
                              popupItemBuilder: customPopupItemBuilderEmploye,
                              validator: (u) =>
                              u == null ? "Employe is required " : null,
                            ),
                            SizedBox(height: 10.0,),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Radio(value: 3,
                                      groupValue: traite,
                                      onChanged: (value){
                                        onChangeCloture(value);
                                      },
                                      activeColor: Colors.blue,
                                      fillColor: MaterialStateProperty.all(Colors.blue),),
                                    const Text("Responsable Audit", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio(value: 2,
                                      groupValue: traite,
                                      onChanged: (value){
                                        onChangeCloture(value);
                                      },
                                      activeColor: Colors.blue,
                                      fillColor: MaterialStateProperty.all(Colors.blue),),
                                    const Text("Auditeur", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio(value: 1,
                                      groupValue: traite,
                                      onChanged: (value){
                                        onChangeCloture(value);
                                      },
                                      activeColor: Colors.blue,
                                      fillColor: MaterialStateProperty.all(Colors.blue),),
                                    const Text("Observateur", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)
                                  ],
                                )
                              ],
                            ),

                            SizedBox(height: 15.0,),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    Get.back();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      CustomColors.firebaseRedAccent,
                                    ),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text('Cancel',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: CustomColors.firebaseWhite,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
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
                                    padding: const EdgeInsets.all(15.0),
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
             var model = EquipeVisiteSecuriteModel();
             model.affectation = traite;
             model.mat = employeMatricule;
             model.nompre = employeNompre;
             await localVisiteSecuriteService.saveEquipeVisiteSecurite(model);
             //Get.back();
             //ShowSnackBar.snackBar("Success", "Employe Added Successfully", Colors.green);
             Get.to(()=>NewVisiteSecuPage());
            // Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.new_visite_securite, (route) => false);
      }
      catch (ex){
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
    }
  }

  //getEmploye
  Future<List<EmployeModel>> getEmploye(filter) async {
    try {
      List<EmployeModel> employeList = await List<EmployeModel>.empty(growable: true);
      List<EmployeModel>employeFilter = await List<EmployeModel>.empty(growable: true);
      var response = await LocalVisiteSecuriteService().readEmployeEquipeVisiteSecurite();
      //var response = await LocalActionService().readEmploye();
      response.forEach((data){
        var model = EmployeModel();
        model.mat = data['mat'];
        model.nompre = data['nompre'];
        employeList.add(model);
      });
      employeFilter = employeList.where((u) {
        var name = u.mat.toString().toLowerCase();
        var description = u.nompre!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return employeFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  Widget customDropDownEmploye(BuildContext context, EmployeModel? item) {
    if (item == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item.nompre}', style: TextStyle(color: Colors.black)),
        ),
      );
    }
  }
  Widget customPopupItemBuilderEmploye(
      BuildContext context, EmployeModel item, bool isSelected) {
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
        title: Text(item.nompre ?? ''),
        //subtitle: Text(item.mat.toString() ?? ''),
      ),
    );
  }
}
