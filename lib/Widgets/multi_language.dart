import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/localisation/change_local.dart';

class MultiLanguage extends GetView<TranslationController> {
  const MultiLanguage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Text("1".tr, style: Theme.of(context).textTheme.headline1),
            const SizedBox(height: 5),
            /* MaterialButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: () {
                        controller.changeLang("fr");
                        Get.back();
                      },
                      child: Text('Francais',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),*/
            SizedBox(
              width: Get.width * 0.6,
              child: ElevatedButton.icon(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF09C6E8)),
                    padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                  ),
                  icon: Image.asset(
                    "assets/images/flag_fr.png",
                    width: 35,
                  ),
                  label: Text(
                    'Francais',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  onPressed: () {
                    controller.changeLang("fr");
                    Get.back();
                  }),
            ),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: Get.width * 0.6,
              child: ElevatedButton.icon(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF09C6E8)),
                    padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                  ),
                  icon: Image.asset(
                    "assets/images/flag_en.png",
                    width: 35,
                  ),
                  label: Text(
                    'English',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  onPressed: () {
                    controller.changeLang("en");
                    Get.back();
                  }),
            ),
            /* CustomButtonLang(
                  textbutton: "En",
                  onPressed: () {
                    controller.changeLang("en");
                    //Get.toNamed(AppRoute.onBoarding) ;
                  }), */
          ],
        ));
  }
}
