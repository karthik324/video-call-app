import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_call_app/core/app_colors.dart';
import 'package:video_call_app/core/app_images.dart';
import 'package:video_call_app/core/app_styles.dart';
import 'package:video_call_app/core/constants.dart';
import 'package:video_call_app/core/firebase/firebase_configs.dart';
import 'package:video_call_app/views/home_screen.dart';
import 'package:video_call_app/views/widgets/custom_button.dart';
import 'package:video_call_app/views/widgets/cutom_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final userController = TextEditingController(text: 'test@gmail.com');
  final passController = TextEditingController(text: 'test@123');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Constants.defaultScreenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              const Center(
                child: Text(
                  'Login',
                  style: AppStyles.header,
                ),
              ),
              SizedBox(
                height: size.height * 0.15,
              ),
              const Text('Email').paddingOnly(left: Constants.defaultScreenPadding),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: userController,
                      icon: Icons.person_outline_sharp,
                      obscure: false,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              const Text('Password').paddingOnly(left: Constants.defaultScreenPadding),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: passController,
                      icon: Icons.lock,
                      obscure: true,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              CustomButton(
                onTap: () async {
                  if (userController.text.isEmpty) {
                    Get.snackbar('Validation', 'Username cannot be empty');
                    return;
                  }
                  if (passController.text.isEmpty) {
                    Get.snackbar('Validation', 'Password cannot be empty');
                    return;
                  }
                  var result =
                      await FireBaseConfigs.login(userController.text.trim(), passController.text.trim());
                  if (result != null && context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(
                        builder: (ctx) => HomeScreen(
                          name: result.user?.displayName ?? '',
                        ),
                      ),
                      (route) => false,
                    );
                  }
                },
                bgColor: AppColors.black,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              CustomButton(
                onTap: () async {
                  var cred = await FireBaseConfigs.signInWithGoogle();
                  print('curr $cred');
                  if (cred.user != null && context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(
                        builder: (ctx) => HomeScreen(
                          name: cred.user?.displayName ?? '',
                        ),
                      ),
                      (route) => false,
                    );
                  }
                },
                bgColor: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sign in with',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      AppImages.googleLogo,
                      width: 30,
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
