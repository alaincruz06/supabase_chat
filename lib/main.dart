import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:supabase_chat/core/di/dependency_injection.dart';
import 'package:supabase_chat/presentation/app/lang/translation_service.dart';
import 'package:supabase_chat/presentation/app/theme.dart';
import 'package:supabase_chat/presentation/controllers/language_controller.dart';
import 'package:supabase_chat/presentation/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DependencyInjection.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(
      builder: (languageController) => GetMaterialApp(
        locale: languageController.getLocale,
        title: 'Flutter Demo',
        theme: AppThemes.mainTheme,
        translations: TranslationService(),
        localizationsDelegates: const [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: TranslationService().supportedLocales,
        getPages: AppPages.routes,
        initialRoute: Routes.splash,
      ),
    );
  }
}
