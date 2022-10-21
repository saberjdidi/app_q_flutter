import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Views/task/task_screen.dart';
import '../../Controllers/task_controller.dart';
import '../../Models/task_model.dart';
import '../../Utils/custom_colors.dart';
import '../../Widgets/button_widget.dart';
import 'edit_task.dart';
import 'task_details_arguments.dart';

class SearchTaskDelegate extends SearchDelegate<TaskModel> {

  bool isLoading = true;
  List<TaskModel> actionsList = <TaskModel>[];
  //List<TaskModel> _filter = [];

  SearchTaskDelegate(this.actionsList);

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
        close(context, TaskModel());
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
    final leftIcon = Container(
      margin: const EdgeInsets.only(bottom: 10),
      color: CustomColors.blueAccent.withOpacity(0.5),
      child: Icon(
        Icons.edit,
        color: Colors.white,
      ),
      alignment: Alignment.centerLeft,
    );
    return
         GetBuilder<TaskController>(builder: (controller){

           controller.filterTask = actionsList.where((action) {
             return action.fullName!.toLowerCase().contains(query.trim().toLowerCase())
                 || action.job!.toLowerCase().contains(query.trim().toLowerCase());
           }).toList();

          return controller.filterTask.isNotEmpty ?
            ListView.builder(
             itemCount: controller.filterTask.length,
             itemBuilder: (context, index) {
               String fullName = controller.filterTask[index].fullName!;
               String job = controller.filterTask[index].job!;
               return Card(
                 color: Colors.white,
                 child: Slidable(
                   // Specify a key if the Slidable is dismissible.
                   key: const ValueKey(0),
                   // The child of the Slidable is what the user sees when the
                   // component is not dragged.
                   child: ListTile(
                     textColor: Colors.black87,
                     //title: Text("${actionsList[index]['name']}"),
                     title: Text(fullName,
                         style: TextStyle(
                             fontWeight: FontWeight.bold,
                             fontFamily: "Brand-Regular",
                             fontSize: 16.0)),
                     subtitle: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(job, style:
                         TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontFamily: "Brand-Bold"),),
                         //Text(designation),
                       ],
                     ),
                   ),
                   // The start action pane is the one at the left or the top side.
                   startActionPane: ActionPane(
                     // A motion is a widget used to control how the pane animates.
                     motion: const ScrollMotion(),

                     // All actions are defined in the children parameter.
                     children: [
                       // A SlidableAction can have an icon and/or a label.
                       SlidableAction(
                         onPressed: (context) {
                           deleteData(context, controller.filterTask[index].id);
                         },
                         backgroundColor: Color(0xFFFE4A49),
                         foregroundColor: Colors.white,
                         icon: Icons.delete,
                         label: 'Delete',
                       ),
                       SlidableAction(
                         onPressed: (context) {
                           Get.to(TaskDetailsArguments(), arguments: [
                             controller.filterTask[index].fullName,
                             controller.filterTask[index].job
                           ]);
                         },
                         backgroundColor: Color(0xFF21B7CA),
                         foregroundColor: Colors.white,
                         icon: Icons.remove_red_eye,
                         label: 'Details',
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
                           print('edit');
                           Get.off(()=>EditTask(
                             taskModel: controller.filterTask[index],
                           ));
                         },
                         backgroundColor: Color(0xFF7BC043),
                         foregroundColor: Colors.white,
                         icon: Icons.edit,
                         label: 'Edit',
                       ),
                       SlidableAction(
                         onPressed: (context){print('edit');},
                         backgroundColor: Color(0xFF0392CF),
                         foregroundColor: Colors.white,
                         icon: Icons.save,
                         label: 'Save',
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
          onPressed: () {
            Get.find<TaskController>().deleteTask(position);
            //Get.find<TaskController>().filterTask.removeAt(position);
            Get.offAll(TaskScreen());
            //Navigator.of(context).pop();
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