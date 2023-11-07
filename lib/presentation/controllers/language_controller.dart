import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_chat/presentation/app/lang/translation_service.dart';

class LanguageController extends GetxController {
  static LanguageController get to => Get.find();
  final languageCode = "".obs;
  final store = GetStorage();
  final countryCode = "".obs;

  String get currentLanguage => languageCode.value;
  String get currentCountry => countryCode.value;

  // Gets current language stored
  (RxString, RxString) get currentLanguageStore {
    languageCode.value = store.read('language') ?? '';
    countryCode.value = store.read('country') ?? '';
    return (languageCode, countryCode);
  }

  // gets the language locale app is set to
  Locale? get getLocale {
    var (language, country) = currentLanguageStore;
    if (language.value == '' && country.value == '') {
      languageCode.value = TranslationService.defaultLanguage;
      countryCode.value = TranslationService.defaultCountry;
      updateLanguage(TranslationService.defaultLanguage,
          TranslationService.defaultCountry);
    } else if (language.value != '' && country.value != '') {
      //set the stored string country code to the locale
      return Locale(language.value, country.value);
    }
    // gets the default language key for the system.
    return Get.deviceLocale;
  }

  // updates the language stored
  Future<void> updateLanguage(String locale, String country) async {
    languageCode.value = locale;
    countryCode.value = country;
    await store.write('language', locale);
    await store.write('country', country);
    if (getLocale != null) {
      await Get.updateLocale(getLocale!);
    }
    update();
  }
}
