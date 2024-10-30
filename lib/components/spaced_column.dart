import 'package:flutter/material.dart';
import 'package:utils_kit/extensions/list_extensions.dart';

/// [SpacedColumn] is a custom [Column] widget that allows for easy spacing between its children.
final class SpacedColumn extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final MainAxisAlignment? mainAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final CrossAxisAlignment? crossAxisAlignment;

  const SpacedColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.crossAxisAlignment,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: mainAxisSize ?? MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
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
