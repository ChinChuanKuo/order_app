import 'package:flutter/material.dart';

class WidgetLoading {
  Widget centerCircular = Center(
    child: SizedBox(
      width: 50.0,
      height: 50.0,
      child: CircularProgressIndicator(
        strokeWidth: 7.0,
        valueColor: new AlwaysStoppedAnimation(Colors.red),
      ),
    ),
  );
}
