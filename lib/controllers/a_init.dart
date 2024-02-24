import 'package:get/get.dart';
import 'package:video_call_app/controllers/controller.dart';

class InitBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<Controller>(Controller());
  }
}
