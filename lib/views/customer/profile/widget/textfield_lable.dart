import 'package:al_rova/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TextFieldLabel extends StatelessWidget {
  final String text;
  const TextFieldLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.firstName,
        fontSize: 16,
      ),
    );
  }
}