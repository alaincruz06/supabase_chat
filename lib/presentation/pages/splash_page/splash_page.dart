import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_chat/core/extensions.dart';
import 'package:supabase_chat/presentation/controllers/user_controller.dart';
import 'package:supabase_chat/presentation/routes/app_pages.dart';
import 'package:supabase_chat/presentation/widgets/preloader_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Page to redirect users to the appropriate page depending on the initial auth state
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  bool _redirectCalled = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await _redirect();
  }

  Future<void> _redirect() async {
    try {
      // await for for the widget to mount
      await Future.delayed(const Duration(seconds: 2));
      if (_redirectCalled || !mounted) {
        return;
      }

      _redirectCalled = true;
      final SupabaseClient supabaseClient = Get.find<SupabaseClient>();
      final prefs = Get.find<SharedPreferences>();
      final session = supabaseClient.auth.currentSession;
      //TODO handle token refresh
      // Unhandled Exception: AuthException(message: Invalid Refresh Token: Already Used, statusCode: 400)
      if (session != null) {
        Get.offAllNamed(Routes.home, predicate: (route) => false);
      }

      final sessionData = prefs.getString('session_data');
      if (sessionData != null) {
        try {
          final response =
              await supabaseClient.auth.recoverSession(sessionData);
          final userController = Get.find<UserController>();
          await userController.setLoggedInUser(
            response.user!.id,
          );
          prefs.setString(
              'session_data', response.session!.persistSessionString);
          Get.offAllNamed(Routes.home, predicate: (route) => false);
        } on AuthException {
          try {
            // Refresh the token before navigating to the login screen
            await supabaseClient.auth.refreshSession();
          } catch (e) {
            // Handle refresh token failure, navigate to login, and show error
            Get.offAllNamed(Routes.login);
            Get.context!
                .showErrorSnackBar(message: 'app.yourSessionHasExpired'.tr);
          }
        } catch (e) {
          debugPrint('Error at SplashPage - Unknown Exception: $e');
          Get.offAllNamed(Routes.login);
        }
      } else {
        Get.offAllNamed(Routes.login);
      }
    } catch (e) {
      debugPrint('Error on SplashPage - _redirect: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: PreloaderWidget());
  }
}
