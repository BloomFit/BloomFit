import 'package:get/get.dart';

import '../modules/edit_profile_page/bindings/edit_profile_page_binding.dart';
import '../modules/edit_profile_page/views/edit_profile_page_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login_page/bindings/login_page_binding.dart';
import '../modules/login_page/views/login_page_view.dart';
import '../modules/profile_page/bindings/profile_page_binding.dart';
import '../modules/profile_page/views/profile_page_view.dart';
import '../modules/register_page/bindings/register_page_binding.dart';
import '../modules/register_page/views/register_page_view.dart';
import '../modules/spalsh/bindings/spalsh_binding.dart';
import '../modules/spalsh/views/spalsh_view.dart';
import '../modules/video/bindings/video_binding.dart';
import '../modules/video/views/video_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.PROFILE_PAGE;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_PAGE,
      page: () => const LoginPageView(),
      binding: LoginPageBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_PAGE,
      page: () => const RegisterPageView(),
      binding: RegisterPageBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_PAGE,
      page: () => const ProfilePageView(),
      binding: ProfilePageBinding(),
    ),
    GetPage(
      name: _Paths.SPALSH,
      page: () => const SpalshView(),
      binding: SpalshBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE_PAGE,
      page: () => const EditProfilePageView(),
      binding: EditProfilePageBinding(),
    ),
    GetPage(
      name: _Paths.VIDEO,
      page: () =>  VideoView(),
      binding: VideoBinding(),
    ),
  ];
}
