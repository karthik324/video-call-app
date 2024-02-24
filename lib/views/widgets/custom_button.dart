import 'package:flutter/material.dart';
import 'package:video_call_app/core/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key,required this.onTap, required this.child, required this.bgColor,});
  final VoidCallback? onTap;
  final Widget child;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        minimumSize: const Size(0, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Constants.defaultBorderRadius)),
      ),
      child: child,
      // child: const Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Text(
      //       'Login',
      //       style: TextStyle(
      //         color: Colors.white,
      //         fontSize: 15,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
