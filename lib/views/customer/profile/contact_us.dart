import 'package:al_rova/utils/constants/app_style.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:flutter/material.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 5,
        backgroundColor: Colors.white,
        title: const Text(
          "Contact Us",
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: AppColors.gary,
                blurRadius: 5.0,
              )
            ]),
        child: Column(
          children: [
            Image.asset(
              Images.contactUs,
              height: 200,
              width: MediaQuery.of(context).size.width,
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_city,
                  color: AppColors.primary,
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 270,
                  child: Text(
                    'Acelucid Technologies Private ltd. B-Block, BHIVE Workspace - No.112, AKR Tech Park,Banglore, India',
                    style: headLine5.copyWith(fontWeight: FontWeight.w500),
                    maxLines: 4,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Icon(
                  Icons.email,
                  color: AppColors.primary,
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 270,
                  child: Text(
                    'dev.ace@acelucid.com',
                    style: headLine5.copyWith(
                        fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
