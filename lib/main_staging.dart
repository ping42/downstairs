import 'package:downstairs/app/app.dart';
import 'package:downstairs/bootstrap.dart';
import 'package:downstairs/util/flavor_config.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  FlavorConfig(flavor: Flavor.staging);
  usePathUrlStrategy();
  bootstrap(() => const App());
}
