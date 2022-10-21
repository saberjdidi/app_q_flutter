import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Controllers/pnc/pnc_controller.dart';
import 'package:qualipro_flutter/Views/pnc/pnc_widget.dart';
import '../../Controllers/action/action_controller.dart';
import '../../Controllers/reunion/reunion_controller.dart';
import '../../Utils/custom_colors.dart';
import '../../Widgets/loading_widget.dart';
import '../../Widgets/navigation_drawer_widget.dart';
import '../../Widgets/refresh_widget.dart';
import 'new_reunion.dart';
import 'participant/participant_page.dart';
import 'reunion_widget.dart';
import 'search_reunion.dart';

class ReunionPage extends GetView<ReunionController> {
  @override
  Widget build(BuildContext context) {
    final keyRefresh = GlobalKey<RefreshIndicatorState>();
    const Color lightPrimary = Colors.white;
    const Color darkPrimary = Colors.white;
    return Scaffold(
       drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Reunion',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: (lightPrimary),
        elevation: 0,
        actions: [],
        iconTheme: IconThemeData(color: CustomColors.blueAccent),
      ),
      body: Obx(() {
        if (controller.isDataProcessing.value == true) {
          return Center(
            child: LoadingView(),
          );
        } else {
          if (controller.listReunion.length > 0) {
            return RefreshWidget(
              keyRefresh: keyRefresh,
              onRefresh: () async {
                /* await Future.delayed(Duration(seconds: 1),
                                (){
                              controller.lstTask;
                            }
                        ); */
                Get.find<ReunionController>().listReunion.clear();
                Get.find<ReunionController>().getReunion();
              },
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: controller.listReunion.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(left: 5, right: 5, bottom: 0.0),
                    child: Slidable(
                      key: const ValueKey(0),
                      child: ReunionWidget(model: controller.listReunion[index], color: Colors.blueGrey,),
                      // The start action pane is the one at the left or the top side.
                      startActionPane: ActionPane(
                        // A motion is a widget used to control how the pane animates.
                        motion: const ScrollMotion(),

                        // All actions are defined in the children parameter.
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              Get.to(ParticipantPage(nReunion: controller.listReunion[index].nReunion));
                            },
                            backgroundColor: Color(0xFF21B7CA),
                            foregroundColor: Colors.white,
                            icon: Icons.list,
                            label: 'Participants',
                          ),
                        ],
                      ),
                      // The end action pane is the one at the right or the bottom side.
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            // An action can be bigger than the others.
                            flex: 2,
                            onPressed: (context) {
                              Get.to(ParticipantPage(nReunion: controller.listReunion[index].nReunion));
                            },
                            backgroundColor: Color(0xFF0DBD90),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Participants',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(
              child: Text(
                'empty_list'.tr,
                style: TextStyle(fontSize: 25),
              ),
            );
          }
        }
      }),
      floatingActionButton: SpeedDial(
        buttonSize: Size(50, 50),
        animatedIcon: AnimatedIcons.menu_close,
        spacing: 10.0,
        closeManually: false,
        backgroundColor: Colors.blue,
        spaceBetweenChildren: 15.0,
        children: [
          SpeedDialChild(
              child: Icon(Icons.add, color: Colors.blue, size: 32),
              label: '${'new'.tr} Reunion',
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              onTap: (){
                Get.to(()=>NewReunionPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
              }
          ),
          SpeedDialChild(
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              child: Icon(Icons.search, color: Colors.blue, size: 32),
              label: '${'search'.tr} Reunion',
              onTap: (){
                 showSearch(
                    context: context,
                    delegate: SearchReunionDelegate(controller.listReunion),
                  );
              }
          ),
          SpeedDialChild(
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              child: Icon(Icons.sync, color: Colors.blue, size: 32),
              label: 'Synchronisation',
              onTap: (){
                controller.syncReunionToWebService();
              }
          )
        ],
      ),
    );
  }

}