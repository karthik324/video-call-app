import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_call_app/controllers/controller.dart';
import 'package:video_call_app/core/app_animations.dart';
import 'package:video_call_app/core/app_colors.dart';
import 'package:video_call_app/core/app_styles.dart';
import 'package:video_call_app/core/constants.dart';
import 'package:video_call_app/views/video_call_screen.dart';
import 'package:video_call_app/views/widgets/custom_button.dart';
import 'package:video_call_app/views/widgets/cutom_text_field.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, required this.name});
  final String name;
  final controller = Controller.find;

  @override
  Widget build(BuildContext context) {
    final currTime = DateTime.now();
    final size = MediaQuery.sizeOf(context);
    print('curr time is $currTime');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.black,
        title: const Text(
          'Agora',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Constants.defaultScreenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (currTime.hour >= 0 && currTime.hour < 12)
                const Text(
                  'Good Morning!!',
                  style: AppStyles.header,
                ),
              if (currTime.hour >= 12 && currTime.hour <= 18)
                const Text(
                  'Good Afternoon!!',
                  style: AppStyles.header,
                ),
              if (currTime.hour >= 19 && currTime.hour < 23)
                const Text(
                  'Good Afternoon!!',
                  style: AppStyles.header,
                ),
              Text(
                'Hai There 👋 $name',
                style: AppStyles.header.copyWith(
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              Center(child: Lottie.asset(AppAnimations.homeResting)),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        showBottomSheet(context, size);
                      },
                      bgColor: AppColors.black,
                      child: Text(
                        'Start Video Call',
                        style: AppStyles.header.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showBottomSheet(BuildContext context, Size size) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(8),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // height: size.height / 3,
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Enter channel Id').paddingOnly(left: Constants.defaultScreenPadding),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                        controller: controller.channelNameController,
                        icon: CupertinoIcons.waveform_circle_fill,
                        obscure: false),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      GetBuilder<Controller>(builder: (api) {
                        return GestureDetector(
                          onTap: (){
                            api.updateSwitch(true, 'create');
                          },
                          child: Text(
                            'Create ',
                            style: AppStyles.header.copyWith(
                              fontSize: 20,
                              color: api.switchVal ? AppColors.textBlue : AppColors.textColor,
                            ),
                          ),
                        );
                      }),
                      const Text('/'),
                      GetBuilder<Controller>(builder: (api) {
                        return GestureDetector(
                          onTap: (){
                            api.updateSwitch(true, 'join');
                          },
                          child: Text(
                            ' Join',
                            style: AppStyles.header.copyWith(
                              fontSize: 20,
                              color: api.switchVal ? AppColors.textColor : AppColors.textBlue,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  GetBuilder<Controller>(builder: (api) {
                    return Switch.adaptive(
                      value: api.switchVal,
                      onChanged: (val) {
                        api.updateSwitch();
                      },
                    );
                  }),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () async {
                        if (controller.channelNameController.text.isEmpty) {
                          Get.snackbar('Validation', 'Enter channel name');
                          return;
                        }
                        await controller.handleMicAndVideo(Permission.camera);
                        await controller.handleMicAndVideo(Permission.microphone);
                        if (context.mounted) {
                          Navigator.pop(context);
                          print('channel is ${controller.channelNameController.text}');
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (ctx) => VideoCallScreen(
                                channelId: controller.channelNameController.text.trim(),
                              ),
                            ),
                          );
                        }
                      },
                      bgColor: AppColors.black,
                      child: Text(
                        'Done',
                        style: AppStyles.header.copyWith(
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
