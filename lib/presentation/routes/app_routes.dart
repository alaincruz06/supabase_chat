part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  //#region Init

  static const splash = _Paths.splash;
  static const register = _Paths.register;
  static const login = _Paths.login;
  static const home = _Paths.home;
  static const chat = _Paths.chat;
  static const users = _Paths.users;
}

abstract class _Paths {
  //#region Init

  static const splash = "/splash";
  static const register = "/register";
  static const login = "/login";
  static const home = '/home';
  static const chat = '/chat';
  static const users = '/users';
}
