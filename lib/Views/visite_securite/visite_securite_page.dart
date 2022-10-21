import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Views/incident_securite/type_cause/type_cause_incident_securite_page.dart';
import '../../Controllers/incident_securite/incident_securite_controller.dart';
import '../../Controllers/visite_securite/visite_securite_controller.dart';
import '../../Services/visite_securite/local_visite_securite_service.dart';
import '../../Utils/custom_colors.dart';
import '../../Widgets/loading_widget.dart';
import '../../Widgets/navigation_drawer_widget.dart';
import '../../Widgets/refresh_widget.dart';
import 'action/action_visite_securite_page.dart';
import 'checklist/checklist_critere_page.dart';
import 'equipe/equipe_visite_sec_page.dart';
import 'new_visite_sec_page.dart';
import 'new_visite_securite.dart';
import 'visite_securite_widget.dart';

class VisiteSecuritePage extends GetView<VisiteSecuriteController> {
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
          'Visite Securite',
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
          if (controller.listVisiteSecurite.length > 0) {
            return RefreshWidget(
              keyRefresh: keyRefresh,
              onRefresh: () async {
                /* await Future.delayed(Duration(seconds: 1),
                                (){
                              controller.lstTask;
                            }
                        ); */
                Get.find<VisiteSecuriteController>().listVisiteSecurite.clear();
                Get.find<VisiteSecuriteController>().getData();
              },
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 3.0),
                shrinkWrap: true,
                itemCount: controller.listVisiteSecurite.length,
                itemBuilder: (BuildContext context, int index) {
                 // return Text('${controller.listVisiteSecurite[index].designation}');
                   return Container(
                        margin: EdgeInsets.only(left: 5, right: 5, bottom: 0.0),
                        child: Slidable(
                          //direction: Axis.vertical,
                          key: const ValueKey(0),
                          child: VisiteSecuriteWidget(model: controller.listVisiteSecurite[index]),
                          // The start action pane is the one at the left or the top side.
                          startActionPane: ActionPane(
                            // A motion is a widget used to control how the pane animates.
                            motion: const ScrollMotion(),

                            // All actions are defined in the children parameter.
                            children: [

                              SlidableAction(
                                onPressed: (context) {
                                  Get.to(CheckListCriterePage(numFiche: controller.listVisiteSecurite[index].id));
                                },
                                backgroundColor: Color(0xFF21B7CA),
                                foregroundColor: Colors.white,
                                //icon: Icons.list,
                                label: 'Check-\nlist',
                              ),

                              SlidableAction(
                                onPressed: (context) {
                                  Get.to(EquipeVisiteSecPage(numFiche: controller.listVisiteSecurite[index].id));
                                },
                                backgroundColor: Color(0xFF6D28CD),
                                foregroundColor: Colors.white,
                                //icon: Icons.list,
                                label: 'Equipe',
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
                                  Get.to(ActionVisiteSecuritePage(numFiche: controller.listVisiteSecurite[index].id));
                                },
                                backgroundColor: Color(0xFF0DBD90),
                                foregroundColor: Colors.white,
                                icon: Icons.library_books,
                                label: 'Actions',
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
              label: '${'new'.tr} Visite Securite',
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              onTap: () async {
              //await LocalVisiteSecuriteService().deleteTableEquipeVisiteSecurite();
              // await Get.to(()=>NewVisiteSecuritePage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                await Get.to(()=>NewVisiteSecuPage());
              }
          ),
          SpeedDialChild(
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              child: Icon(Icons.search, color: Colors.blue, size: 32),
              label: '${'search'.tr} Visite Securite',
              onTap: (){
              showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: const Center(
                        child: Text('Search Visite Securite', style: TextStyle(
                            fontWeight: FontWeight.w500, fontFamily: "Signatra",
                            color: Color(0xFF0769D2), fontSize: 30.0
                        ),),
                      ),
                      titlePadding: EdgeInsets.only(top: 2.0),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Card(
                              color: Color(0xffa5e1f5),
                              child: new ListTile(
                                leading: new Icon(Icons.search),
                                title: new TextField(
                                    controller: controller.searchNumero,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    decoration: new InputDecoration(
                                        hintText: 'Numero',
                                        border: InputBorder.none),
                                    ),
                                trailing: new IconButton(
                                  icon: Icon(Icons.cancel),
                                  onPressed: () {
                                    controller.searchNumero.clear();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 5.0,),
                            Card(
                              color: Color(0xffa5e1f5),
                              child: new ListTile(
                                leading: new Icon(Icons.search),
                                title: new TextField(
                                  controller: controller.searchUnite,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: new InputDecoration(
                                      hintText: 'Unite',
                                      border: InputBorder.none),
                                ),
                                trailing: new IconButton(
                                  icon: Icon(Icons.cancel),
                                  onPressed: () {
                                    controller.searchUnite.clear();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 5.0,),
                            Card(
                              color: Color(0xffa5e1f5),
                              child: new ListTile(
                                leading: new Icon(Icons.search),
                                title: new TextField(
                                  controller: controller.searchZone,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: new InputDecoration(
                                      hintText: 'Zone',
                                      border: InputBorder.none),
                                ),
                                trailing: new IconButton(
                                  icon: Icon(Icons.cancel),
                                  onPressed: () {
                                    controller.searchZone.clear();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      contentPadding: EdgeInsets.only(right: 5.0, left: 5.0),
                      actionsPadding: EdgeInsets.all(1.0),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Get.find<VisiteSecuriteController>().listVisiteSecurite.clear();
                            Get.find<VisiteSecuriteController>().searchData();
                            Get.back();
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
                            padding: const EdgeInsets.all(5.0),
                            child: Text('Search',
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
                    );
                  },
                );
              }
          ),
          SpeedDialChild(
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              child: Icon(Icons.sync, color: Colors.blue, size: 32),
              label: 'Synchronisation',
              onTap: (){
                controller.syncVisiteSecuriteToWebService();
              }
          )
        ],
      ),
    );
  }

}