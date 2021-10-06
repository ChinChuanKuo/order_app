import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlipText extends StatefulWidget {
  final int text;
  final int maxValue;
  final Color color;
  final double maxWidth;
  final double fontSize;

  const FlipText({
    Key? key,
    required this.text,
    this.maxValue = 9,
    required this.color,
    required this.maxWidth,
    required this.fontSize,
  }) : super(key: key);

  @override
  _FlipTextState createState() => _FlipTextState();
}

class _FlipTextState extends State<FlipText>
    with SingleTickerProviderStateMixin {
  late bool reverse;
  late double angle;
  late int number;
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    reverse = false;
    angle = 0.0001;
    number = this.widget.text;
    controller = new AnimationController(
        duration: Duration(milliseconds: 450), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
          reverse = true;
        }
        if (status == AnimationStatus.dismissed) {
          reverse = false;
          number += 1;
        }
      })
      ..addListener(() => setState(() {}));
    animation = Tween(begin: angle, end: pi / 2).animate(controller);
    // TODO: implement initState
    super.initState();
  }

  @override
  void didUpdateWidget(FlipText oldWidget) {
    if (this.widget.text != oldWidget.text) {
      controller.forward();
      number = oldWidget.text;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            AlignText(
              value: number + 1,
              maxValue: this.widget.maxValue,
              color: Colors.transparent,
              maxWidth: this.widget.maxWidth,
              fontSize: this.widget.fontSize,
              alignment: Alignment.topCenter,
            ),
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.006)
                ..rotateX(reverse ? pi / 2 : animation.value),
              alignment: Alignment.bottomCenter,
              child: AlignText(
                value: number,
                maxValue: this.widget.maxValue,
                color: Colors.transparent,
                maxWidth: this.widget.maxWidth,
                fontSize: this.widget.fontSize,
                alignment: Alignment.topCenter,
              ),
            ),
          ],
        ),
        Stack(
          children: [
            AlignText(
              value: number,
              maxValue: this.widget.maxValue,
              color: this.widget.color,
              maxWidth: this.widget.maxWidth,
              fontSize: this.widget.fontSize,
              alignment: Alignment.bottomCenter,
            ),
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.006)
                ..rotateX(reverse ? -animation.value : pi / 2),
              alignment: Alignment.topCenter,
              child: AlignText(
                value: number + 1,
                maxValue: this.widget.maxValue,
                color: this.widget.color,
                maxWidth: this.widget.maxWidth,
                fontSize: this.widget.fontSize,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class AlignText extends StatelessWidget {
  final int value;
  final int maxValue;
  final Color color;
  final double maxWidth;
  final double fontSize;
  final Alignment alignment;

  const AlignText({
    Key? key,
    required this.value,
    required this.maxValue,
    required this.color,
    required this.maxWidth,
    required this.fontSize,
    required this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int number = value > maxValue ? 0 : value;
    return Align(
      alignment: alignment,
      heightFactor: 0.5,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        constraints: BoxConstraints(maxWidth: maxWidth),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(24.0)),
            color: Colors.transparent),
        child: Text(
          "$number",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: fontSize,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
