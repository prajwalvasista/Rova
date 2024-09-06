import 'dart:convert';
import 'dart:io';

import 'package:al_rova/common/widget/spinkit_indicator.dart';
import 'package:al_rova/cubit/coupons/get_coupons_cubit.dart';
import 'package:al_rova/cubit/coupons/get_coupons_state.dart';
import 'package:al_rova/di.dart';
import 'package:al_rova/models/auth/verify_otp_model.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:al_rova/utils/services/local_storage.dart';
import 'package:al_rova/utils/widgets/common_search_box.dart';
import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
import 'package:al_rova/views/customer/cart/cart.dart';
import 'package:al_rova/views/customer/cart/coupon_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class Coupons extends StatefulWidget {
  double totalAmount;

  Coupons({
    super.key,
    required this.totalAmount,
  });

  @override
  State<Coupons> createState() => _CouponsState();
}

class _CouponsState extends State<Coupons> {
  TextEditingController searchEditingController = TextEditingController();
  VerifyOtpModel? userModel;
  final localStorage = getIt<MySharedPref>();

  // int appliedCouponId = 0;

  @override
  void initState() {
    var rawData = localStorage.getUserData();

    if (rawData != null && rawData != "") {
      var userData = jsonDecode(rawData);

      userModel = VerifyOtpModel.fromJson(userData);
    }
    context
        .read<GetCouponsCubit>()
        .getAllCoupons(widget.totalAmount, userModel!.response!.roleId!);
    super.initState();
  }

  void _showApplyDialog(BuildContext context, String code, int couponId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: BlocConsumer<GetCouponsCubit, GetCouponsState>(
                  listener: (context, state) {
                    if (state is ApplyCouponSuccess) {
                      showCustomToast(context,
                          state.applyCouponModel.message! ?? "", false);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => Cart(
                                couponId: couponId,
                                appliedCouponId: state
                                    .applyCouponModel.data?.appliedCouponId,
                                isBack: true,
                              )));
                    }
                  },
                  builder: (context, state) {
                    if (state is GetCouponLoading) {
                      return const SpinKitIndicator(
                        type: SpinKitType.circle,
                      );
                    }
                    if (state is GetCouponError) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showCustomToast(context, state.message, true);
                      });
                    }
                    if (state is ApplyCouponSuccess) {}
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        Image.asset(Images.discount),
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Your Coupon ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: code,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                              const TextSpan(
                                text: ' Applied',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '*Actual savings will reflect in checkout\nsubject to conditions.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            context.read<GetCouponsCubit>().applyCoupons(
                                couponId, userModel!.response!.roleId!);
                          },
                          child: Container(
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.primary),
                            child: const Center(
                              child: Text(
                                "OK",
                                style: TextStyle(
                                    color: AppColors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          "Coupons",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Platform.isAndroid
                ? Icons.arrow_back_rounded
                : Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CommonSearchBox(
                    textEditingController: searchEditingController,
                    fillColor: AppColors.white,
                    filled: false,
                    isSuffix: false,
                    hintText: "Enter Coupon Code",
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: AppColors.primary,
                    ),
                    child: const Center(
                      child: Text(
                        "Apply",
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: BlocBuilder<GetCouponsCubit, GetCouponsState>(
                builder: (context, state) {
                  if (state is GetCouponLoading) {
                    return const SpinKitIndicator(
                      type: SpinKitType.circle,
                    );
                  }
                  if (state is GetCouponError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showCustomToast(context, state.message, true);
                    });
                  }
                  if (state is GetCouponSuccess) {
                    return ListView.builder(
                        itemCount: state.couponModel.length,
                        itemBuilder: (context, index) {
                          return CouponTile(
                            code: state.couponModel[index].coupon.toString(),
                            minPurchase: state.couponModel[index].price!,
                            validity:
                                state.couponModel[index].expiryDate.toString(),
                            isActive: state.couponModel[index].isCouponActive!,
                            onApply: () {
                              _showApplyDialog(
                                  context,
                                  state.couponModel[index].coupon.toString(),
                                  state.couponModel[index].couponId!);
                            },
                          );
                        });
                  }
                  return const SizedBox();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
