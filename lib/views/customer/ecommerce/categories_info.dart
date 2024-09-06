import 'dart:io';

import 'package:al_rova/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CategoriesInfo extends StatefulWidget {
  final String categoryName;
  const CategoriesInfo({super.key, required this.categoryName});

  @override
  State<CategoriesInfo> createState() => _CategoriesInfoState();
}

class _CategoriesInfoState extends State<CategoriesInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(widget.categoryName),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Platform.isAndroid
                ? Icons.arrow_back_outlined
                : Icons.arrow_back_ios_new_outlined,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
