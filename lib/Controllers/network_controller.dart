import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../Utils/snack_bar.dart';

class NetworkController extends GetxController {

  var connectionStatus = 0.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();

    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try{
      result = await _connectivity.checkConnectivity();
    }
    on PlatformException catch(ex){
      print(ex.toString());
    }
    return _updateConnectionStatus(result);
  }

  _updateConnectionStatus(ConnectivityResult result) {
    switch(result){
      case ConnectivityResult.wifi:
        connectionStatus.value = 1;
        //ShowSnackBar.snackBar('Internet Connection', 'Wifi', Colors.green);
        break;
      case ConnectivityResult.mobile:
        connectionStatus.value = 2;
        //ShowSnackBar.snackBar('Internet Connection', 'Mobile', Colors.green);
        break;
      case ConnectivityResult.none:
        connectionStatus.value = 0;
        //ShowSnackBar.snackBar('No Internet Connection', 'Mode Offline', Colors.green);
        break;
      default:
        Get.snackbar("Network Error", "Fail to get network connection");
        break;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

}
