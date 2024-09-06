import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:flutter/material.dart';

class OrderInfoCard extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final String subText;
  final String image;
  const OrderInfoCard(
      {super.key,
      required this.onTap,
      required this.text,
      required this.subText,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        child: ListTile(
          leading: SizedBox(
            width: 80,
            height: 60,
            child: Image.network(
              'https://developement_rovo.acelucid.com$image',
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  Images.product,
                  width: 48,
                  height: 85,
                );
              },
            ),
          ),
          title: Text(text),
          subtitle: Text(subText),
        ),
      ),
    );
  }
}
