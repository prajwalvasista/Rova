import 'package:al_rova/utils/constants/app_style.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/widgets/common_button.dart';
import 'package:flutter/material.dart';

class AddNewShop extends StatefulWidget {
  const AddNewShop({super.key});

  @override
  State<AddNewShop> createState() => _AddNewShopState();
}

class _AddNewShopState extends State<AddNewShop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        centerTitle: true,
        title: const Text(
          'Add New Shop',
          style: headLine2,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CommonButton(
          onPressed: () {},
          buttonText: 'Submit',
          buttonColor: AppColors.primary,
          buttonTextColor: AppColors.white,
          height: 60,
        ),
      ),
    );
  }
}
