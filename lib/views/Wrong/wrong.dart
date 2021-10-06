import 'package:flutter/material.dart';

class WrongView extends StatelessWidget {
  final String? name;

  const WrongView({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Text('No route defined for $name'),
        ),
      );
}
