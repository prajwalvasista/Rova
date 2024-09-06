import 'package:flutter/material.dart';

class Event extends StatelessWidget {
  final child;

  const Event({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(30),
      child: child,
    );
  }
}
