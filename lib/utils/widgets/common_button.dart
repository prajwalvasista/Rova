import 'package:al_rova/utils/constants/fonts.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final VoidCallback onPressed;
  String buttonText;
  Color buttonColor;
  Color buttonTextColor;
  double? height;
  double? width;
  double? fontSize;
  CommonButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    required this.buttonColor,
    required this.buttonTextColor,
    this.height,
    this.width,
      this.fontSize
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ))),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: fontSize,
            color: buttonTextColor,
            fontFamily: Fonts.dmSansSemiBold,
          ),
        ),
      ),
    );
  }
}
