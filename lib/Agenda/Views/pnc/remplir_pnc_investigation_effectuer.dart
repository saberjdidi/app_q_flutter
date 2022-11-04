import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as mypath;
import 'package:qualipro_flutter/Agenda/Views/pnc/pnc_suivre_page.dart';
import 'package:qualipro_flutter/Models/action/action_realisation_model.dart';

import '../../../Controllers/api_controllers_call.dart';
import '../../../Models/employe_model.dart';
import '../../../Models/pnc/pnc_a_traiter_model.dart';
import '../../../Models/pnc/pnc_details_model.dart';
import '../../../Models/pnc/pnc_suivre_model.dart';
import '../../../Services/action/action_service.dart';
import '../../../Services/action/local_action_service.dart';
import '../../../Services/pnc/pnc_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/message.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Utils/utility_file.dart';
import '../../../Validators/validator.dart';
import 'pnc_investigation_approuver_page.dart';
import 'pnc_investigation_effectuer_page.dart';
import 'pnc_traiter_page.dart';

class RemplirPNCInvestigationEffectuer extends StatefulWidget {
  final nnc;

  RemplirPNCInvestigationEffectuer({Key? key, required this.nnc}) : super(key: key);

  @override
  State<RemplirPNCInvestigationEffectuer> createState() => _RemplirPNCInvestigationEffectuerState();
}

class _RemplirPNCInvestigationEffectuerState extends State<RemplirPNCInvestigationEffectuer> {
  final _addItemFormKey = GlobalKey<FormState>();
  PNCService pncService = PNCService();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();

  DateTime dateTime = DateTime.now();
  TextEditingController  dateInvestigationController = TextEditingController();
  TextEditingController  dateApprobationController = TextEditingController();
  TextEditingController  rapportController = TextEditingController();
  TextEditingController  investigationController = TextEditingController();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  String? responsableInvestigationMatricule = "";
  String? responsableInvestigationNomPrenom = "";
  String? approbateurInvestigationMatricule = "";
  String? approbateurInvestigationNomPrenom = "";

  bool checkInvestigationApprouve = false;
  int investigationApprouve = 0;

  //file picker
  File? file;
  String base64File = '';

  //PNCDetailsModel? pncDetailsModel;
  Future getPNCByNNC() async {
    try {
      await PNCService().getPNCByNNC(widget.nnc).then((resp) async {
        setState(() {
          var model = PNCDetailsModel();
          model.respInvestig = resp['resp_investig'];
          model.approbInvestig = resp['approb_investig'];
          model.respInvestigNom = resp['resp_investigNom'];
          model.approbInvestigNom = resp['approb_investigNom'];
          model.rapportInvestig = resp['rapport_investig'];
          model.txtInvestig = resp['txt_investig'];
          model.delaiInvestig = resp['delai_investig'];

          DateTime dateInvestg = DateTime.parse(model.delaiInvestig.toString());
          dateInvestigationController.text = DateFormat('yyyy-MM-dd').format(dateInvestg);
          rapportController.text = model.rapportInvestig.toString();
          investigationController.text = model.txtInvestig.toString();
          responsableInvestigationMatricule = model.respInvestig;
          print('responsableInvestigationMatricule : $responsableInvestigationMatricule');
          approbateurInvestigationMatricule = model.approbInvestig;
          print('approbateurInvestigationMatricule : $approbateurInvestigationMatricule');
          responsableInvestigationNomPrenom = model.respInvestigNom;
          approbateurInvestigationNomPrenom = model.approbInvestigNom;
        });
      }
          , onError: (err) {
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          });

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    }
  }

  @override
  void initState(){
    getPNCByNNC();
    dateApprobationController.text = DateFormat('yyyy-MM-dd').format(dateTime);

    super.initState();
  }

  selectedDate(BuildContext context) async {
    var datePicker = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2050)
    );
    if(datePicker != null){
      setState(() {
        dateTime = datePicker;
        //dateApprobationController.text = DateFormat('yyyy-MM-dd').format(datePicker);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? mypath.basename(file!.path) : '';
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: TextButton(
          onPressed: (){
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: Colors.white,),
        ),
        title: Center(
          child: Text("Investigation Effectuer N° ${widget.nnc}"),
        ),
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
                            SizedBox(height: 10.0,),
                            Visibility(
                              visible: true,
                              child: TextFormField(
                                enabled: false,
                                controller: dateInvestigationController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (value) => Validator.validateField(
                                    value: value!
                                ),
                                onChanged: (value){
                                  selectedDate(context);
                                },
                                decoration: InputDecoration(
                                    labelText: 'Delai Investigation',
                                    hintText: 'date',
                                    labelStyle: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                    ),
                                    suffixIcon: InkWell(
                                      onTap: (){
                                        selectedDate(context);
                                      },
                                      child: Icon(Icons.calendar_today),
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                    )
                                ),
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                                visible: true,
                                child: TextFormField(
                                  controller: rapportController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Rapport investigation *',
                                    hintText: 'Rapport',
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
                                    ),
                                  ),
                                  validator: (value) => Validator.validateField(
                                      value: value!
                                  ),
                                  style: TextStyle(fontSize: 14.0),
                                  minLines: 2,
                                  maxLines: 5,
                                )
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                                visible: true,
                                child: TextFormField(
                                  enabled: false,
                                  controller: investigationController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Investigation',
                                    hintText: 'Investigation',
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
                                    ),
                                  ),
                                  style: TextStyle(fontSize: 14.0),
                                  minLines: 2,
                                  maxLines: 5,
                                )
                            ),
                            SizedBox(height: 10.0,),
                            DropdownSearch<EmployeModel>(
                              enabled: false,
                              showSelectedItems: true,
                              showClearButton: true,
                              showSearchBox: true,
                              isFilteredOnline: true,
                              compareFn: (i, s) => i?.isEqual(s) ?? false,
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Responsable investigation *",
                                contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                border: OutlineInputBorder(),
                              ),
                              onFind: (String? filter) => getResponsableInvestigation(filter),
                              onChanged: (data) {
                                responsableInvestigationMatricule = data?.mat;
                                print('responsableInvestigation: ${data?.nompre}, mat: ${responsableInvestigationMatricule}');
                              },
                              dropdownBuilder: customDropDownResponsableInvestigation,
                              popupItemBuilder: customPopupItemBuilderResponsableInvestigation,
                            ),
                            SizedBox(height: 10.0,),
                            DropdownSearch<EmployeModel>(
                              enabled: false,
                              showSelectedItems: true,
                              showClearButton: true,
                              showSearchBox: true,
                              isFilteredOnline: true,
                              compareFn: (i, s) => i?.isEqual(s) ?? false,
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Approbateur investigation *",
                                contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                border: OutlineInputBorder(),
                              ),
                              onFind: (String? filter) => getResponsableInvestigation(filter),
                              onChanged: (data) {
                                approbateurInvestigationMatricule = data?.mat;
                                print('approbateurInvestigation: ${data?.nompre}, mat: ${approbateurInvestigationMatricule}');
                              },
                              dropdownBuilder: customDropDownApprobateurInvestigation,
                              popupItemBuilder: customPopupItemBuilderApprobateurInvestigation,
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                              visible: true,
                              child: CheckboxListTile(
                                title: const Text('Investigation approuvée'),
                                value: false,
                                onChanged: null,
                                activeColor: Colors.blue,
                                //secondary: const Icon(Icons.hourglass_empty),
                              ),
                            ),

                            SizedBox(height: 7.0,),
                            ElevatedButton.icon(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  backgroundColor:
                                  MaterialStateProperty.all(Color(0xFF11D0B9)),
                                  padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                                ),
                                icon: Icon(Icons.attach_file),
                                label: Text(
                                  'Select File',
                                  style: TextStyle(fontSize: 14, color: Colors.white),
                                ),
                                onPressed: () {
                                  selectFile();
                                }
                            ),
                            Text(fileName,
                            style: TextStyle(fontSize: 16, color: Colors.black),),
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
                            : ElevatedButton(
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
        //if(file == null) return;

        await pncService.remplirPNCInvestigation({
          "nc": widget.nnc,
          "avec_investig": 1,
          "resp_investig": responsableInvestigationMatricule,
          "delai_investig": dateInvestigationController.text,
          "txt_investig": investigationController.text,
          "rapport_investig": rapportController.text,
          "piece_investig": base64File,
          "approb_investig": approbateurInvestigationMatricule,
          "investig_approuve": investigationApprouve,
          "date_approb_investig": dateApprobationController.text
        }).then((resp) async {
          ShowSnackBar.snackBar("Successfully", "Investigation Effectuer added", Colors.green);
          //Get.back();
          Get.to(PNCInvestigationEffectuerPage());
          await ApiControllersCall().getPNCInvestigationEffectuer();
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

  Future selectFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);
      if(result==null) return;
      final path = result.files.single.path!;

      setState(() {
        file = File(path);
       base64File = UtilityFile.base64String(file!.readAsBytesSync());
       print('base64 file : $base64File');
      });
      final file_data = result.files.first;
     /* print('Name : ${file_data.name}');
      print('Bytes : ${file_data.bytes}');
      print('Path : ${file_data.path}');
      print('Extension : ${file_data.extension}'); */
    } catch (error) {
      debugPrint(error.toString());
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(child: Text(
          error.toString(),
          style: TextStyle(fontStyle: FontStyle.italic),
        ),),
        title: 'Error',
        btnCancel: Text('Cancel'),
        btnOkOnPress: () {
          Navigator.of(context).pop();
        },
      )..show();
    }
  }

  //getResponsableInvestigation
  Future<List<EmployeModel>> getResponsableInvestigation(filter) async {
    try {
      List<EmployeModel> employeList = await List<EmployeModel>.empty(growable: true);
      List<EmployeModel>employeFilter = await List<EmployeModel>.empty(growable: true);
      var response = await LocalActionService().readEmploye();
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
  Widget customDropDownResponsableInvestigation(BuildContext context, EmployeModel? item) {
    if (item == null) {
      return Container(
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text('${responsableInvestigationNomPrenom}', style: TextStyle(color: Colors.black)),
          )
      );
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
  Widget customPopupItemBuilderResponsableInvestigation(
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
  //approbateur investigation
  Widget customDropDownApprobateurInvestigation(BuildContext context, EmployeModel? item) {
    if (item == null) {
      return Container(
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text('${approbateurInvestigationNomPrenom}', style: TextStyle(color: Colors.black)),
          )
      );
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
  Widget customPopupItemBuilderApprobateurInvestigation(
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
