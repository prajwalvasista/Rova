import 'package:al_rova/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum SpinKitType { wave, circle }

class SpinKitIndicator extends StatelessWidget {
  const SpinKitIndicator({
    super.key,
    this.type = SpinKitType.wave,
  });

  final SpinKitType type;

  @override
  Widget build(BuildContext context) {
    Widget widget;
    switch (type) {
      case SpinKitType.wave:
        widget = const SpinKitWave(
          color: AppColors.primary,
          size: 60.0,
        );
        break;
      case SpinKitType.circle:
        widget = const SpinKitFadingCircle(
          color: AppColors.primary,
          size: 60.0,
        );
    }
    return Center(child: widget);
  }
}