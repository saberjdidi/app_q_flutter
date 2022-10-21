import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:qualipro_flutter/Utils/custom_colors.dart';
import '../../Controllers/onboarding_controller.dart';
import '../../Widgets/loading_widget.dart';
import '../dashboard_screen.dart';
import '../home_page.dart';

class OnBoardingPage extends GetView<OnBoardingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splash: Obx((){
          if (controller.isDataProcessing.value == true) {
            return Center(
              child: Column(
                children: <Widget>[
                  Lottie.asset('assets/images/loading_image.json', width: 150, height: 150),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text('synchronize_data'.tr,
                          style: TextStyle(color: Colors.blueGrey, fontSize: 20)),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                children: <Widget>[
                  /*const SizedBox(height: 50),
                  Image.asset(
                    "assets/images/sync_webservice.png",
                    // width: ,
                     height: 230,
                    // fit: BoxFit.fill,
                  ),
                  const SizedBox(height: 10),*/
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),),
                  Center(
                    child: Text('synchronize_data'.tr, textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blueGrey, fontSize: 20)),
                  ),
                  /* const SizedBox(height: 20),
                  MaterialButton(
                      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 0),
                      textColor: Colors.white,
                      onPressed: () {
                        //controller.next() ;
                        Get.off(DashboardScreen());
                      },
                      color: CustomColors.blueAccent,
                      child: const Text("Continue")) */
                ],
              ),
            );
          }
        }),
        nextScreen: HomePage(),
        duration: 10000,
        animationDuration: const Duration(seconds: 2),
        backgroundColor: Colors.white54,
        splashIconSize: 250,
        splashTransition: SplashTransition.sizeTransition,

      ),
      /*Obx(() {

        if (controller.isDataProcessing.value == true) {
          return Center(
            child: LoadingView(),
          );
        } else {
         return Column(
           children: [
             const SizedBox(height: 50),
             Image.asset(
               "assets/images/sync_webservice.png",
               // width: ,
               // height: 230,
               // fit: BoxFit.fill,
             ),
             const SizedBox(height: 50),
             Text('Synchronize Data to Local Database',
                 style: TextStyle(color: Colors.blueGrey, fontSize: 20)),
             const SizedBox(height: 20),
        MaterialButton(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 0),
        textColor: Colors.white,
        onPressed: () {
        //controller.next() ;
        Get.off(DashboardScreen());
        },
        color: CustomColors.blueAccent,
        child: const Text("Continue"))
           ],
         );
        }
      }
      ) */
    );
  }

}