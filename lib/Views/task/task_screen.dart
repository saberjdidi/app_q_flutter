import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import '../../Controllers/network_controller.dart';
import '../../Controllers/task_controller.dart';
import '../../Utils/custom_colors.dart';
import '../../Widgets/button_widget.dart';
import '../../Widgets/loading_widget.dart';
import '../../Widgets/refresh_widget.dart';
import '../dashboard_screen.dart';
import 'add_task.dart';
import 'edit_task.dart';
import 'search_task.dart';
import 'task_widget.dart';

class TaskScreen extends GetView<TaskController> {
  @override
  Widget build(BuildContext context) {
    final keyRefresh = GlobalKey<RefreshIndicatorState>();
    final leftEditIcon = Container(
      margin: const EdgeInsets.only(bottom: 10),
      color: CustomColors.blueAccent.withOpacity(0.5),
      child: Icon(
        Icons.edit,
        color: Colors.white,
      ),
      alignment: Alignment.centerLeft,
    );

    final rightIcon = Container(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.lightBlueAccent,
      child: Icon(
        Icons.remove_red_eye,
        color: Colors.white,
      ),
      alignment: Alignment.centerRight,
    );
    const Color lightPrimary = Colors.white;
    const Color darkPrimary = Colors.white;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: TextButton(
          onPressed: (){
            //Navigator.pushNamedAndRemoveUntil(context, DashboardScreen.idScreen, (route) => false);
            Get.offAll(DashboardScreen());
          },
          child: Icon(Icons.arrow_back, color: Colors.blue,),
        ),
        title: Text(
          'Tasks',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: (lightPrimary),
        elevation: 0,
        actions: [],
      ),
      body: Obx(() {
        if (controller.isDataProcessing.value == true) {
          return Center(
            child: LoadingView(),
          );
        } else {
          if (controller.lstTask.length > 0) {
            return Container(
              padding: EdgeInsets.only(left: 1, right: 1, top: 2, bottom: 2),
              child: Expanded(
                    child: RefreshWidget(
                      keyRefresh: keyRefresh,
                      onRefresh: () async {
                       /* await Future.delayed(Duration(seconds: 1),
                                (){
                              controller.lstTask;
                            }
                        ); */
                        //controller.getTask();
                      },
                      child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: controller.lstTask.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.only(left: 5, right: 5, bottom: 0.0),
                            child: Dismissible(
                              background: leftEditIcon,
                              secondaryBackground: rightIcon,
                              onDismissed: (DismissDirection direction){
                                print('show');
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
                                                      deleteData(context, controller.lstTask[index].id);
                                                      //deleteData(context, controller.lstTask[index]["_id"]);
                                                    },
                                                    child: ButtonWidget(backgroundColor: Colors.red, text: "Delete", textColor: Colors.white)
                                                ),
                                                SizedBox(height: 20.0,),
                                                GestureDetector(
                                                    onTap: (){
                                                      Get.off(()=>EditTask(
                                                        taskModel: controller.lstTask[index],
                                                        /*  id: controller.lstTask[index].id,
                                                      fullName: controller.lstTask[index].fullName,
                                                      email: controller.lstTask[index].email,
                                                      job: controller.lstTask[index].job,*/
                                                      ));
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
                              child: TaskWidget(
                                //fullName: controller.participantList[index].fullName,
                                //fullName: controller.lstTask[index]["fullName"],
                                fullName: controller.lstTask[index].fullName,
                                job: controller.lstTask[index].job,
                                color: Colors.blueGrey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
            );
          } else {
            return Center(
              child: Text(
                'Data not found',
                style: TextStyle(fontSize: 25),
              ),
            );
          }
        }
      }),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        spacing: 10.0,
        closeManually: false,
        backgroundColor: Colors.blue,
        spaceBetweenChildren: 15.0,
        children: [
          SpeedDialChild(
              child: Icon(Icons.add, color: Colors.blue, size: 32),
              label: 'New Task',
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              onTap: (){
                ///Navigator.push(context, MaterialPageRoute(builder: (context) => AddParticipant()));
                Get.to(()=>AddTask(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
              }
          ),
          SpeedDialChild(
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              child: Icon(Icons.search, color: Colors.blue, size: 32),
              label: 'Search Task',
              onTap: (){
                showSearch(
                  context: context,
                  delegate: SearchTaskDelegate(controller.lstTask),
                );
              }
          ),
          SpeedDialChild(
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              child: Icon(Icons.sync, color: Colors.blue, size: 32),
              label: 'Synchronisation',
              onTap: (){
                controller.syncTaskToWebService();
              }
          )
        ],
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
            await controller.deleteTask(position);
            //Get.back();
            Navigator.of(context).pop();
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