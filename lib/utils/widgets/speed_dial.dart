import 'package:al_rova/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class SpeedDialBtn extends StatelessWidget {
  final VoidCallback onTakePhotoClick;
  final VoidCallback onChooseImgClick;
  SpeedDialBtn(
      {super.key,
      required this.onChooseImgClick,
      required this.onTakePhotoClick});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
        icon: Icons.qr_code_scanner_sharp,
        backgroundColor: AppColors.primary,
        animationCurve: Curves.bounceIn,
        iconTheme: const IconThemeData(color: AppColors.white),
        spacing: 15,
        mini: false,
        children: [
          SpeedDialChild(
            child: const Icon(
              Icons.photo_library_rounded,
              color: Colors.white,
            ),
            label: "Choose Photo",
            backgroundColor: AppColors.primary,
            onTap: onChooseImgClick,
          ),
          SpeedDialChild(
            child: const Icon(
              Icons.camera_alt_rounded,
              color: Colors.white,
            ),
            label: "Take Photo",
            backgroundColor: AppColors.primary,
            onTap: onTakePhotoClick,
          ),
        ]);
  }
}
