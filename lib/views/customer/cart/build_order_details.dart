import 'package:flutter/material.dart';

class BuildOrderDetails extends StatelessWidget {
  final String text;
  const BuildOrderDetails({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );
  }
}
