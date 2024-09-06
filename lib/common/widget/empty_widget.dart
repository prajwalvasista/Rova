import 'package:al_rova/utils/constants/app_style.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Image.asset(Images.emptyState),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: headLine4.copyWith(fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
