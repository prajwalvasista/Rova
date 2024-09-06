import 'package:al_rova/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CommonSearchBox extends StatelessWidget {
  TextEditingController textEditingController;
  Color fillColor;
  bool filled;
  bool isSuffix;
  String hintText;
  Function()? onPressed;
  CommonSearchBox(
      {super.key,
      required this.textEditingController,
      required this.fillColor,
      required this.filled,
      required this.isSuffix,
      required this.hintText,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        controller: textEditingController,
        maxLines: 1,
        cursorColor: AppColors.primary,
        onChanged: (value) {},
        decoration: InputDecoration(
          hintText: hintText,
          isDense: filled,
          fillColor: fillColor,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: AppColors.primary, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: AppColors.primary, width: 1),
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 25,
            color: AppColors.primary,
          ),
          suffixIcon: isSuffix
              ? InkWell(
                  onTap: onPressed,
                  child: const Icon(
                    Icons.photo_camera_outlined,
                    size: 25,
                    color: AppColors.gary,
                  ),
                )
              : null,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Color(0xffDEDEDE), width: 1)),
        ),
      ),
    );
  }
}
