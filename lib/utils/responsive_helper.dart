import 'package:flutter/widgets.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 720;
  }

  static bool isTabletWidth(double width) {
    return width >= 640;
  }

  static bool isDesktopWidth(double width) {
    return width >= 960;
  }
}
