import 'package:flutter/widgets.dart';

class RouteConfig {
  static Route<dynamic> generate(RouteSettings settings) {
    return PageRouteBuilder(pageBuilder: (_, __, ___) => const SizedBox.shrink());
  }
}
