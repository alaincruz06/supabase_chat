// Package imports:

import 'package:get/get.dart';
import 'package:supabase_chat/presentation/bindings/chat_binding.dart';
import 'package:supabase_chat/presentation/bindings/home_binding.dart';
import 'package:supabase_chat/presentation/bindings/login_binding.dart';
import 'package:supabase_chat/presentation/bindings/register_binding.dart';
import 'package:supabase_chat/presentation/bindings/view_users_binding.dart';
import 'package:supabase_chat/presentation/controllers/view_users_controller.dart';
import 'package:supabase_chat/presentation/pages/chat_page/chat_page.dart';
import 'package:supabase_chat/presentation/pages/home_page/home_page.dart';
import 'package:supabase_chat/presentation/pages/login_page/login_page.dart';
import 'package:supabase_chat/presentation/pages/register_page/register_page.dart';
import 'package:supabase_chat/presentation/pages/splash_page/splash_page.dart';
import 'package:supabase_chat/presentation/pages/view_users_page/view_users_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashPage(),
    ),

    GetPage(
      name: Routes.register,
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
    ),

    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),

    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: Routes.chat,
      page: () => const ChatPage(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: Routes.users,
      page: () => const ViewUsersPage(),
      binding: ViewUsersBinding(),
    ),

    //#endregion
  ];
}
