
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

import '../../Controllers/participant_controller.dart';
import '../../Utils/custom_colors.dart';
import '../../Widgets/button_widget.dart';
import '../../Widgets/loading_widget.dart';
import '../dashboard_screen.dart';
import 'add_participant.dart';
import 'participant_widget.dart';

class ParticipantsScreen extends StatefulWidget {
  const ParticipantsScreen({Key? key}) : super(key: key);

  @override
  State<ParticipantsScreen> createState() => _ParticipantsScreenState();
}

class _ParticipantsScreenState extends State<ParticipantsScreen> {
  @override
  Widget build(BuildContext context) {
    final leftEditIcon = Container(
      margin: const EdgeInsets.only(bottom: 10),
      color: CustomColors.blueAccent.withOpacity(0.5),
      child: Icon(
        Icons.edit,
        color: Colors.white,
      ),
      alignment: Alignment.centerLeft,
    );

    final rightDeleteIcon = Container(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.redAccent,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
      alignment: Alignment.centerRight,
    );

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
              //Navigator.pushNamedAndRemoveUntil(context, DashboardScreen.idScreen, (route) => false);
              Get.offAll(DashboardScreen());
            },
            elevation: 0.0,
            child: Icon(Icons.arrow_back, color: Colors.blue,),
            color: Colors.white,
          ),
          title: Text(
            'Participants',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: GetBuilder<ParticipantController>(builder: (controller){
              return ListView.builder(
                  itemCount: Get.find<ParticipantController>().myData.length,
                  //itemCount: Get.find<ParticipantController>().participantList.length,
                  itemBuilder: (context, index){
                   // if(controller.isloading){
                      return controller.myData.length==0
                          ? const Center(child: Text('Empty List', style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Brand-Bold'
                      )),)
                          :
                      Dismissible(
                        background: leftEditIcon,
                        secondaryBackground: rightDeleteIcon,
                        onDismissed: (DismissDirection direction){
                          print('delete');
                          //deleteData(context, controller.myData[index]['_id']);

                        },
                        confirmDismiss: (DismissDirection direction) async{
                          if(direction == DismissDirection.startToEnd){
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                barrierColor: Colors.transparent,
                                context: context,
                                builder: (_){
                                  return Container(
                                    height: 500,
                                    decoration: const BoxDecoration(
                                        color: const Color(0xff87878e),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        )
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20, right: 20),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                              onTap: (){
                                                deleteData(context, controller.myData[index]["_id"]);
                                              },
                                              child: ButtonWidget(backgroundColor: Colors.red, text: "Delete", textColor: Colors.white)
                                          ),
                                          SizedBox(height: 20.0,),
                                          GestureDetector(
                                              onTap: (){
                                                //Get.off(()=>ViewParticipant(id: controller.myData[index]["_id"].toString()));
                                              },
                                              child: ButtonWidget(backgroundColor: CustomColors.blueAccent, text: "Edit", textColor: Colors.white)
                                          ),
                                          SizedBox(height: 20.0,),
                                          GestureDetector(
                                              onTap: (){
                                                //Get.off(()=>ViewParticipant(id: int.parse(controller.myData[index]["_id"].toString())));
                                              },
                                              child: ButtonWidget(backgroundColor: CustomColors.blueAccent, text: "View", textColor: Colors.white)
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                            return false;
                          }
                          else {
                            return Future.delayed(Duration(seconds: 1), ()=>direction == DismissDirection.endToStart);
                          }
                        },
                        key: ObjectKey(index),
                        child: Container(
                          margin: EdgeInsets.only(left: 10, right: 10, bottom: 0.0),
                          child: ParticipantWidget(
                            //fullName: controller.participantList[index].fullName,
                            fullName: controller.myData[index]["fullName"],
                            job: controller.myData[index]["job"],
                            color: Colors.blueGrey,
                          ),
                        ),
                      );
                   /* }
                    else {
                      return LoadingView();
                    } */
                  }
              );
            })
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          spacing: 10.0,
          closeManually: false,
          backgroundColor: Colors.blue,
          spaceBetweenChildren: 15.0,
          children: [
            SpeedDialChild(
                child: Icon(Icons.add, color: Colors.blue, size: 32),
                label: 'New Participant',
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                onTap: (){
                  ///Navigator.push(context, MaterialPageRoute(builder: (context) => AddParticipant()));
                  Get.to(()=>AddParticipant(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                }
            ),
          ],
        ),
      ),
    );
  }

  deleteData(context, position){
    AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(child: Text(
          'Are you sure to delete this item',
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
            //controller.deleteData(controller.myData[index]["_id"]);
            await Get.find<ParticipantController>().deleteData(position);
            Get.back();
            //Get.off(ParticipantsScreen());
            Navigator.of(context).pop();
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
            //Navigator.of(context).pop();
            Get.back();
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
