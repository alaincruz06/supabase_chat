// Package imports:
import 'dart:ui';
import 'package:get/get.dart';

// Project imports:
import 'en_unit_state.dart';
import 'es_espanna.dart';

class TranslationService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'es_ES': esEs,
      };

  Iterable<Locale> get supportedLocales => const [
        Locale('en', 'US'),
        Locale('es', 'ES'),
      ];

  static String defaultLanguage = 'es';
  static String defaultCountry = 'ES';
}
