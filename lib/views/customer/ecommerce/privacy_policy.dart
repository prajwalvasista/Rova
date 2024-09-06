import 'dart:io';

import 'package:al_rova/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  final List<Map<String, dynamic>> privacyPolicy = [
    {
      "title": "Privacy Policy",
      "content":
          "At ROVA, we value your trust and consider your privacy a fundamental right. We are committed to maintaining the trust you place in us by ensuring that your personal information is treated with care and confidentiality. This Privacy Policy outlines how we collect, use and safeguard your information. By using our website and services, you accept the practices described in this Privacy Policy."
    },
    {
      "title": "1.	Changes to Our Privacy Policy:",
      "points": [
        "This policy can change over time. Please review it periodically to stay updated. Any significant changes will be highlighted for your convenience."
      ]
    },
    {
      "title": "2.	Information We Collect:",
      'points': [
        'Personal Information: This includes data you share with us such as your name, email address, phone number, billing address, payment details and any other personal details required during your interaction with our site.',
        'Automated Information: We may automatically collect certain data when you use our websites such as your IP address, browser type and browsing behaviour.'
      ]
    },
    {
      "title": "3.	Usage of Your Information:",
      'points': [
        'Service Delivery: We use your personal information to process orders, deliver products and services, process payments and communicate with you about your orders.',
        'Enhancements: To improve our services, analyse trends and better understand our users\' needs.'
            'Communication: To send you updates, promotions and marketing information based on your preferences.'
      ]
    },
    {
      "title": "4.	Sharing Your Information:",
      'points': [
        'We may share your information with trusted third-party service providers as necessary to provide services to you.',
        'We may disclose your information when required by law or to protect our rights, safety or property.',
        'In case of a merger, acquisition or sale of assets, your information might be transferred to the succeeding entity.'
      ]
    },
    {
      "title": "5.	Protection of Your Information:",
      'points': [
        'We have robust security measures to protect your data from unauthorised access, misuse or disclosure.',
        'Although we strive for 100% security, no system can be entirely immune from external threats. We encourage users to be careful when sharing their personal data.',
      ]
    },
    {
      "title": "6.	Links to Other Sites: ",
      'points': [
        'Our website may contain links to other sites. We are not responsible for the privacy practices or content of these other sites. Always check their privacy policies before providing personal information.',
      ]
    },
    {
      "title": "7.	User Choices:",
      'points': [
        'You have the right to access, modify or delete your personal data stored with us. You can also opt out of receiving marketing communications from us.',
      ]
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
          "Privacy Policy",
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: privacyPolicy.length,
        itemBuilder: (context, index) {
          final privacy = privacyPolicy[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                privacy['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 10),
              if (privacy.containsKey('content'))
                Text(
                  textAlign: TextAlign.justify,
                  privacy['content'],
                  style: const TextStyle(fontSize: 15),
                ),
              if (privacy.containsKey('points'))
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (privacy['points'] as List<String>)
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
          const Text('• ', style: TextStyle(fontSize: 20)),
          Expanded(
            child: Text(
              textAlign: TextAlign.justify,
              text,
              style: const TextStyle(fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}
