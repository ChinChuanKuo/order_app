import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:order_app/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class FlipClock extends StatefulWidget {
  final Color color;
  final double maxWidth;
  final double fontSize;

  const FlipClock({
    Key? key,
    this.color = Colors.white,
    this.maxWidth = 20.0,
    this.fontSize = 20.0,
  }) : super(key: key);

  @override
  _FlipClockState createState() => _FlipClockState();
}

class _FlipClockState extends State<FlipClock> {
  late String clock;
  late Timer time;

  @override
  void initState() {
    clock = formatClock();
    time = new Timer.periodic(
        new Duration(milliseconds: 1000), (Timer t) => getClock());
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    time.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  String formatClock() => DateFormat('HH:mm:ss').format(DateTime.now());

  void getClock() => setState(() => clock = formatClock());

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FlipText(
            text: int.parse(clock.substring(0, 1)),
            color: this.widget.color,
            maxWidth: this.widget.maxWidth,
            fontSize: this.widget.fontSize),
        FlipText(
            text: int.parse(clock.substring(1, 2)),
            color: this.widget.color,
            maxWidth: this.widget.maxWidth,
            fontSize: this.widget.fontSize),
        Text(
          ":",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: this.widget.fontSize,
              color: this.widget.color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        FlipText(
            text: int.parse(clock.substring(3, 4)),
            maxValue: 5,
            color: this.widget.color,
            maxWidth: this.widget.maxWidth,
            fontSize: this.widget.fontSize),
        FlipText(
            text: int.parse(clock.substring(4, 5)),
            color: this.widget.color,
            maxWidth: this.widget.maxWidth,
            fontSize: this.widget.fontSize),
        Text(
          ":",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: this.widget.fontSize,
              color: this.widget.color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        FlipText(
            text: int.parse(clock.substring(6, 7)),
            maxValue: 5,
            color: this.widget.color,
            maxWidth: this.widget.maxWidth,
            fontSize: this.widget.fontSize),
        FlipText(
            text: int.parse(clock.substring(7, 8)),
            color: this.widget.color,
            maxWidth: this.widget.maxWidth,
            fontSize: this.widget.fontSize),
      ],
    );
  }
}
