import 'package:al_rova/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class BottomModalTile extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final bool isCancel;
  const BottomModalTile(
      {super.key, this.onTap, required this.text, required this.isCancel});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isCancel ? AppColors.white : AppColors.primary;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 41,
        width: 154,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color.fromRGBO(74, 141, 52, 1))),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: isCancel ? AppColors.primary : AppColors.white,
                fontSize: 20),
          ),
        ),
      ),
    );
  }
}
