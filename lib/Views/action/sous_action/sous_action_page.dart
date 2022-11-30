import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Controllers/action/action_controller.dart';
import '../../../Controllers/action/sous_action_controller.dart';
import '../../../Route/app_route.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Widgets/empty_list_widget.dart';
import '../../../Widgets/loading_widget.dart';
import '../../../Widgets/refresh_widget.dart';
import '../action_page.dart';
import 'intervenant_page.dart';
import 'new_sous_action.dart';
import 'sous_action_widget.dart';

class SousActionPage extends GetView<SousActionController> {
  @override
  Widget build(BuildContext context) {
    final keyRefresh = GlobalKey<RefreshIndicatorState>();
    //controller.id_action.value = Get.arguments[0];
    const Color lightPrimary = Colors.blue;
    const Color darkPrimary = Colors.white;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: TextButton(
          onPressed: () {
            Get.back();
            Get.find<ActionController>().listAction.clear();
            Get.find<ActionController>().getActions();
            //Get.offAllNamed(AppRoute.pnc);
            //Get.toNamed(AppRoute.action);
            //Get.offAll(ActionPage());
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.blue,
          ),
        ),
        title: Text(
          'Action N° ${controller.id_action}',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: (darkPrimary),
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
          if (controller.listSousAction.length > 0) {
            return Container(
              padding: EdgeInsets.only(left: 1, right: 1, top: 2, bottom: 2),
              child: RefreshWidget(
                keyRefresh: keyRefresh,
                onRefresh: () async {
                  /* await Future.delayed(Duration(seconds: 1),
                                (){
                              controller.lstTask;
                            }
                        ); */
                  Get.find<SousActionController>().listSousAction.clear();
                  Get.find<SousActionController>().getSousActions();
                },
                child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: controller.listSousAction.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(left: 5, right: 5, bottom: 0.0),
                      child: Slidable(
                        key: const ValueKey(0),
                        //child: Text('${controller.listSousAction[index].nSousAct}'),
                        child: SousActionWidget(
                          sousActionModel: controller.listSousAction[index],
                          color: Colors.blueGrey,
                        ),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),

                          // All actions are defined in the children parameter.
                          children: [
                            // A SlidableAction can have an icon and/or a label.
                            /*  SlidableAction(
                                onPressed: (context) {
                                  Get.to(IntervenantsPage(idAction: controller.listSousAction[index].nAct, idSousAction: controller.listSousAction[index].nSousAct,));
                                },
                                backgroundColor: Color(0xFF21B7CA),
                                foregroundColor: Colors.white,
                                icon: Icons.remove_red_eye,
                                label: 'Intervenants',
                              ), */
                          ],
                        ),
                        // The end action pane is the one at the right or the bottom side.
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            Visibility(
                              visible: controller.isVisibleIntervenat.value,
                              child: SlidableAction(
                                // An action can be bigger than the others.
                                flex: 2,
                                onPressed: (context) {
                                  //print('id action:${controller.listSousAction[index].nAct}');
                                  // print('id sous action:${controller.listSousAction[index].nSousAct}');
                                  Get.to(IntervenantsPage(
                                    idAction:
                                        controller.listSousAction[index].nAct,
                                    idSousAction: controller
                                        .listSousAction[index].nSousAct,
                                  ));
                                },
                                backgroundColor: Color(0xFF0DBD90),
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: 'Intervenants',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            return EmptyListWidget();
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
              label: '${'new'.tr} Sous Action',
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              onTap: () {
                Get.to(() => NewSousActionPage(),
                    transition: Transition.zoom,
                    duration: Duration(milliseconds: 500),
                    arguments: {"id_action": controller.id_action});
                //Get.to(()=>AddAction(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
              }),
          /*  SpeedDialChild(
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              child: Icon(Icons.search, color: Colors.blue, size: 32),
              label: 'Search Sous Action',
              onTap: (){
               /* showSearch(
                  context: context,
                  delegate: SearchActionDelegate(controller.listAction),
                ); */
              }
          ), */
          SpeedDialChild(
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              child: Icon(Icons.sync, color: Colors.blue, size: 32),
              label:
                  'Synchronisation', //controller.countSousActionLocal ==0 ? 'No data exist to synchronized' : 'Synchronisation',
              onTap: () {
                controller.syncSousActionToWebService();
              })
        ],
      ),
    );
  }
}
