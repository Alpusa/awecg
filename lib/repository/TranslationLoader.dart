import 'dart:convert';
import 'package:flutter/services.dart';

import 'I18n.dart';

class TranslationLoader {
  static Future<void> loadTranslations() async {
    String jsonStringEn = await rootBundle.loadString('lib/i18n/en-US_.json');
    String jsonStringEs = await rootBundle.loadString('lib/i18n/es-ES_.json');
    Map<String, dynamic> jsonMapEn = json.decode(jsonStringEn);
    Map<String, dynamic> jsonMapEs = json.decode(jsonStringEs);
    Map<String, dynamic> jsonMap = {
      'en': jsonMapEn,
      'es': jsonMapEs,
    };

    I18n.translations = jsonMap
        .map((key, value) => MapEntry(key, Map<String, String>.from(value)));
  }
}
