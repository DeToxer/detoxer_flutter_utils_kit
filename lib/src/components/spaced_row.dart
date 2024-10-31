import 'package:flutter/material.dart';
import 'package:utils_kit/utils_kit.dart';

/// [SpacedRow] is a custom [Row] widget that allows for easy spacing between its children.
final class SpacedRow extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final MainAxisAlignment? mainAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final CrossAxisAlignment? crossAxisAlignment;

  const SpacedRow({
    super.key,
    required this.children,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.crossAxisAlignment,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: mainAxisSize ?? MainAxisSize.max,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      children: spacing <= 0.0
          ? children
          : children
              .intersperse(
                SizedBox(height: spacing),
              )
              .toList(),
    );
  }
}
