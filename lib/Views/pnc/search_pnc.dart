import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Controllers/pnc/pnc_controller.dart';
import 'package:qualipro_flutter/Views/pnc/pnc_widget.dart';
import '../../Models/pnc/pnc_model.dart';
import '../../Services/action/local_action_service.dart';
import 'add_products_pnc/products_pnc_page.dart';
import 'type_cause/types_causes_pnc_page.dart';

class SearchPNCDelegate extends SearchDelegate<PNCModel> {

  LocalActionService service = LocalActionService();
  List<PNCModel> pncList = <PNCModel>[];

  SearchPNCDelegate(this.pncList);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
      onPressed: () {
        close(context, PNCModel());
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    return GetBuilder<PNCController>(builder: (controller){

      controller.filterPNC = pncList.where((action) {
        return action.nnc.toString().toLowerCase().contains(query.trim().toLowerCase())
            || action.nc!.toLowerCase().contains(query.trim().toLowerCase());
      }).toList();

      return controller.filterPNC.isNotEmpty ?
      ListView.builder(
        itemCount: controller.filterPNC.length,
        itemBuilder: (context, index) {

          return Container(
            color: Colors.white,
            margin: EdgeInsets.only(left: 3, right: 3, bottom: 0.0),
            child: Slidable(
              // Specify a key if the Slidable is dismissible.
              key: const ValueKey(0),
              // The child of the Slidable is what the user sees when the
              // component is not dragged.
              child: PNCWidget(pncModel: controller.filterPNC[index], color: Colors.blueGrey,),
              // The start action pane is the one at the left or the top side.
              startActionPane: ActionPane(
                // A motion is a widget used to control how the pane animates.
                motion: const ScrollMotion(),

                // All actions are defined in the children parameter.
                children: [
                  // A SlidableAction can have an icon and/or a label.
                  SlidableAction(
                    onPressed: (context) {
                      Get.to(TypesCausesPNCPage(nnc: controller.filterPNC[index].nnc));
                    },
                    backgroundColor: Color(0xFF2639E8),
                    foregroundColor: Colors.white,
                    icon: Icons.remove_red_eye,
                    label: 'Types Causes',
                  ),
                 /* SlidableAction(
                    onPressed: (context) {
                      Get.to(ProductsPNCPage(nnc: controller.filterPNC[index].nnc));
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
                      Get.to(ProductsPNCPage(nnc: controller.filterPNC[index].nnc));
                    },
                    backgroundColor: Color(0xFF0DBD90),
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'product'.tr,
                  ),
                ],
              ),
            ),
          );
        },
      )
          : const Center(child: Text('Data not found', style: TextStyle(
          fontSize: 20.0,
          fontFamily: 'Brand-Bold'
      ),),);
    });
  }


}