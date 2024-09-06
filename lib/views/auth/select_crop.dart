import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/fonts.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:al_rova/utils/constants/strings.dart';
import 'package:al_rova/views/customer/crop/crop_growth_tips.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectCropModel {
  final String cropName;
  final String cropImage;
  final int id;
  final String selectedCrop;

  SelectCropModel(this.cropName, this.cropImage, this.id, this.selectedCrop);
  @override
  String toString() {
    return "(cropName: $cropName,id :$id)";
  }
}

class SelectCrop extends StatefulWidget {
  const SelectCrop({super.key});

  @override
  State<SelectCrop> createState() => _SelectCropState();
}

class _SelectCropState extends State<SelectCrop> {
  static List<SelectCropModel> mainSelectCropList = [
    SelectCropModel(AppStrings.redChillie, Images.redChillie, 1, "redchili"),
    SelectCropModel(AppStrings.tomato, Images.tomato, 2, "tomato"),
    SelectCropModel(AppStrings.cucumber, Images.cucumber, 3, "cucumber"),
    SelectCropModel(AppStrings.potato, Images.potato, 4, "potato"),
    SelectCropModel(AppStrings.brinjal, Images.brinjalNew, 5, "brinjal"),
    SelectCropModel(AppStrings.sugarcane, Images.sugarCaneNew, 6, "sugarcane"),
    SelectCropModel(AppStrings.carrot, Images.carrotNew, 7, "carrot"),
    SelectCropModel(AppStrings.orange, Images.orange, 8, "orange"),
    SelectCropModel(AppStrings.guava, Images.guava, 9, "guava"),
    SelectCropModel(AppStrings.papaya, Images.papayaNew, 10, "papaya"),
    SelectCropModel(
        AppStrings.waterMelon, Images.waterMelonNew, 11, "watermelon"),
  ];

  List<SelectCropModel> displaySelectCropList = List.from(mainSelectCropList);

  static List<SelectCropModel> selectedCropList = [];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: AppColors.white,
        statusBarIconBrightness: Brightness.dark));
    return SafeArea(
      left: true,
      right: true,
      top: true,
      bottom: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: AppColors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          AppStrings.selectCrops,
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: Fonts.poppins,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                              color: AppColors.black),
                        ),
                      ),
                    ],
                  )),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: const Divider(
                  height: 1,
                  color: AppColors.lightGary,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.count(
                    crossAxisCount: 3,
                    children:
                        List.generate(displaySelectCropList.length, (index) {
                      final isSelected = selectedCropList
                          .contains(displaySelectCropList[index]);
                      return Center(
                          child: InkWell(
                        onTap: () {
                          final selectedCrop = displaySelectCropList[index];
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => GrowthTips(
                                cropName: selectedCrop.selectedCrop,
                                cropImage: selectedCrop.cropImage,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.lightGary,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.lightGary,
                                    blurRadius: 2,
                                  ),
                                ],
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(40),
                                ),
                              ),
                              child: Image.asset(
                                displaySelectCropList[index].cropImage,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                              displaySelectCropList[index].cropName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: Fonts.poppins,
                                  color: AppColors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ));
                    }),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
