import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get titleAppBarTitle => '落樓梯';

  @override
  String get titleButtonStart => '開始';

  @override
  String get titleButtonStartAgain => '重新開始';

  @override
  String get titleButtonGameOver => '遊戲結束';

  @override
  String get titleButtonBackToMainMenu => '回到主選單';

  @override
  String loading(Object label) {
    return '載入中 $label...';
  }

  @override
  String loadingPhaseLabel(String loadingPhase) {
    String _temp0 = intl.Intl.selectLogic(
      loadingPhase,
      {
        'audio': '音樂',
        'images': '圖片',
        'other': ' ',
      },
    );
    return '$_temp0';
  }
}
