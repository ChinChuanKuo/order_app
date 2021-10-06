import 'package:flutter/material.dart';

class WidgetAnimator extends StatelessWidget {
  final int milliseconds;
  final bool horizontal;
  final bool vertical;
  final Widget child;

  const WidgetAnimator({
    Key? key,
    this.milliseconds = 700,
    this.horizontal = false,
    this.vertical = false,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Animator(
        milliseconds: milliseconds,
        horizontal: horizontal,
        vertical: vertical,
        child: child,
      );
}

class Animator extends StatefulWidget {
  final int milliseconds;
  final bool horizontal;
  final bool vertical;
  final Widget child;

  const Animator({
    Key? key,
    required this.milliseconds,
    required this.horizontal,
    required this.vertical,
    required this.child,
  }) : super(key: key);

  @override
  _AnimatorState createState() => _AnimatorState();
}

class _AnimatorState extends State<Animator>
    with SingleTickerProviderStateMixin {
  Duration? duration;
  AnimationController? controller;
  Animation<double>? animation;

  @override
  void initState() {
    duration = new Duration(milliseconds: this.widget.milliseconds);
    controller = AnimationController(vsync: this, duration: duration)
      ..forward();
    animation = Tween(begin: 0.0, end: 1.0).animate(controller!);
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller!,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: animation!.value,
          child: Transform.translate(
            offset: this.widget.vertical
                ? Offset(0.0, (1 - animation!.value) * 20)
                : this.widget.horizontal
                    ? Offset((1 - animation!.value) * 20, 0.0)
                    : Offset(0.0, 0.0),
            child: child,
          ),
        );
      },
      child: this.widget.child,
    );
  }
}
