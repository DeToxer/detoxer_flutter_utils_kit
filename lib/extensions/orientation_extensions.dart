import 'package:flutter/material.dart';

extension OrientationExtension on Orientation {
  bool get isLandscape => this == Orientation.landscape;

  bool get isPortrait => this == Orientation.portrait;
}