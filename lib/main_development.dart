import 'package:downstairs/app/app.dart';
import 'package:downstairs/bootstrap.dart';
import 'package:downstairs/util/flavor_config.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  FlavorConfig(flavor: Flavor.development);
  usePathUrlStrategy();
  bootstrap(() => const App());
}
