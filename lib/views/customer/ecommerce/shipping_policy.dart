import 'dart:io';

import 'package:al_rova/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class ShippingPolicy extends StatefulWidget {
  const ShippingPolicy({super.key});

  @override
  State<ShippingPolicy> createState() => _ShippingPolicyState();
}

class _ShippingPolicyState extends State<ShippingPolicy> {
  final SizedBox defaultGap = const SizedBox(height: 10);
  final List<Map<String, dynamic>> shippingPolicy = [
    {
      'title': 'Shipping (Delivery) Policy',
      'content':
          'At ROVA, your order is our priority. This Shipping Policy outlines our commitment to ensuring that your agricultural needs are met promptly and efficiently.'
    },
    {
      'title': '1. Shipping Time Frame:',
      'details':
          'We endeavour to ship all orders within 2-3 working days. Our goal is to provide you with a seamless shopping experience by processing and dispatching your orders swiftly.'
    },
    {
      'title': '2. Shipping Charges: ',
      'details':
          'We offer both free and paid shipping options for deliveries across India, depending on the order quantity. We aim to provide flexible and affordable shipping solutions to meet your needs.'
    },
    {
      'title': '3. Delivery Timelines: ',
      'details':
          'Typically, our delivery timeline spans 5-7 working days. However, there may be occasions when delays occur due to circumstances beyond our control. We appreciate your patience and understanding in such situations.'
    },
    {
      'title': '4. Unforeseen Delays: ',
      'details':
          'In the event of any unexpected incident impacting our component suppliers, delivery deadlines may be extended. These extensions are only for as long as reasonably necessary. We are dedicated to keeping you informed and ensuring your order reaches you at the earliest possible time.'
    },
    {
      'title': '5. Multiple Items and Stock Availability:',
      'details':
          'For orders containing multiple items or in cases where there is a delay in stock updates, the delivery may take longer. We strive to manage our inventory efficiently to minimize any inconvenience.'
    },
    {
      'title': '6. Legal and Regulatory Compliance: ',
      'details':
          'Our delivery practices adhere to the highest standards of legal and regulatory compliance. We ensure that all products, especially fertilizers and pesticides, are handled, shipped and delivered in accordance with relevant safety and environmental regulations.'
    },
    {
      'title': '7. Customer Service:  ',
      'details':
          'Should you have any queries or concerns regarding your order or our delivery policy, our customer service team is here to assist. We value your business and are committed to providing you with the best service experience. For any questions or support regarding shipping, please contact us at support@rova.co.in or reach us at +91 9108047688/87.',
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
          icon: Icon(
            Platform.isAndroid
                ? Icons.arrow_back_rounded
                : Icons.arrow_back_ios_new_rounded,
            color: AppColors.white,
          ),
        ),
        title: const Text(
          "Shipping Policy",
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: shippingPolicy.length,
        itemBuilder: (context, index) {
          final shipping = shippingPolicy[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shipping['title'],
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              defaultGap,
              if (shipping.containsKey('content'))
                Text(
                  textAlign: TextAlign.justify,
                  shipping['content'],
                  style: const TextStyle(fontSize: 18),
                ),
              defaultGap,
              if (shipping.containsKey('details'))
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildDetails(shipping['details']),
                ),
              defaultGap,
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildDetails(dynamic details) {
    if (details is String) {
      return [_buildBulletPoint(details)];
    } else if (details is List) {
      return details
          .map<Widget>((detail) => _buildBulletPoint(detail.toString()))
          .toList();
    } else {
      return [
        const Text('Invalid details format'),
      ];
    }
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(fontSize: 20),
        ),
        Expanded(
          child: Text(
            textAlign: TextAlign.justify,
            text,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
