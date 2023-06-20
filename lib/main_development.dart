import 'package:downstairs/app/app.dart';
import 'package:downstairs/bootstrap.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();
  bootstrap(() => const App());
}
