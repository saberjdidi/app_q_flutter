import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Controllers/pnc/pnc_controller.dart';
import 'package:qualipro_flutter/Views/pnc/pnc_widget.dart';
import '../../Widgets/build_shimmer.dart';
import '../../Widgets/refresh_widget.dart';
import 'add_products_pnc/products_pnc_page.dart';
import 'new_pnc.dart';
import 'search_pnc.dart';
import 'type_cause/types_causes_pnc_page.dart';

class PNCPage extends GetView<PNCController> {
  @override
  Widget build(BuildContext context) {
    final keyRefresh = GlobalKey<RefreshIndicatorState>();
    const Color lightPrimary = Colors.white;
    const Color darkPrimary = Colors.white;
    return Scaffold(
      /* drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'PNC',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: (lightPrimary),
        elevation: 0,
        actions: [],
        iconTheme: IconThemeData(color: CustomColors.blueAccent),
      ),*/
      body: Obx(() {
        if (controller.isDataProcessing.value == true) {
          return ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index){
                return BuildShimmer();
              }
          );
         /* return Center(
            child: LoadingView(),
          ); */
        } else {
          if (controller.listPNC.length > 0) {
            return RefreshWidget(
              keyRefresh: keyRefresh,
              onRefresh: () async {
                Get.find<PNCController>().listPNC.clear();
                Get.find<PNCController>().getPNC();
              },
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 3.0),
                shrinkWrap: true,
                itemCount: controller.listPNC.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(left: 5, right: 5, bottom: 0.0),
                    child: Slidable(
                      key: const ValueKey(0),
                      child: PNCWidget(pncModel: controller.listPNC[index], color: Colors.blueGrey,),
                      // The start action pane is the one at the left or the top side.
                      startActionPane: ActionPane(
                        // A motion is a widget used to control how the pane animates.
                        motion: const ScrollMotion(),

                        // All actions are defined in the children parameter.
                        children: [
                          // A SlidableAction can have an icon and/or a label.
                          SlidableAction(
                            onPressed: (context) {
                              Get.to(TypesCausesPNCPage(nnc: controller.listPNC[index].nnc));
                            },
                            backgroundColor: Color(0xFF2639E8),
                            foregroundColor: Colors.white,
                            icon: Icons.remove_red_eye,
                            label: 'Types Causes',
                          ),
                         /* SlidableAction(
                            onPressed: (context) {
                              Get.to(ProductsPNCPage(nnc: controller.listPNC[index].nnc));
                            },
                            backgroundColor: Color(0xFF21B7CA),
                            foregroundColor: Colors.white,
                            icon: Icons.list,
                            label: 'product'.tr,
                          ), */
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
                              Get.to(ProductsPNCPage(nnc: controller.listPNC[index].nnc));
                            },
                            backgroundColor: Color(0xFF0DBD90),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'product'.tr,
                          ),
                          /* SlidableAction(
                                onPressed: (context){print('edit');},
                                backgroundColor: Color(0xFF0392CF),
                                foregroundColor: Colors.white,
                                icon: Icons.save,
                                label: 'Save',
                              ), */
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
      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: 30.0),
        child: SpeedDial(
          buttonSize: Size(45, 45),
          animatedIcon: AnimatedIcons.menu_close,
          spacing: 10.0,
          closeManually: false,
          backgroundColor: Colors.blue,
          spaceBetweenChildren: 15.0,
          children: [
            SpeedDialChild(
                child: Icon(Icons.add, color: Colors.blue, size: 32),
                label: '${'new'.tr} PNC',
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                onTap: (){
                  Get.to(()=>NewPNCPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                }
            ),
            SpeedDialChild(
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                child: Icon(Icons.search, color: Colors.blue, size: 32),
                label: '${'search'.tr} PNC',
                onTap: (){
                  showSearch(
                    context: context,
                    delegate: SearchPNCDelegate(controller.listPNC),
                  );
                }
            ),
            SpeedDialChild(
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                child: Icon(Icons.sync, color: Colors.blue, size: 32),
                label: 'Synchronisation',
                onTap: (){
                  controller.syncPNCToWebService();
                }
            )
          ],
        ),
      ),
    );
  }

}