import 'package:al_rova/utils/constants/app_style.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:flutter/material.dart';

class CategoriesItem extends StatelessWidget {
  final VoidCallback? onTap;
  String title, image;
  CategoriesItem(
      {super.key, this.onTap, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36.5),
                  color: const Color(0xffE9F5FA)),
              child: Image.network(
                'https://developement_rovo.acelucid.com$image',
                width: 60,
                height: 60,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    Images.cotton,
                    width: 35,
                    height: 35,
                    fit: BoxFit.contain,
                  );
                },
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              title,
              style: headLine5,
            ),
          ],
        ),
      ),
    );
  }
}
