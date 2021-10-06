import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmer/shimmer.dart';

class WidgetShimmer extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shape;

  const WidgetShimmer.rectangular({
    this.width = double.infinity,
    this.height = 35.0,
  }) : this.shape = const RoundedRectangleBorder();

  const WidgetShimmer.circular({
    required this.width,
    required this.height,
    this.shape = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[100]!,
      period: const Duration(milliseconds: 4000),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: width,
          minHeight: height,
        ),
        decoration: ShapeDecoration(
          color: Colors.grey[200]!,
          shape: shape,
        ),
      ),
    );
  }
}
