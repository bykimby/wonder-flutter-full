import 'package:get/get.dart';

import '../modules/event/bindings/event_binding.dart';
import '../modules/event/views/event_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/map/bindings/map_binding.dart';
import '../modules/map/views/map_view.dart';
import '../modules/map_detail/bindings/map_detail_binding.dart';
import '../modules/map_detail/views/map_detail_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/register_social/bindings/register_social_binding.dart';
import '../modules/register_social/views/register_social_view.dart';
import '../modules/reservation_list/bindings/reservation_list_binding.dart';
import '../modules/reservation_list/views/reservation_list_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/walk_track/bindings/walk_track_binding.dart';
import '../modules/walk_track/views/walk_track_view.dart';

part 'app_routes.dart';

abstract class AppPages {
  const AppPages._();

  static const INITIAL = Routes.MAP;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.MAP,
      page: () => const MapView(),
      binding: MapBinding(),
    ),
    GetPage(
      name: _Paths.MAP_DETAIL,
      page: () => const MapDetailView(),
      binding: MapDetailBinding(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: _Paths.EVENT,
      page: () => const EventView(),
      binding: EventBinding(),
    ),
    GetPage(
      name: _Paths.RESERVATION_LIST,
      page: () => const ReservationListView(),
      binding: ReservationListBinding(),
    ),
    GetPage(
      name: _Paths.WALK_TRACK,
      page: () => const WalkTrackView(),
      binding: WalkTrackBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_SOCIAL,
      page: () => const RegisterSocialView(),
      binding: RegisterSocialBinding(),
    ),
  ];
}
