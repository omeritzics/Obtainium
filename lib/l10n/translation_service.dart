import 'package:flutter/services.dart';
import 'package:gettext/gettext.dart';
import 'dart:ui' as ui;

class I18n {
  static final Gettext _gt = Gettext();

  static Future<void> init() async {
    // Determine the device language
    String locale = ui.window.locale.languageCode;
    
    try {
      // Load the .po file from assets
      String poContent = await rootBundle.loadString('lib/l10n/$locale.po');
      _gt.addTranslations(locale, poContent);
      _gt.locale = locale;
    } catch (e) {
      // Fallback to English if the language file is missing
      try {
        String enContent = await rootBundle.loadString('lib/l10n/en.po');
        _gt.addTranslations('en', enContent);
        _gt.locale = 'en';
      } catch (err) {
        print("Localization error: $err");
      }
    }
  }

  // Translation helper function
  static String t(String key) => _gt.gettext(key);
}