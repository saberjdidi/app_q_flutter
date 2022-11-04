import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Utils/custom_colors.dart';
import '../../Controllers/login_controller.dart';

class LoginScreen extends GetView<LoginController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 60, left: 16, right: 16),
          width: context.width,
          height: context.height,
          child: SingleChildScrollView(
            child: Form(
              key: controller.loginFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                  ),
                  /*  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Connexion",
                    style: TextStyle(fontSize: 20, color: Colors.black87),
                  ), */
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      labelText: "Username",
                      hintText: 'username',
                      prefixIcon: Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: controller.usernameController,
                    textInputAction: TextInputAction.next,
                    onSaved: (value) {
                      controller.email = value!;
                    },
                    validator: (value) {
                      return controller.validateEmail(value!);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Obx(()=>
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            labelText: "Password",
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: InkWell(
                              child: Icon(
                                controller.isPasswordHidden.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                                size: 20,
                              ),
                              onTap: (){
                                controller.isPasswordHidden.value = !controller.isPasswordHidden.value;
                              },
                            )
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: controller.isPasswordHidden.value,
                        controller: controller.passwordController,
                        textInputAction: TextInputAction.done,
                        onSaved: (value) {
                          controller.password = value!;
                        },
                        validator: (value) {
                          return controller.validatePassword(value!);
                        },
                      )
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
                            controller.isDataProcessing.value ? 'Processing' : 'Login',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          onPressed: () {
                            controller.isDataProcessing.value ? null : controller.checkLogin();
                          },
                        )
                    ),
                  ),
                  /* ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width: context.width),
                    child: controller.isDataProcessing.value == true
                      ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          CustomColors.firebaseOrange,
                        ),
                      ),
                    )
                     : ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        backgroundColor:
                        MaterialStateProperty.all(CustomColors.blueAccent),
                        padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      onPressed: () {
                        controller.checkLogin();
                      },
                    ),
                  ), */
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
  }
}