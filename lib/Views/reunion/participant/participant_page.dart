import 'dart:ffi';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:qualipro_flutter/Models/employe_model.dart';
import 'package:qualipro_flutter/Models/product_model.dart';
import 'package:qualipro_flutter/Services/pnc/pnc_service.dart';
import 'package:qualipro_flutter/Services/reunion/local_reunion_service.dart';
import 'package:qualipro_flutter/Services/reunion/reunion_service.dart';
import 'package:qualipro_flutter/Widgets/refresh_widget.dart';
import 'package:readmore/readmore.dart';
import '../../../Controllers/api_controllers_call.dart';
import '../../../Controllers/pnc/pnc_controller.dart';
import '../../../Controllers/reunion/reunion_controller.dart';
import '../../../Models/reunion/participant_reunion_model.dart';
import '../../../Models/type_cause_model.dart';
import '../../../Route/app_route.dart';
import '../../../Services/action/action_service.dart';
import '../../../Services/action/local_action_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import 'new_participant.dart';

class ParticipantPage extends StatefulWidget {
  final nReunion;

 const ParticipantPage({Key? key, required this.nReunion}) : super(key: key);

  @override
  State<ParticipantPage> createState() => _ParticipantPageState();
}

class _ParticipantPageState extends State<ParticipantPage> {
  
  final matricule = SharedPreference.getMatricule();
  final keyRefresh = GlobalKey<RefreshIndicatorState>();
  List<ParticipantReunionModel> listParticipant = List<ParticipantReunionModel>.empty(growable: true);
  bool isVisibleDeleteButton = true;


  @override
  void initState() {
    super.initState();
    getParticipants();
  }
  void getParticipants() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var response = await LocalReunionService().readParticipantByReunion(widget.nReunion);
        response.forEach((data){
          setState(() {
            var model = ParticipantReunionModel();
            model.online = data['online'];
            model.nompre = data['nompre'];
            model.mat = data['mat'];
            model.aparticipe = data['aparticipe'];
            model.comment = data['comment'];
            model.confirm = data['confirm'];
            model.nReunion = data['nReunion'];
            listParticipant.add(model);
            isVisibleDeleteButton = false;
          });
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {

        String? language = SharedPreference.getLangue() ?? "";
        //rest api
       // await ReunionService().getParticipant(widget.nReunion)
          await ReunionService().getParticipationByReunionAndLangue(widget.nReunion, language)
            .then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = ParticipantReunionModel();
              model.online = 1;
              model.nompre = data['nompre'];
              model.mat = data['mat'];
              model.aparticipe = data['aparticipe'];
              model.comment = data['comment'];
              model.confirm = data['confirm'];
              model.id = data['id'];
              model.intExt = data['int_ext'];
              //model.nReunion = data['nReunion'];
              listParticipant.add(model);
              isVisibleDeleteButton = true;
            });
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    }
    finally {
      //isDataProcessing(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color lightPrimary = Colors.white;
    const Color darkPrimary = Colors.white;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                lightPrimary,
                darkPrimary,
              ])),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: RaisedButton(
            onPressed: (){
              //Get.back();
              Get.find<ReunionController>().listReunion.clear();
              Get.find<ReunionController>().getReunion();
              Get.toNamed(AppRoute.reunion);
              //Get.offAllNamed(AppRoute.reunion);
            },
            elevation: 0.0,
            child: Icon(Icons.arrow_back, color: Colors.blue,),
            color: Colors.white,
          ),
          title: Text(
            'Participants of Reunion N°${widget.nReunion}',
            style: TextStyle(color: Colors.black, fontSize: 17),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listParticipant.isNotEmpty ?
            Container(
              child: RefreshWidget(
                keyRefresh: keyRefresh,
                onRefresh: () async {
                  listParticipant.clear();
                  getParticipants();
                },
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final status = listParticipant[index].confirm;
                    String? message = "";
                    switch(status){
                      case 0:
                        message = "Attente confirmation";
                        break;
                      case 1:
                        message = "OUI";
                        break;
                      case -1:
                        message = "NON";
                        break;
                      default:
                        message = "";
                    }
                    return Card(
                        color: Color(0xFFE9EAEE),
                        child: ListTile(
                          leading: Text(
                            '${listParticipant[index].mat}',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue),
                          ),
                          title: Text(
                            '${listParticipant[index].nompre}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyLarge,
                                children: [
                                  /* WidgetSpan(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                            child: Icon(Icons.amp_stories),
                                          ),
                                        ), */
                                  TextSpan(text: '${message}'),

                                  //TextSpan(text: '${action.declencheur}'),
                                ],

                              ),
                            ),
                          ),
                          trailing: Visibility(
                            visible: isVisibleDeleteButton,
                            child: InkWell(
                                onTap: (){
                                  deleteParticipant(context, listParticipant[index].mat, listParticipant[index].intExt, listParticipant[index].id);
                                },
                                child: Icon(Icons.delete, color: Colors.red,)
                            ),
                          ),
                        ),
                      );
                  },
                  itemCount: listParticipant.length,
                  //itemCount: actionsList.length + 1,
                ),
              ),
            )
                : Center(child: Text('empty_list'.tr, style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Brand-Bold'
            )),)
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
             Get.to(NewParticipant(nReunion: widget.nReunion));
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 32,),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
//delete participant
  deleteParticipant(context, mat, intExt, id){
    AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(child: Text(
          'Are you sure to delete this item ${mat}',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),),
        title: 'Delete',
        btnOk: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.blue,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          onPressed: () async {

            await ReunionService().deleteParticipantById(widget.nReunion, mat, intExt, id).then((resp) async {
              //ShowSnackBar.snackBar("Successfully", "Participant Deleted", Colors.green);
              listParticipant.removeWhere((element) => element.mat == mat && element.intExt == intExt && element.id == id);
              setState(() {});
              await ApiControllersCall().getParticipantsReunion();
              Navigator.of(context).pop();
            }, onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
              print('Error : ${err.toString()}');
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Ok',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
        closeIcon: Icon(Icons.close, color: Colors.red,),
        btnCancel: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.redAccent,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
        )
    )..show();
  }
}