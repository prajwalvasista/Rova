import 'dart:io';

import 'package:al_rova/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class ReturnAndRefundPolicy extends StatefulWidget {
  const ReturnAndRefundPolicy({super.key});

  @override
  State<ReturnAndRefundPolicy> createState() => _ReturnAndRefundPolicyState();
}

class _ReturnAndRefundPolicyState extends State<ReturnAndRefundPolicy> {
  final List<Map<String, dynamic>> policySections = [
    {
      'title': 'Return Policy/Refund Policy',
      'content':
          'At ROVA, we try hard to ensure the highest quality and satisfaction for our customers. This Return Policy outlines the conditions under which products purchased from ROVA can be returned and refunded.',
    },
    {
      'title': '1. Order Cancellation and Refusal at Delivery:',
      'points': [
        'Customers who purchase from our app or website are eligible to cancel their orders at any time prior to the dispatch of the products.',
        'Orders can also be refused at the time of delivery. In such cases, the products will be returned to ROVA.',
        'For both cancellations prior to dispatch and refusal at delivery, ROVA will process a full refund of the transaction amount. The refund will be credited to the customer\'s original mode of payment within 7-10 working days from the date of confirmation of cancellation or refusal.',
      ],
    },
    {
      'title': '2. Return of Damaged or Unusable Products:',
      'points': [
        'If a customer receives a product in a damaged or unusable state, they are entitled to return the product.',
        'To initiate a return for damaged products, the customer must provide proof of the damage at the time of delivery. This can include photographs or a short video of the damage.',
        'Upon verification of the damage claim, ROVA will accept the return of the product and initiate a refund process.',
        'The refund for such returns will be processed within 7-10 working days from the date the product is received back at our warehouse, provided it is returned in its original condition, with all packaging and labels intact.',
      ],
    },
    {
      'title': '3. Product Satisfaction Returns:',
      'points': [
        'ROVA may offer a return window for certain products, allowing customers to return products if they do not meet their expectations related to the quality or state of the product.',
        'The specific return window for eligible products will be clearly stated on the product description page.',
        'For products with a stated return window, customers can initiate a return if the product is not as per their liking, provided it is returned in its original condition, with all packaging and labels intact.',
        'Products without a mentioned return window are considered final sales and are not eligible for return based on satisfaction unless received in a damaged state or expired.',
      ],
    },
    {
      'title': '4. Non-Returnable Items:',
      'points': [
        'Certain products may be designated as non-returnable except in cases of damage during delivery. These will be clearly marked as non-returnable on the product description page.',
      ],
    },
    {
      'title': '5. Refund Process:',
      'points': [
        'All refunds will be processed through the same mode of payment used during the purchase.',
        'Refunds will be initiated within 7 working days of the product being received back at our warehouse and passing a quality check for returns based on damage or satisfaction.',
      ],
    },
    {
      'title': '6. Additional Conditions:',
      'points': [
        'ROVA reserves the right to refuse a return or refund if the product is found to have been tampered with or if the damage is due to misuse by the customer.',
      ],
    },
    {
      'title': '7. Refund for Online Transactions Orders:',
      'points': [
        'The payment method, which is used to make the payment (such as credit/ debit card) at the time of purchase, is used for refund. We will send you an email asking you to call us and provide your name and address for security reasons. After we receive these details, a refund will be initiated.',
      ],
    },
    {
      'title': '8. Refund for Cash on Delivery Orders:',
      'points': [
        'For Cash on Delivery orders, refunds will be processed to your bank account (via National Electronic Funds Transfer (NEFT)). If you wish to receive the Cash on Delivery order’s refund to your bank account, you can update the details of the bank account in Your Account to our email id and contact customer care number.',
        'Note: In cases where the products are damaged or the wrong products are shipped we will resend the right product. Please contact us for any information on refund or return options to our email id support@rova.co.in.',
      ],
    },
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
          'Return Policy',
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: policySections.length,
        itemBuilder: (context, index) {
          final section = policySections[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                section['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),
              if (section.containsKey('content'))
                Text(
                  textAlign: TextAlign.justify,
                  section['content'],
                  style: const TextStyle(fontSize: 16),
                ),
              if (section.containsKey('points'))
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (section['points'] as List<String>)
                      .map((point) => _buildBulletPoint(point))
                      .toList(),
                ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Expanded(
            child: Text(
              textAlign: TextAlign.justify,
              text,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
