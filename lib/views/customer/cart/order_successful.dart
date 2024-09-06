import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:al_rova/views/customer/cart/thanks_for_shopping_screen.dart';
import 'package:flutter/material.dart';

class OrderSuccessful extends StatefulWidget {
  const OrderSuccessful({super.key});

  @override
  State<OrderSuccessful> createState() => _OrderSuccessfulState();
}

class _OrderSuccessfulState extends State<OrderSuccessful> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(74, 141, 52, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(60.0),
            child: SizedBox(
              width: 300,
              height: 300,
              child: Image.asset(
                Images.bagImage,
              ),
            ),
          ),
          const Text(
            "Order Placed Sucessfully!",
            style: TextStyle(color: AppColors.white, fontSize: 30),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ThanksForShppingScreen(),
                  ),
                );
              },
              child: const Text(
                "View Order Details",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
