import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Models/action/action_model.dart';
import '../Models/task_model.dart';
import '../Services/local_task_service.dart';
import '../Services/task_service.dart';
import '../Utils/snack_bar.dart';
import 'network_controller.dart';

class TaskController extends GetxController {
  var lstTask = List<TaskModel>.empty(growable: true).obs;
  //var lstTask = List<dynamic>.empty(growable: true).obs;
  var filterTask = List<TaskModel>.empty(growable: true);

  var isDataProcessing = false.obs;
  // To Save Task
  var isProcessing = false.obs;

  LocalTaskService localTaskService = LocalTaskService();
  //final NetworkController _networkController = Get.find<NetworkController>();

  @override
  void onInit() async {
    super.onInit();
    //check connectivity
   /* print('connection status ${_networkController.connectionStatus.value}');
    if(_networkController.connectionStatus.value == 1) {
      showSnackBar("Connection", "Mode Online", Colors.green);
    }
    else if(_networkController.connectionStatus.value == 2) {
      showSnackBar("Mobile Connection", "Mode Offline", Colors.green);
    }
    else if(_networkController.connectionStatus.value == 0) {
      showSnackBar("No Connection", "Mode Offline", Colors.green);
    } */

    // Fetch Data
    getTask();
  }

  // Fetch Data
  void getTask() async {
    try {
      isDataProcessing(true);
      //check connection internet
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none){
        Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //get local data
       var response = await localTaskService.readTask();
      response.forEach((data){
        var model = TaskModel();
        model.id = data['_id'];
        model.fullName = data['fullName'];
        model.email = data['email'];
        model.job = data['job'];
        model.createdAt = data['createdAt'];
        print('get fullname ${model.fullName}');
        lstTask.add(model);
        //isDataProcessing(false);
      });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await TaskService().getTask().then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            var model = TaskModel();
            model.id = data['_id'];
            model.fullName = data['fullName'];
            model.email = data['email'];
            model.job = data['job'];
            model.createdAt = data['createdAt'];
            lstTask.add(model);

            //delete db local
           await localTaskService.deleteAllTask();
            //save data in local db
           await localTaskService.saveTask(model);
            print('Inserting task : ${model.fullName} ');
          });

          //lstTask.addAll(resp);
          print('get data');
        }
            , onError: (err) {
              isDataProcessing(false);
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }

    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    }
    finally {
      isDataProcessing(false);
    }
  }

  // Refresh List
   refreshList() async {
    getTask();
  }

  /*void filterPlayer(String playerName) {
    List<TaskModel> results = [];
    if (playerName.isEmpty) {
      results = lstTask;
    } else {
      results = lstTask
          .where((element) => element.fullName
          .toString()
          .toLowerCase()
          .contains(playerName.toLowerCase()) ||
              element.job
              .toString()
              .toLowerCase()
              .contains(playerName.toLowerCase()))
          .toList();
    }
    lstTask.value = results;
  } */

  // Save Data
  void saveTask(Map data) async {
    try {
      isProcessing(true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue,
            snackPosition: SnackPosition.TOP);
        isProcessing(false);
        //save data in local db
        var model = TaskModel();
        //model.id = data['_id'];
        model.fullName = data['fullName'];
        model.email = data['email'];
        model.job = data['job'];
        await localTaskService.saveTask(model);
        print('Inserting task : $model');

        await localTaskService.saveTaskSync(model);
        print('Inserting task synchronize : $model');
        lstTask.clear();
        refreshList();
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
       await TaskService().postData(data).then((resp) {
          isProcessing(false);

          ShowSnackBar.snackBar("Add Task", "Task Added", Colors.green);
          lstTask.clear();
          refreshList();
        }, onError: (err) {
          isProcessing(false);
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }

    } catch (exception) {
      isProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    }
  }

  void updateTask(String? id, Map data) {
    try {
      isProcessing(true);
      TaskService().putTask(id, data).then((resp) {
        isProcessing(false);

        ShowSnackBar.snackBar("Update Task", "Task updated", Colors.green);
        lstTask.clear();
        refreshList();
      }, onError: (err) {
        isProcessing(false);
        ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
      });

    } catch (exception) {
      isProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    }
  }
  // Delete Data
  Future<void> deleteTask(String id) async {
    try {
      isProcessing(true);
      await TaskService().deleteTask(id).then((resp) {
        isProcessing(false);

        ShowSnackBar.snackBar("Delete Task", "Task deleted", Colors.green);
        lstTask.clear();
        refreshList();
      }, onError: (err) {
        isProcessing(false);
        ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
      });

    } catch (exception) {
      isProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    }
  }

  //synchronization
  Future syncTaskToWebService() async {
    try {
    isProcessing(true);
    var connection = await Connectivity().checkConnectivity();
    if(connection == ConnectivityResult.none) {
      Get.snackbar("No Connection", "Cannot synchronize Data", colorText: Colors.blue,
          snackPosition: SnackPosition.TOP);
    }
    else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
      var response = await localTaskService.readTaskSync();
      response.forEach((data) async{
        var model = TaskModel();
        //model.id = data['_id'];
        model.fullName = data['fullName'];
        model.email = data['email'];
        model.job = data['job'];
        model.createdAt = data['createdAt'];
        print('get fullname ${model.fullName}');
        await TaskService().postData(data).then((resp) async {
          isProcessing(false);
           await localTaskService.deleteAllTaskSync();
          ShowSnackBar.snackBar("Add Task Sync", "Synchronization successfully", Colors.green);
          //lstTask.clear();
          //refreshList();
        }, onError: (err) {
          isProcessing(false);
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      });
    }
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    }
  }
}