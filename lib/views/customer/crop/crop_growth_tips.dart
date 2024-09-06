import 'dart:convert';
import 'package:al_rova/models/customer/dashboard/growth_tips_model.dart';
import 'package:al_rova/utils/constants/app_style.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/fonts.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GrowthTips extends StatefulWidget {
  final String cropName;
  final String cropImage;

  const GrowthTips(
      {super.key, required this.cropName, required this.cropImage});

  @override
  State<GrowthTips> createState() => _GrowthTipsState();
}

class _GrowthTipsState extends State<GrowthTips> {
  late Future<GrowthTipsModel> futureGrowthTips;

  @override
  void initState() {
    super.initState();
    futureGrowthTips = loadGrowthTipsData();
  }

  Future<GrowthTipsModel> loadGrowthTipsData() async {
    try {
      String data =
          await rootBundle.loadString('assets/json/growth_tips_data.json');
      Map<String, dynamic> jsonData = json.decode(data);
      if (jsonData.containsKey(widget.cropName)) {
        return GrowthTipsModel.fromJson(jsonData[widget.cropName]);
      } else {
        throw Exception("Crop not found");
      }
    } catch (e) {
      throw Exception("Error loading growth tips: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 5,
        backgroundColor: Colors.white,
        title: Text(
          "Growth Tips (${widget.cropName.toUpperCase()})",
          style: headLine2,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder<GrowthTipsModel>(
          future: futureGrowthTips,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Something went wrong: ${snapshot.error}',
                    style: headLine2,
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (snapshot.hasData) {
                GrowthTipsModel data = snapshot.data!;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildCropGrowthBox(
                          'About', data.about!, data.aboutImage!),
                      _buildCropGrowthBox(
                          'Growing', data.growing!, data.growingImage!),
                      _buildCropGrowthBox('Plant Nutrition',
                          data.plantnutrition!, data.nutritionImage!),
                      _buildCropGrowthBox('Fertilizer Suggestion',
                          data.fertilizersuggestion!, Images.suggestion),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text(
                    'No data available',
                    style: headLine2,
                    textAlign: TextAlign.center,
                  ),
                );
              }
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildCropGrowthBox(String title, List<String> data, String image) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: AppColors.lightGary)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            image,
            width: MediaQuery.of(context).size.width,
            height: 250,
            fit: BoxFit.contain,
          ),
          Center(
            child: Text(
              title,
              style: headLine2,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: Text(
                  textAlign: TextAlign.justify,
                  '${index + 1}: ${data[index]}',
                  style: headLine6.copyWith(
                      color: Colors.black87,
                      fontFamily: Fonts.poppins,
                      fontSize: 14),
                ),
              );
            },
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
