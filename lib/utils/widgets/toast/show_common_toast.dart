import 'package:al_rova/utils/widgets/toast/common_toast.dart';
import 'package:flutter/material.dart';

void showCustomToast(BuildContext context, String message, bool isError) {
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 60.0,
      left: 10,
      right: 10,
      child: CustomToast(message: message, isError: isError),
    ),
  );

  Overlay.of(context).insert(overlayEntry);

  // Optionally, remove the toast after a certain duration
  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}
