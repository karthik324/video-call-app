import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_call_app/core/app_animations.dart';
import 'package:video_call_app/core/app_colors.dart';
import 'package:video_call_app/core/app_styles.dart';
import 'package:video_call_app/core/constants.dart';
import 'package:video_call_app/views/widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final currTime = DateTime.now();
    print('curr hour ${currTime.hour}');
    final size = MediaQuery.sizeOf(context);
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
              Center(child: Lottie.asset(AppAnimations.homeResting)),
              SizedBox(
                height: size.height * 0.05,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () {},
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
}
