import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Agenda/Views/pnc/pnc_suivre_page.dart';
import 'package:qualipro_flutter/Models/action/action_realisation_model.dart';
import 'package:qualipro_flutter/Models/reunion/reunion_model.dart';
import 'package:qualipro_flutter/Services/reunion/reunion_service.dart';

import '../../../Controllers/api_controllers_call.dart';
import '../../../Models/employe_model.dart';
import '../../../Models/pnc/pnc_a_traiter_model.dart';
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
import 'reunion_informer_page.dart';

class ConfirmerReunionInformer extends StatefulWidget {
  ReunionModel model;

  ConfirmerReunionInformer({Key? key, required this.model}) : super(key: key);

  @override
  State<ConfirmerReunionInformer> createState() => _ConfirmerReunionInformerState();
}

class _ConfirmerReunionInformerState extends State<ConfirmerReunionInformer> {
  final _addItemFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  ReunionService reunionService = ReunionService();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();
  final nom_prenom = SharedPreference.getNomPrenom();

  DateTime dateTime = DateTime.now();
  TextEditingController  typeController = TextEditingController();
  TextEditingController  datePrevueController = TextEditingController();
  TextEditingController  heureDebutController = TextEditingController();
  TextEditingController  lieuController = TextEditingController();
  //TextEditingController  ordreJourController = TextEditingController();
  bool checkReunion = false;


  @override
  void initState(){
    typeController.text = widget.model.typeReunion.toString();
    datePrevueController.text = widget.model.datePrev.toString();
    heureDebutController.text = widget.model.heureDeb.toString();
    lieuController.text = widget.model.lieu.toString();
    //ordreJourController.text = widget.model.ordreJour.toString();
    super.initState();
  }

  selectedDate(BuildContext context) async {
    var datePicker = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime.now()
    );
    if(datePicker != null){
      setState(() {
        dateTime = datePicker;
        //dateClotureController.text = DateFormat('dd-MM-yyyy').format(datePicker);
      });
    }
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
        title: Center(
          child: Text("Reunion N°${widget.model.nReunion}"),
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
                            SizedBox(height: 8.0,),
                            TextFormField(
                              enabled: false,
                              controller: typeController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value) => Validator.validateField(
                                  value: value!
                              ),
                              decoration: InputDecoration(
                                labelText: 'Type Reunion',
                                hintText: 'Type Reunion',
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
                            ),
                          /*  SizedBox(height: 10.0,),
                            TextFormField(
                              enabled: false,
                              controller: ordreJourController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value) => Validator.validateField(
                                  value: value!
                              ),
                              decoration: InputDecoration(
                                labelText: 'Ordre Jour',
                                hintText: 'Ordre Jour',
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
                            ),*/
                            SizedBox(height: 10.0,),
                            Visibility(
                              visible: true,
                              child: TextFormField(
                                enabled: false,
                                controller: datePrevueController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (value) => Validator.validateField(
                                    value: value!
                                ),
                                onChanged: (value){
                                  selectedDate(context);
                                },
                                decoration: InputDecoration(
                                    labelText: 'Date Prevue',
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
                                enabled: false,
                                controller: heureDebutController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    labelText: 'Heure Debut',
                                    hintText: 'heure',
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
                                      child: Icon(Icons.timer),
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
                                  enabled: false,
                                  controller: lieuController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Lieu',
                                    hintText: 'lieu',
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
                            CheckboxListTile(
                              title: const Text('Je consulte cette reunion'),
                              value: checkReunion,
                              onChanged: (bool? value) {
                                setState(() async {
                                  checkReunion = value!;
                                  if(checkReunion == true){
                                    if(_addItemFormKey.currentState!.validate()){
                                      try {
                                        setState(()  {
                                          _isProcessing = true;
                                        });
                                          await reunionService.validerReunionInfo({
                                            "nReunion": widget.model.nReunion,
                                            "mat": matricule.toString()
                                        }).then((resp) async {
                                          ShowSnackBar.snackBar("Successfully", "Reunion success", Colors.green);
                                          //Get.back();
                                          Get.to(ReunionInformerPage());
                                          await ApiControllersCall().getReunionInformer();
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
                                });
                              },
                              activeColor: Colors.blue,
                              //secondary: const Icon(Icons.hourglass_empty),
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


}
