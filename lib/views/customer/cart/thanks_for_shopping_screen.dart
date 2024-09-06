import 'dart:io';

import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:al_rova/utils/widgets/common_dotted_line.dart';
import 'package:al_rova/views/customer/ecommerce/ecommerce_home.dart';
import 'package:flutter/material.dart';

class ThanksForShppingScreen extends StatefulWidget {
  const ThanksForShppingScreen({super.key});

  @override
  State<ThanksForShppingScreen> createState() => _ThanksForShppingScreenState();
}

class _ThanksForShppingScreenState extends State<ThanksForShppingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const EcommerceHome(),
              ),
            );
          },
          icon: const Icon(
            Icons.cancel,
            size: 50,
          ),
          color: AppColors.white,
        ),
        title: const Text(
          "Order Success",
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 2)),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Thanks for your purchase!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Image.asset(Images.confirmPurchase),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Delivery by Monday, Jul 1st 24",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    CommonDottedLine(),
                    SizedBox(height: 5),
                    Text(
                      '''Tejaswini

Sit 2nd cross
Tumkur- 562121
Phome number: 9380300004''',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "you will receive an order confirmation text with details of your order.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Text(
              "Your order ID: #ROVA4589",
              style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              height: 150,
              //color: AppColors.primary,
              child: Column(
                children: [
                  ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(AppColors.primary)),
                    onPressed: () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => const ThanksForShppingScreen()));
                    },
                    child: const Text(
                      "View Order Details",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Color.fromRGBO(242, 134, 35, 1))),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const EcommerceHome()));
                    },
                    child: const Text(
                      "Continue Shopping",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
