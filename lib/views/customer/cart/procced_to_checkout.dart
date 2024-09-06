import 'dart:io';
import 'dart:math';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:al_rova/views/customer/cart/bottom_modal_tile.dart';
import 'package:al_rova/views/customer/cart/build_order_details.dart';
import 'package:al_rova/views/customer/cart/build_payment_methods.dart';
import 'package:al_rova/views/customer/cart/order_successful.dart';
import 'package:flutter/material.dart';

class ProccedToCheckOut extends StatefulWidget {
  const ProccedToCheckOut({super.key});

  @override
  State<ProccedToCheckOut> createState() => _ProccedToCheckOutState();
}

class _ProccedToCheckOutState extends State<ProccedToCheckOut> {
  bool _isExpanded = false;
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Payments",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Platform.isAndroid
                ? Icons.arrow_back_rounded
                : Icons.arrow_back_ios_new_rounded,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(15),
              color: AppColors.secondary,
              height: _isExpanded
                  ? 180
                  : max(
                      100,
                      50 +
                          const EdgeInsets.all(15).top +
                          const EdgeInsets.all(15).bottom),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isExpanded) ...[
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BuildOrderDetails(text: "Price (2 Items)"),
                          BuildOrderDetails(text: "₹170"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BuildOrderDetails(text: "Delivery Charges"),
                          BuildOrderDetails(text: "₹30"),
                        ],
                      ),
                    ],
                    const SizedBox(height: 10),
                    Divider(
                      color: _isExpanded ? Colors.black : AppColors.secondary,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BuildOrderDetails(text: "Total Amount"),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: Icon(
                            _isExpanded
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            size: 35,
                          ),
                        ),
                        const BuildOrderDetails(text: "₹200"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "SELECT A PAYMENT OPTION",
              style:
                  TextStyle(color: Color.fromRGBO(93, 88, 88, 1), fontSize: 24),
            ),
            // BuildPaymentMethods(
            //   text: "UPI Payment",
            //   image: Images.bhimUpi,
            //   icon: _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            //   onTap: () {},
            // ),
            // BuildPaymentMethods(
            //   text: "Credit/Debit Card",
            //   image: Images.creditCard,
            //   icon: _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            //   onTap: () {},
            // ),
            BuildPaymentMethods(
              text: "Cash On Delivery",
              image: Images.cod,
              icon: isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              onTap: () {
                setState(() {
                  isOpen = !isOpen;
                });
              },
              isOpen: isOpen,
              additionalContent:
                  "Due to handling costs a nominal fee of ₹5 will be charged",
              textt:
                  "Due to handling costs a nominal fee of ₹5 will be charged",
              data: "Place Order",
              onPressed: () {
                _handlePlaceOrderButtonPressed();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildModalBottomSheet(BuildContext context) {
    return Container(
      height: 260,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Confirm Cash on Delivery order",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Pay via Cash or UPI when you receive your order",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              Image.asset(
                Images.confirmCash,
                height: 80,
                width: 80,
              ),
            ],
          ),
          const Divider(
            thickness: 2,
            color: Color.fromRGBO(112, 110, 110, 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BottomModalTile(
                text: "Cancel",
                onTap: () {
                  Navigator.of(context).pop();
                },
                isCancel: true,
              ),
              BottomModalTile(
                text: "Confirm Order",
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const OrderSuccessful()));
                },
                isCancel: false,
              )
            ],
          ),
        ],
      ),
    );
  }

  void _handlePlaceOrderButtonPressed() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) => buildModalBottomSheet(context),
    );
  }
}
