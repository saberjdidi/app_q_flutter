
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/participant_controller.dart';
import '../../Services/participant_service.dart';
import '../../Utils/custom_colors.dart';
import '../../Utils/message.dart';
import '../../Validators/validator.dart';
import 'participants_stateless_screen.dart';

class AddParticipant extends StatefulWidget {
  const AddParticipant({Key? key}) : super(key: key);

  @override
  State<AddParticipant> createState() => _AddParticipantState();
}

class _AddParticipantState extends State<AddParticipant> {

  ParticipantService service = ParticipantService();
  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  TextEditingController  fullNameController = TextEditingController();
  TextEditingController  emailController = TextEditingController();
  TextEditingController  jobController = TextEditingController();

  bool _dataValidation(){
    if(fullNameController.text.trim()==''){
      //Get.snackbar("fullName", "FullName is required");
      Message.taskErrorOrWarning("FullName", "FullName is required");
      return false;
    }
    if(emailController.text.trim()==''){
      Message.taskErrorOrWarning("Email", "email is required");
      return false;
    }
    if(jobController.text.trim()==''){
      Message.taskErrorOrWarning("Job", "job is required");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: Icon(Icons.arrow_back,
            color: Colors.white,),
        ),
        title: Center(
          child: Text("Ajouter Participant"),
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
                          controller: fullNameController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) => Validator.validateField(
                              value: value!
                          ),
                          decoration: InputDecoration(
                            labelText: 'FullName',
                            hintText: 'fullName',
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
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) => Validator.validateField(
                              value: value!
                          ),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'email',
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
                        TextFormField(
                          controller: jobController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) => Validator.validateField(
                              value: value!
                          ),
                          decoration: InputDecoration(
                            labelText: 'Job',
                            hintText: 'job',
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
                            saveParticipant();
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
                      ]
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future saveParticipant() async {
    if(_dataValidation()){
      if (_addItemFormKey.currentState!.validate()) {
        try {
          setState(() {
            _isProcessing = true;
          });
          Get.find<ParticipantController>().postData(
              fullNameController.text.trim(),
              emailController.text.trim(),
              jobController.text.trim());

          AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.SUCCES,
            body: Center(child: Text(
              'data save successfully',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),),
            title: 'data saved',
            btnCancel: Text('Cancel'),
            btnOkOnPress: () {
              Get.to(()=> ParticipantsScreen(), transition: Transition.circularReveal);
            },
          )..show();
          //use service
          /*  Response response = await service.postData({
            "fullName": fullNameController.text.trim(),
            "email": emailController.text.trim(),
            "job": jobController.text.trim()
          });
          if(response.statusCode == 200){
            //update();
            AwesomeDialog(
              context: context,
              animType: AnimType.SCALE,
              dialogType: DialogType.SUCCES,
              body: Center(child: Text(
                'data save successfully',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),),
              title: 'data saved',
              btnCancel: Text('Cancel'),
              btnOkOnPress: () {
                Get.to(()=> AllParticipants(), transition: Transition.circularReveal);
              },
            )..show();
          }
          else {
            print('An error has occured');
          } */


          setState(() {
            _isProcessing = false;
          });
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
  }
}