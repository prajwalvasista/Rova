import 'dart:io';

import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/views/customer/ecommerce/faq_item.dart';
import 'package:flutter/material.dart';

class Faq extends StatefulWidget {
  const Faq({super.key});

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  final List<Map<String, dynamic>> faqs = [
    {
      'question': '1. What is ROVA?',
      'answer':
          'ROVA is an e-commerce application designed to help you shop for agricultural products efficiently and conveniently. We offer a wide range of products including seeds, fertilizers, pesticides, and farming equipment.',
    },
    {
      'question': '2. How do I create an account on ROVA? ',
      'answer':
          'To create an account, download the ROVA app, open it, and click on the "Register" button. Fill in the required details such as your name, email address, and phone number, then create a password. Follow the prompts to complete the registration process.',
    },
    {
      'question': '3. How do I place an order? ',
      'answer':
          'After logging in, browse through the categories or use the search bar to find the products you need. Add the desired items to your cart, proceed to checkout, and enter your shipping details. Choose your preferred payment method and confirm your order.',
    },
    {
      'question': '4. What payment methods are accepted? ',
      'answer':
          'We accept various payment methods including credit cards, debit cards, upi payment and cash on delivery (COD).',
    },
    {
      'question': '5. Can I cancel my order? ',
      'answer':
          'Yes, you can cancel your order before it is dispatched. To cancel, go to "My Orders," select the order you wish to cancel, and click on the "Cancel Order" button. If the order has already been dispatched, cancellation is not possible.',
    },
    {
      'question': '6. How can I track my order? ',
      'answer':
          'After placing an order, you will receive a confirmation email with a tracking number. Use this number on our website or app in the "Track Order" section to monitor the status of your shipment.',
    },
    {
      'question': '7. What is the return policy? ',
      'answer':
          'Our return policy allows you to return damaged or incorrect products. You must provide proof of damage (e.g. photographs) to initiate the return process. For detailed information, please refer to our Return Policy section in the app.',
    },
    {
      'question': '8. Are there any shipping charges? ',
      'answer':
          'We offer both free and paid shipping options depending on the order quantity and delivery location. Shipping charges, if any, will be clearly displayed at checkout.',
    },
    {
      'question': '9. How long does delivery take? ',
      'answer':
          'Typically, delivery takes 5-7 working days from the date of dispatch. However, delivery times may vary based on your location and other factors. We aim to process and ship orders within 2-3 working days.',
    },
    {
      'question': '10. Do you offer discounts or promotions?  ',
      'answer':
          'Yes, we frequently offer discounts and promotions. Keep an eye on our app and subscribe to our newsletter to stay updated on the latest offers.',
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Platform.isAndroid
              ? Icons.arrow_back_rounded
              : Icons.arrow_back_ios_new_rounded),
          color: AppColors.white,
        ),
        title: const Text(
          "Frequently Asked Questions",
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return FaqItem(
            question: faq['question'],
            answer: faq['answer'],
          );
        },
      ),
    );
  }
}
