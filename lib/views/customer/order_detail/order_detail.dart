import 'dart:convert';
import 'dart:io';
import 'package:al_rova/common/widget/spinkit_indicator.dart';
import 'package:al_rova/cubit/customer/product_cubit/product_cubit.dart';
import 'package:al_rova/cubit/customer/product_cubit/product_state.dart';
import 'package:al_rova/di.dart';
import 'package:al_rova/models/auth/verify_otp_model.dart';
import 'package:al_rova/utils/constants/app_style.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/fonts.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:al_rova/utils/constants/strings.dart';
import 'package:al_rova/utils/services/local_storage.dart';
import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class OrderDetails extends StatefulWidget {
  String orderId;
  OrderDetails({super.key, required this.orderId});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final SizedBox defaultSize = const SizedBox(height: 10);

  VerifyOtpModel? userModel;
  final localStorage = getIt<MySharedPref>();

  @override
  void initState() {
    super.initState();
    var rawData = localStorage.getUserData();
    if (rawData != null && rawData != "") {
      var userData = jsonDecode(rawData);

      userModel = VerifyOtpModel.fromJson(userData);
    }

    context.read<CustomerProductCubit>().getOrdersByOrderIdAndCustomerId(
        userModel!.response!.roleId!, widget.orderId);
  }

  int index = 0;
  List<String> activityItems = [
    "Go to shopping store",
    "Shipping Expected by 20 Mar",
    "Out for Delivery",
    "Delivered"
  ];

  void _showCancelConfirmation(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirm Cancellation!"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    showCustomToast(context,
                        "Order has been cancelled successfully.", false);
                  },
                  child: const Text("Ok"))
            ],
          );
        });
  }

  void _showReturnConfirmation(String message) {
    showDialog(
        context: context,
        builder: (BuildContext contect) {
          return AlertDialog(
            title: const Text("Confirm return"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    showCustomToast(
                        context, "Return request has been initiated.", false);
                  },
                  child: const Text("Ok"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
            color: AppColors.black,
          ),
        ),
        title: const Text(
          AppStrings.orderDetails,
          style: TextStyle(
            fontSize: 24,
            color: AppColors.black,
          ),
        ),
      ),
      body: BlocBuilder<CustomerProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoadingState) {
            return const SpinKitIndicator(
              type: SpinKitType.circle,
            );
          }
          if (state is GetOrderByOrderIdAndCustomerIdSuccess) {
            return SingleChildScrollView(
              child: SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    // const Divider(
                    //   thickness: 5,
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        state.getOrderedProductForCustomerModel.orderId!,
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.getOrderedProductForCustomerModel.name!,
                                  style: headLine2.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                                defaultSize,
                                Text(
                                  state.getOrderedProductForCustomerModel
                                      .storeName!,
                                  style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                defaultSize,
                                Text(
                                  state.getOrderedProductForCustomerModel
                                      .details![index].price
                                      .toString(),
                                  style: headLine2.copyWith(
                                      fontFamily: Fonts.dmSansSemiBold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Image.network(
                            'https://developement_rovo.acelucid.com${state.getOrderedProductForCustomerModel.images![0]}',
                            height: 86,
                            width: 48,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                Images.product,
                                height: 86,
                                width: 48,
                                fit: BoxFit.contain,
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 50,
                                    // width:
                                    //     MediaQuery.of(context).size.width * 80 / 100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 25,
                                          width: 25,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.green,
                                          ),
                                          child: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      // width: MediaQuery.of(context).size.width *
                                      //     80 /
                                      //     100,
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      _activityItems(activityItems[index]),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                    ],
                                  ))
                                ]);
                          },
                          itemCount: activityItems.length,
                        )),

                    const Divider(
                      thickness: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ContainerTile(
                          text: "Cancel Order",
                          onTap: () {
                            _showCancelConfirmation(
                                "Are you sure want to cancel this order");
                          },
                          color: Colors.red,
                        ),
                        Container(
                          width: 1,
                          height: 50,
                          color: Colors.black,
                        ),
                        ContainerTile(
                          text: "Return",
                          color: AppColors.primary,
                          onTap: () {
                            _showReturnConfirmation(
                                "Are you sure want to return this order");
                          },
                        )
                      ],
                    ),
                    const Divider(
                      thickness: 4,
                    ),
                    defaultSize,
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        AppStrings.shippingDetails,
                        style: headLine3.copyWith(
                            color: const Color(0xff979797),
                            fontSize: 14,
                            fontFamily: Fonts.dmSansRegular,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        AppStrings.name1,
                        style: headLine1.copyWith(
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff1B1C1E)),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(AppStrings.multiLineString),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _activityItems(String title) {
    // return ListTile(
    // tileColor: Colors.green,
    // title:
    return Text(
      title,
      style: const TextStyle(fontSize: 16),
    );
    // subtitle: const Text("10:00"),
    // );
  }
}

class ContainerTile extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final Color color;
  const ContainerTile(
      {super.key, this.onTap, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 190,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                fontSize: 23,
                color: AppColors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
