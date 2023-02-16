import 'dart:ui';

class I18n {
  static Map<String, Map<String, String>> translations = {
    'en': {
      'greeting': 'Hello',
      'button_label': 'Press me',
    },
    'es': {
      'greeting': 'Hola',
      'button_label': 'Presióname',
    },
  };
  static Locale? _locale;
  static Locale get locale => _locale!;
  static set locale(Locale locale) => _locale = locale;
  static String? _languageCode;
  static String get languageCode => _languageCode!;
  static set languageCode(String languageCode) => _languageCode = languageCode;

  // get the translation for the current locale
  static String? translate(String key) {
    // check if the locale laguaage code is in the translations map
    if (!translations.containsKey(locale.languageCode)) {
      return translations['en']![key];
    }
    return translations[locale.languageCode]![key];
  }

  // get supportedLocales
  static Iterable<Locale> get supportedLocales =>
      translations.keys.map((e) => Locale(e, ''));

  // set the locale
  static void setLocale(Locale locale) {
    _locale = locale;
    _languageCode = locale.languageCode;
  }
}
