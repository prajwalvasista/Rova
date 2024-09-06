import 'package:al_rova/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CommonInputBox extends StatefulWidget {
  final bool isLabelBackgroundColorRequried;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final bool filled;
  final Color? fillColour;
  final bool obscureText;
  final bool readOnly;
  final Widget? suffixIcon;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool overrideValidator;
  final TextStyle? hintStyle;
  String? inputFormatter;
  final Widget? prefixIcon;
  final VoidCallback? onTap;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  TextInputAction? textInputAction;

  CommonInputBox(
      {required this.controller,
      this.filled = false,
      this.obscureText = false,
      this.readOnly = false,
      super.key,
      this.validator,
      this.fillColour,
      this.suffixIcon,
      this.hintText,
      this.keyboardType,
      this.hintStyle,
      this.overrideValidator = false,
      this.inputFormatter,
      this.prefixIcon,
      this.isLabelBackgroundColorRequried = false,
      this.onTap,
      this.maxLength,
      this.textInputAction,
      this.minLines,
      this.maxLines});

  @override
  State<CommonInputBox> createState() => _CommonInputBoxState();
}

class _CommonInputBoxState extends State<CommonInputBox> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      maxLength: widget.maxLength,
      textInputAction: widget.textInputAction,
      minLines: widget.minLines ?? 1,
      maxLines: widget.maxLines ?? 1,
      validator: widget.overrideValidator
          ? widget.validator
          : (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return widget.validator?.call(value);
            },
      onTapOutside: (_) {
        FocusScope.of(context).unfocus();
      },
      onTap: widget.onTap,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
          isDense: true,
          alignLabelWithHint: true,
          // floatingLabelStyle: widget.isLabelBackgroundColorRequried
          //     ? const TextStyle(backgroundColor: AppColors.card)
          //     : null,
          label: Text(
            widget.hintText ?? "",
            // style:
            //     MaterialStateTextStyle.resolveWith((Set<MaterialState> states) {
            //   final Color color = states.contains(MaterialState.focused)
            //       ? AppColors.primary
            //       : AppColors.card;
            //   return TextStyle(color: color);
            // }),
            // style: TextStyle(
            //     color: widget.readOnly
            //         ? AppColors.lightGrey
            //         : AppColors.textfieldBorderFocusColor),
          ),
          isCollapsed: false,
          counterText: "",
          floatingLabelStyle: const TextStyle(color: AppColors.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.0,
            ),
          ),
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(12.0),
          //   borderSide: const BorderSide(
          //     color: AppColors.card,
          //     width: 1.0,
          //   ),
          // ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.5,
            ),
          ),
          // overwriting the default padding helps with that puffy look
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          filled: widget.filled,
          fillColor: widget.fillColour,
          suffixIcon: widget.suffixIcon,
          prefixIcon: widget.prefixIcon
          // hintText: widget.hintText,
          // hintStyle: widget.hintStyle ??
          //     TextStyle(
          //         fontSize: 16,
          //         fontWeight: FontWeight.w400,
          //         color: widget.readOnly
          //             ? AppColors.lightGrey
          //             : AppColors.textfieldFocusBorderColor),
          ),
    );
  }
}
