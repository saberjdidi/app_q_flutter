import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/task_controller.dart';
import '../../Models/task_model.dart';
import '../../Utils/custom_colors.dart';
import '../../Utils/message.dart';
import '../../Validators/validator.dart';

class EditTask extends StatefulWidget {
  //final id;
  TaskModel taskModel;

   EditTask({Key? key, required this.taskModel}) : super(key: key);

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {

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
  void initState() {
    // TODO: implement initState
    fullNameController.text = widget.taskModel.fullName!;
    emailController.text = widget.taskModel.email!;
    jobController.text = widget.taskModel.job!;
    super.initState();
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
          child: Text("Edit Task"),
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
                            updateTask();
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

  Future updateTask() async {
    if(_dataValidation()){
      if (_addItemFormKey.currentState!.validate()) {
        try {
          setState(() {
            _isProcessing = true;
          });

          saveTaskData(
              widget.taskModel.id,
              fullNameController.text.trim(),
              emailController.text.trim(),
              jobController.text.trim()
          );

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
  void saveTaskData(String? id, String fullName, String email, String job) {
    Get.find<TaskController>().updateTask(
        id,
        {'fullName': fullName, 'email': email, 'job': job}
    );
    Get.back();
  }
}