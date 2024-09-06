import 'dart:io';

import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/strings.dart';
import 'package:al_rova/views/customer/ecommerce/common_inkwell.dart';
import 'package:al_rova/views/customer/ecommerce/faq.dart';
import 'package:al_rova/views/customer/ecommerce/privacy_policy.dart';
import 'package:al_rova/views/customer/ecommerce/shipping_policy.dart';
import 'package:al_rova/views/customer/return_and_refund_policy.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpGuide extends StatefulWidget {
  const HelpGuide({super.key});

  @override
  State<HelpGuide> createState() => _HelpGuideState();
}

class _HelpGuideState extends State<HelpGuide> {
  final SizedBox defaultGap = const SizedBox(height: 20);

  _launchURLBrowser() async {
    var url = Uri.parse("https://rova.acelucid.com/terms_condition.html");
    await launchUrl(url);
  }

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
          "Help Guide",
          style: TextStyle(
            color: AppColors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Card(
            elevation: 2,
            child: Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CommonInkwell(
                    text: AppStrings.privacyPolicy,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPolicy(),
                        ),
                      );
                    },
                  ),
                  defaultGap,
                  CommonInkwell(
                    text: AppStrings.termsCondition,
                    onTap: () {
                      _launchURLBrowser();
                    },
                  ),
                  defaultGap,
                  CommonInkwell(
                    text: AppStrings.returnAndRefundPolicy,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ReturnAndRefundPolicy()));
                    },
                  ),
                  defaultGap,
                  CommonInkwell(
                    text: AppStrings.shippingPolicy,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ShippingPolicy(),
                        ),
                      );
                    },
                  ),
                  defaultGap,
                  CommonInkwell(
                    text: AppStrings.faq,
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const Faq()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
