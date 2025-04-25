import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_app/app/routes/app_pages.dart';

class SpalshController extends GetxController {
  final getStorage = GetStorage();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    if(
    getStorage.read("status")!= "" && getStorage.read("status")!= null
    ){
      Future.delayed(
          const Duration(
              seconds: 5 ),(){
            Get.offAllNamed(Routes.HOME);
      });
    }else{
      Get.offAllNamed(Routes.LOGIN_PAGE);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
