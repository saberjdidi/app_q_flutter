import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Agenda/Views/pnc/pnc_suivre_page.dart';
import '../../../Controllers/api_controllers_call.dart';
import '../../../Models/incident_environnement/incident_env_agenda_model.dart';
import '../../../Models/pnc/pnc_suivre_model.dart';
import '../../../Services/incident_environnement/incident_environnement_service.dart';
import '../../../Services/pnc/pnc_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/message.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Utils/utility_file.dart';
import '../../../Validators/validator.dart';
import 'incident_env_a_cloturer_page.dart';
import 'incident_env_a_traiter_page.dart';

class ValiderIncidentEnvTraiter extends StatefulWidget {
  IncidentEnvAgendaModel model;

  ValiderIncidentEnvTraiter({Key? key, required this.model}) : super(key: key);

  @override
  State<ValiderIncidentEnvTraiter> createState() => _ValiderIncidentEnvTraiterState();
}

class _ValiderIncidentEnvTraiterState extends State<ValiderIncidentEnvTraiter> {
  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();
  final nom_prenom = SharedPreference.getNomPrenom();

  DateTime dateTime = DateTime.now();
  DateTime dateTimeSaisie = DateTime.now();
  TextEditingController  nomPrenomController = TextEditingController();
  TextEditingController  dateSaisieController = TextEditingController();
  TextEditingController  dateTraitementController = TextEditingController();
  TextEditingController  rapportController = TextEditingController();
  TextEditingController  coutController = TextEditingController();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  var traite = 0;
  bool checkTraite = false;
  onChangeCloture(var value){
    setState(() {
      traite = value;
      if(traite == 1){
        checkTraite = true;
      }
      else {
        checkTraite = false;
        rapportController.clear();
        coutController.clear();
        dateTraitementController.text = DateFormat('dd/MM/yyyy').format(dateTimeSaisie);
      }
      print('incident traite : ${traite}');
    });
  }

  bool _dataValidation() {

    if (rapportController.text.trim() == '' && traite == 1) {
      Message.taskErrorOrWarning("Warning", "Rapport is required");
      return false;
    }
    return true;
  }

  @override
  void initState(){
    nomPrenomController.text = nom_prenom.toString();
    dateSaisieController.text = DateFormat('dd/MM/yyyy').format(dateTimeSaisie);
    dateTraitementController.text = DateFormat('dd/MM/yyyy').format(dateTime);
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
        dateTraitementController.text = DateFormat('dd/MM/yyyy').format(datePicker);
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
          child: Text("Incident a Traiter N° ${widget.model.nIncident}"),
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
                                      groupValue: traite,
                                      onChanged: (value){
                                        onChangeCloture(value);
                                      },
                                      activeColor: Colors.blue,
                                      fillColor: MaterialStateProperty.all(Colors.blue),),
                                    const Text("Incident non traite", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)
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
                                    const Text("Incident traite", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)
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
                              decoration: InputDecoration(
                                labelText: 'Responsable de Traitement',
                                hintText: 'responsable de Traitement',
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
                                enabled: false,
                                controller: dateSaisieController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                onChanged: (value){
                                  selectedDate(context);
                                },
                                decoration: InputDecoration(
                                    labelText: 'Date Saisie',
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
                                enabled: traite == 1 ?true :false,
                                controller: dateTraitementController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (value) => Validator.validateField(
                                    value: value!
                                ),
                                onChanged: (value){
                                  selectedDate(context);
                                },
                                decoration: InputDecoration(
                                    labelText: 'Date de Traitement',
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
                            TextFormField(
                              enabled: traite == 1 ?true :false,
                              controller: coutController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Cout',
                                hintText: 'Cout',
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
                                  enabled: traite == 1 ?true :false,
                                  controller: rapportController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Rapport de Traitement',
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
    if(_dataValidation() && _addItemFormKey.currentState!.validate()){
      try {
        setState(()  {
          _isProcessing = true;
        });

        if(coutController.text.trim() == ''){
          coutController.text = '0';
        }

        await IncidentEnvironnementService().validerIncidentEnvTraiter({
          "nIncident": widget.model.nIncident,
          "traite": traite,
          "dateTraitement": dateTraitementController.text,
          "cout": int.parse(coutController.text),
          "rapportTraitement": rapportController.text
        }).then((resp) async {
          ShowSnackBar.snackBar("Successfully", "Incident Traite", Colors.green);
          //Get.back();
          Get.to(IncidentEnvATraiterPage());
          await ApiControllersCall().getIncidentEnvATraiter();
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
