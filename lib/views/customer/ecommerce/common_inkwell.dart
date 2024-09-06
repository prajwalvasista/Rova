import 'package:al_rova/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CommonInkwell extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const CommonInkwell({super.key, this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 22,
          color: AppColors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
