import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final bool isTesting = Platform.environment.containsKey('FLUTTER_TEST');

const double _phoneScreenTypeSizeThreshold = 600;
const double _tabletScreenTypeSizeThreshold = 1024;

ScreenType screenType({
  double screenTypeSizeThreshold = _phoneScreenTypeSizeThreshold,
  double tabletScreenTypeSizeThreshold = _tabletScreenTypeSizeThreshold,
}) {
  final platformDispatcher = WidgetsBinding.instance.platformDispatcher;
  var shortestSide = platformDispatcher.views.first.physicalSize.shortestSide;
  shortestSide = shortestSide / platformDispatcher.views.first.devicePixelRatio;

  if (shortestSide < screenTypeSizeThreshold) {
    return ScreenType.phone;
  }
  if (shortestSide <= tabletScreenTypeSizeThreshold) {
    return ScreenType.tablet;
  }
  return ScreenType.desktop;
}

enum ScreenType {
  phone,
  tablet,
  desktop;
}

enum DevicePlatform {
  android,
  fuchsia,
  iOS,
  linux,
  macOS,
  windows,
  web,
  unknown;

  static DevicePlatform get current {
    if (kIsWeb) return DevicePlatform.web;
    if (Platform.isAndroid) return DevicePlatform.android;
    if (Platform.isFuchsia) return DevicePlatform.fuchsia;
    if (Platform.isIOS) return DevicePlatform.iOS;
    if (Platform.isLinux) return DevicePlatform.linux;
    if (Platform.isMacOS) return DevicePlatform.macOS;
    if (Platform.isWindows) return DevicePlatform.windows;
    return DevicePlatform.unknown;
  }

  String get displayable {
    return switch (this) {
      DevicePlatform.android => "Android",
      DevicePlatform.fuchsia => "Fuchsia",
      DevicePlatform.iOS => "iOS",
      DevicePlatform.linux => "Linux",
      DevicePlatform.macOS => "MacOS",
      DevicePlatform.windows => "Windows",
      DevicePlatform.web => "Web",
      DevicePlatform.unknown => "Unknown",
    };
  }
}
