import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';

class Controller extends GetxController {
  static Controller get find => Get.find();

  bool isLoading = false;
  bool switchVal = false;

  final TextEditingController channelNameController = TextEditingController();

  ClientRoleType clientRoleType = ClientRoleType.clientRoleAudience;

  void updateSwitch([bool onText = false, String text = 'create']) {
    if(onText){
      if(text == 'create'){
        switchVal = true;
      } else {
        switchVal = false;
      }
      if (!switchVal) {
        clientRoleType = ClientRoleType.clientRoleAudience;
      } else {
        clientRoleType = ClientRoleType.clientRoleBroadcaster;
      }
    } else {
      switchVal = !switchVal;
      if (!switchVal) {
        clientRoleType = ClientRoleType.clientRoleAudience;
      } else {
        clientRoleType = ClientRoleType.clientRoleBroadcaster;
      }
    }
    update();
  }

  Future<void> handleMicAndVideo(Permission permission) async {
    final status = await permission.request();
    log(status.toString());
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential?> login(String email, String password) async {
    isLoading = true;
    update();
    try {
      final credential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      print('cred is $credential');
      isLoading = false;
      update();
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Error', 'No user found for that Email');
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Wrong password provided for that user');
      } else {
        Get.snackbar('Error', 'Wrong credentials');
      }
      isLoading = false;
      update();
      return null;
    }
  }
}
