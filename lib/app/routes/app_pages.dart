import 'package:get/get.dart';

import '../modules/activity/bindings/activity_binding.dart';
import '../modules/activity/views/activity_view.dart';
import '../modules/articles/bindings/articles_binding.dart';
import '../modules/articles/views/articles_view.dart';
import '../modules/detection_page/bindings/detection_page_binding.dart';
import '../modules/detection_page/views/detection_page_view.dart';
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
import '../modules/selection_page/bindings/selection_page_binding.dart';
import '../modules/selection_page/views/selection_page_view.dart';
import '../modules/spalsh/bindings/spalsh_binding.dart';
import '../modules/spalsh/views/spalsh_view.dart';
import '../modules/video/bindings/video_binding.dart';
import '../modules/video/views/video_view.dart';
import '../modules/visualiasi/bindings/visualiasi_binding.dart';
import '../modules/visualiasi/views/visualiasi_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPALSH;

  static final routes = [
    GetPage(
      name: _Paths.SPALSH,
      page: () => const SafeBumpApp(),
      binding: SpalshBinding(),
    ),
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
      name: _Paths.EDIT_PROFILE_PAGE,
      page: () => EditProfilePageView(),
      binding: EditProfilePageBinding(),
    ),
    GetPage(
      name: _Paths.VIDEO,
      page: () => VideoView(),
      binding: VideoBinding(),
    ),
    GetPage(
      name: _Paths.ARTICLES,
      page: () =>  ArticlesView(),
      binding: ArticlesBinding(),
    ),
    GetPage(
      name: _Paths.DETECTION_PAGE,
      page: () => const DetectionPageView(),
      binding: DetectionPageBinding(),
    ),
    GetPage(
      name: _Paths.VISUALIASI,
      page: () => SenamIbuHamilView(),
      binding: VisualiasiBinding(),
    ),
    GetPage(
      name: _Paths.ACTIVITY,
      page: () => const ActivityView(),
      binding: ActivityBinding(),
    ),
    GetPage(
      name: _Paths.SELECTION_PAGE,
      page: () => const SelectionPageView(),
      binding: SelectionPageBinding(),
    ),
  ];
}
