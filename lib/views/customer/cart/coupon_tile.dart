import 'package:al_rova/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CouponTile extends StatelessWidget {
  final String code;
  final int minPurchase;
  final String validity;
  final bool isActive;
  final VoidCallback onApply;

  const CouponTile({
    super.key,
    required this.code,
    required this.minPurchase,
    required this.validity,
    required this.isActive,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color:
          isActive ? AppColors.white : const Color.fromRGBO(218, 218, 218, 0.1),
      child: ListTile(
        title: Text(
          code,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        subtitle: Text(
          'Minimum purchase of Rs.$minPurchase\nOffer valid up to $validity',
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
        trailing: TextButton(
          onPressed: isActive ? onApply : null,
          child: Text(
            "APPLY",
            style: TextStyle(
              color: isActive ? AppColors.primary : Colors.grey,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
