import 'package:flutter/material.dart';

class RectangleCard extends StatelessWidget {
  final Widget child;

  const RectangleCard({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 14.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 16.0),
        child: Container(
            margin: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(shape: BoxShape.rectangle),
            padding: const EdgeInsets.all(8.0),
            child: child),
      ),
    );
  }
}
