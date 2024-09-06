import 'dart:convert';

import 'package:al_rova/common/widget/empty_widget.dart';
import 'package:al_rova/common/widget/spinkit_indicator.dart';
import 'package:al_rova/cubit/seller/product_cubit/product_cubit.dart';
import 'package:al_rova/cubit/seller/product_cubit/product_state.dart';
import 'package:al_rova/di.dart';
import 'package:al_rova/models/auth/verify_otp_model.dart';
import 'package:al_rova/utils/constants/app_style.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:al_rova/utils/services/local_storage.dart';
import 'package:al_rova/utils/widgets/common_button.dart';
import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  VerifyOtpModel? userModel;
  final localStorage = getIt<MySharedPref>();

  @override
  void initState() {
    var rawData = localStorage.getUserData();
    if (rawData != null && rawData != "") {
      var userData = jsonDecode(rawData);

      userModel = VerifyOtpModel.fromJson(userData);
    }

    context.read<ProductCubit>().getAllOrderList(userModel!.response!.roleId!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: Text(
          'Order List',
          style: headLine2.copyWith(color: AppColors.white),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state is ProductErrorState) {
            showCustomToast(context, state.message, true);
            //Navigator.of(context).pop();
          }
          if (state is SuccessState) {
            showCustomToast(context, state.successResponse.message!, false);
            //Navigator.of(context).pop();
            context
                .read<ProductCubit>()
                .getAllOrderList(userModel!.response!.roleId!);
          }
        },
        builder: (context, state) {
          if (state is ProductLoadingState) {
            return const SpinKitIndicator(
              type: SpinKitType.circle,
            );
          }

          if (state is OrderListSuccessState && state.orderListModel.isEmpty) {
            return const EmptyWidget(message: "No product found.");
          }
          if (state is OrderListSuccessState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemCount: state.orderListModel.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final order = state.orderListModel[index];
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: AppColors.lightGary),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(
                                  'https://developement_rovo.acelucid.com/${state.orderListModel[index].images![0]}',
                                  width: 60,
                                  height: 85,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      Images.product,
                                      width: 48,
                                      height: 85,
                                    );
                                  },
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.orderListModel[index].name!,
                                        style: headLine5.copyWith(fontSize: 15),
                                      ),
                                      Text(
                                        '₹ ${state.orderListModel[index].details!.single.salePrice!}',
                                        style: headLine5.copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: '',
                                          children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    '₹ ${state.orderListModel[index].details!.single.price!}',
                                                style: headLine6.copyWith(
                                                    color:
                                                        const Color(0xff1B1C1E),
                                                    decoration: TextDecoration
                                                        .lineThrough)),
                                            TextSpan(
                                                text: '',
                                                style: headLine6.copyWith(
                                                    color:
                                                        const Color(0xff2382AA),
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'Size ${state.orderListModel[index].details!.single.size!} ${state.orderListModel[index].details!.single.type!}',
                                        softWrap: true,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: headLine5.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        order.orderDecision == "Accepted" ||
                                order.orderDecision == "Rejected"
                            ? Text(
                                order.orderDecision == "Accepted"
                                    ? 'Accepted product'
                                    : "Rejected product",
                                style:
                                    headLine4.copyWith(color: AppColors.gary),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CommonButton(
                                      onPressed: () {
                                        FormData params = FormData.fromMap({
                                          "OrderId": order.orderId,
                                          "CustomerId": order.customerId,
                                          "ProductId": order.productId,
                                          "OrderDecision": 1,
                                          "Comments": "",
                                        });
                                        context
                                            .read<ProductCubit>()
                                            .approveOrder(params);
                                      },
                                      buttonText: 'Accept',
                                      buttonColor: AppColors.primary,
                                      buttonTextColor: AppColors.white),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  CommonButton(
                                    onPressed: () {
                                      FormData params = FormData.fromMap({
                                        "OrderId": order.orderId,
                                        "CustomerId": order.customerId,
                                        "ProductId": order.productId,
                                        "OrderDecision": 2,
                                        "Comments": "Product rejected",
                                      });
                                      context
                                          .read<ProductCubit>()
                                          .approveOrder(params);
                                    },
                                    buttonText: 'Reject',
                                    buttonColor: Colors.red,
                                    buttonTextColor: AppColors.white,
                                  ),
                                ],
                              )
                            
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 15,
                  );
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
