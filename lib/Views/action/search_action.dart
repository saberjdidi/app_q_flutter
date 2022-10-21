import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Views/action/actions_screen.dart';

import '../../Controllers/action/action_controller.dart';
import '../../Models/action/action_model.dart';
import '../../Services/action/local_action_service.dart';
import 'action_widget.dart';
import 'products_action_page.dart';
import 'sous_action/sous_action_page.dart';
import 'types_causes_action_page.dart';

class SearchActionDelegate extends SearchDelegate<ActionModel> {

  LocalActionService service = LocalActionService();
  bool isLoading = true;
  List<ActionModel> actionsList = <ActionModel>[];
  List<ActionModel> _filter = [];

  SearchActionDelegate(this.actionsList);

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
        close(context, ActionModel());
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
   /* _filter = actionsList.where((action) {
      return action.nAct.toString().toLowerCase().contains(query.trim().toLowerCase())
          || action.act!.toLowerCase().contains(query.trim().toLowerCase())
          || action.typeAct!.toLowerCase().contains(query.trim().toLowerCase());
    }).toList(); */

    return GetBuilder<ActionController>(builder: (controller){

      controller.filterAction = actionsList.where((action) {
        return action.nAct.toString().toLowerCase().contains(query.trim().toLowerCase())
            || action.act!.toLowerCase().contains(query.trim().toLowerCase())
            || action.typeAct!.toLowerCase().contains(query.trim().toLowerCase());
      }).toList();

      return controller.filterAction.isNotEmpty ?
      ListView.builder(
        itemCount: controller.filterAction.length,
        itemBuilder: (context, index) {
          String action = controller.filterAction[index].act!;
          String type = controller.filterAction[index].typeAct!;
          return Container(
            color: Colors.white,
            margin: EdgeInsets.only(left: 3, right: 3, bottom: 0.0),
            child: Slidable(
              // Specify a key if the Slidable is dismissible.
              key: const ValueKey(0),
              // The child of the Slidable is what the user sees when the
              // component is not dragged.
              child: ActionWidget(actionModel: controller.filterAction[index], color: Colors.blueGrey,),
              // The start action pane is the one at the left or the top side.
              startActionPane: ActionPane(
                // A motion is a widget used to control how the pane animates.
                motion: const ScrollMotion(),

                // All actions are defined in the children parameter.
                children: [
                  // A SlidableAction can have an icon and/or a label.
                  SlidableAction(
                    onPressed: (context) {
                      Get.to(TypesCausesActionPage(idAction: controller.filterAction[index].nAct));
                    },
                    backgroundColor: Color(0xFF2639E8),
                    foregroundColor: Colors.white,
                    icon: Icons.remove_red_eye,
                    label: 'Types \nCauses',
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      Get.to(ProductsActionPage(idAction: controller.filterAction[index].nAct));
                    },
                    backgroundColor: Color(0xFF21B7CA),
                    foregroundColor: Colors.white,
                    icon: Icons.list,
                    label: 'Products',
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
                      Get.to(SousActionPage(), arguments: {
                        "id_action" : controller.filterAction[index].nAct
                      });
                    },
                    backgroundColor: Color(0xFF0DBD90),
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Sous Action',
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