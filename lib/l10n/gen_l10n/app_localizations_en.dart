import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get titleAppBarTitle => 'Downstairs';

  @override
  String get titleButtonStart => 'Start';

  @override
  String get titleButtonStartAgain => 'Start Again';

  @override
  String get titleButtonGameOver => 'Game Over';

  @override
  String get titleButtonBackToMainMenu => 'Back to Main Menu';

  @override
  String loading(Object label) {
    return 'Loading $label...';
  }

  @override
  String loadingPhaseLabel(String loadingPhase) {
    String _temp0 = intl.Intl.selectLogic(
      loadingPhase,
      {
        'audio': 'Delightful music',
        'images': 'Beautiful scenery',
        'other': ' ',
      },
    );
    return '$_temp0';
  }
}
