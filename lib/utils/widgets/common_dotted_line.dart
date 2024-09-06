import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class CommonDottedLine extends StatelessWidget {
  const CommonDottedLine({super.key});

  @override
  Widget build(BuildContext context) {
    return const DottedLine(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      lineLength: double.infinity,
      lineThickness: 1.0,
      dashLength: 4.0,
      dashColor: Color(0xff80807F),
      // dashGradient: [Colors.red, Colors.blue],
      dashRadius: 0.0,
      dashGapLength: 4.0,
      dashGapColor: Colors.transparent,
      // dashGapGradient: [Colors.red, Colors.blue],
      dashGapRadius: 0.0,
    );
  }
}
