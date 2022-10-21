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
import 'pnc_approbation_finale_page.dart';
import 'pnc_traiter_page.dart';

class RemplirPNCApprobationFinale extends StatefulWidget {
  final nnc;

  RemplirPNCApprobationFinale({Key? key, required this.nnc}) : super(key: key);

  @override
  State<RemplirPNCApprobationFinale> createState() => _RemplirPNCApprobationFinaleState();
}

class _RemplirPNCApprobationFinaleState extends State<RemplirPNCApprobationFinale> {
  final _addItemFormKey = GlobalKey<FormState>();
  PNCService pncService = PNCService();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();
  final nom_prenom = SharedPreference.getNomPrenom();

  DateTime dateTime = DateTime.now();
  TextEditingController  nomPrenomController = TextEditingController();
  TextEditingController  dateApprobationController = TextEditingController();
  TextEditingController  rapportController = TextEditingController();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  var approuve = 0;
  onChangeApprouve(var value){
    setState(() {
      approuve = value;
      print('nc approuve : ${approuve}');
    });
  }


  @override
  void initState(){
    nomPrenomController.text = nom_prenom.toString();
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
        dateApprobationController.text = DateFormat('dd/MM/yyyy').format(datePicker);
      });
    }
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
        title: Center(
          child: Text("Approbation Finale of N.C N° ${widget.nnc}", style: TextStyle(
            fontSize: 16
          ),),
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
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Radio(value: 0,
                                      groupValue: approuve,
                                      onChanged: (value){
                                        onChangeApprouve(value);
                                        dateApprobationController.text="";
                                        rapportController.text = "";
                                      },
                                      activeColor: Colors.blue,
                                      fillColor: MaterialStateProperty.all(Colors.blue),),
                                    const Text("N.C. non approuvée", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio(value: 1,
                                      groupValue: approuve,
                                      onChanged: (value){
                                        onChangeApprouve(value);
                                        dateApprobationController.text = DateFormat('dd/MM/yyyy').format(dateTime);
                                      },
                                      activeColor: Colors.blue,
                                      fillColor: MaterialStateProperty.all(Colors.blue),),
                                    const Text("N.C. approuvée", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 10.0,),
                            TextFormField(
                              enabled: false,
                              controller: nomPrenomController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value) => Validator.validateField(
                                  value: value!
                              ),
                              decoration: InputDecoration(
                                labelText: 'Responsable approbation',
                                hintText: 'responsable approbation',
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
                            SizedBox(height: 10.0,),
                            Visibility(
                              visible: true,
                              child: TextFormField(
                                enabled: approuve == 0 ? false : true,
                                controller: dateApprobationController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                onChanged: (value){
                                  selectedDate(context);
                                },
                                decoration: InputDecoration(
                                    labelText: 'Date Approbation',
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
                                  enabled: approuve == 0 ? false : true,
                                  controller: rapportController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Rapport Approbation',
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
                                  style: TextStyle(fontSize: 14.0),
                                  minLines: 2,
                                  maxLines: 5,
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

        await pncService.validerApprobationFinale({
          "nnc": widget.nnc,
          "approb": approuve, /// 1 ou 0
          "mat": matricule.toString(),
          "date_apr": dateApprobationController.text,
          "commentaire": rapportController.text
        }).then((resp) async {
          ShowSnackBar.snackBar("Successfully", "Approbation Finale success", Colors.green);
          //Get.back();
          Get.to(PNCApprobationFinalePage());
          await ApiControllersCall().getPNCApprobationFinale();
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

}
