import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/licence_controller.dart';
import '../../Utils/custom_colors.dart';

class LicencePage extends GetView<LicenceController> {

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFD77908C), Color(0xFDE6F1EE)],
            begin: Alignment.bottomCenter,
            end: Alignment.center,
          ).createShader(bounds),
          blendMode: BlendMode.darken,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/logo.png'),
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    height: 150,
                    child: const Center(
                      child: Text(
                        'Qualipro',
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Form(
                      key: controller.licenceFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.white)
                              ),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              labelText: "Licence",
                              hintText: 'Licence',
                              prefixIcon: const Icon(Icons.keyboard, color: Colors.white, size: 30,),
                              hintStyle: const TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                              labelStyle: const TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            controller: controller.licenceController,
                            textInputAction: TextInputAction.next,
                            onSaved: (value) {
                              controller.email = value!;
                            },
                            validator: (value) {
                              return controller.validateLicence(value!);
                            },
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 80,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints.tightFor(width: context.width),
                            child: Obx(()=>
                                ElevatedButton.icon(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    backgroundColor:
                                    MaterialStateProperty.all(Color(0xFD1A79B8)),
                                    padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                                  ),
                                  icon: controller.isDataProcessing.value ? CircularProgressIndicator(color: Colors.white,):Icon(Icons.login, color: Colors.white,),
                                  label: Text(
                                    controller.isDataProcessing.value ? 'Processing' : 'Save',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  onPressed: () {
                                    controller.isDataProcessing.value ? null : controller.checkLicence();
                                  },
                                )
                            ),
                          ),
                          const SizedBox(
                            height: 80,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );

    /*
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 60, left: 16, right: 16),
          width: context.width,
          height: context.height,
          child: SingleChildScrollView(
            child: Form(
              key: controller.licenceFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      labelText: "Licence",
                      hintText: 'Licence',
                      prefixIcon: Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: controller.licenceController,
                    textInputAction: TextInputAction.next,
                    onSaved: (value) {
                      controller.email = value!;
                    },
                    validator: (value) {
                      return controller.validateLicence(value!);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width: context.width),
                    child: Obx(()=>
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            backgroundColor:
                            MaterialStateProperty.all(CustomColors.blueAccent),
                            padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                          ),
                          icon: controller.isDataProcessing.value ? CircularProgressIndicator(color: Colors.white,):Icon(Icons.login, color: Colors.white,),
                          label: Text(
                            controller.isDataProcessing.value ? 'Processing' : 'Save',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          onPressed: () {
                            controller.isDataProcessing.value ? null : controller.checkLicence();
                          },
                        )
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    */
  }

}
