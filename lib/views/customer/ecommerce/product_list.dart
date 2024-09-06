import 'dart:convert';
import 'dart:io';

import 'package:al_rova/common/function/general_function.dart';
import 'package:al_rova/common/widget/spinkit_indicator.dart';
import 'package:al_rova/cubit/customer/product_cubit/product_cubit.dart';
import 'package:al_rova/cubit/customer/product_cubit/product_state.dart';
import 'package:al_rova/di.dart';
import 'package:al_rova/models/auth/verify_otp_model.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/services/local_storage.dart';
import 'package:al_rova/utils/widgets/best_deals_item.dart';
import 'package:al_rova/utils/widgets/common_search_box.dart';
import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
import 'package:al_rova/views/customer/ecommerce/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductList extends StatefulWidget {
  bool isBestDeal;
  // List<GetAllProductModel>? getAllProductModel;
  ProductList({super.key, required this.isBestDeal});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  TextEditingController searchEditingController = TextEditingController();
  VerifyOtpModel? userModel;
  final localStorage = getIt<MySharedPref>();
  @override
  void initState() {
    var rawData = localStorage.getUserData();
    if (rawData != null && rawData != "") {
      var userData = jsonDecode(rawData);

      userModel = VerifyOtpModel.fromJson(userData);
    }
    if (widget.isBestDeal) {
      context
          .read<CustomerProductCubit>()
          .fetchAllProduct(userModel!.response!.roleId!);
    }
    super.initState();
  }

  @override
  void dispose() {
    searchEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.primary,
        toolbarHeight: 0,
      ),
      body: BlocConsumer<CustomerProductCubit, ProductState>(
        listener: (context, state) {
          if (state is SuccessState) {
            showCustomToast(context, state.successResponse.message!, false);
            context
                .read<CustomerProductCubit>()
                .fetchAllProduct(userModel!.response!.roleId!);
          }
        },
        builder: (context, state) {
          if (state is ProductLoadingState) {
            return const SpinKitIndicator(
              type: SpinKitType.circle,
            );
          }
          if (state is GetProductSuccessState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(8.0),
                  color: AppColors.primary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Icon(Platform.isAndroid
                              ? Icons.arrow_back_rounded
                              : Icons.arrow_back_ios_rounded),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CommonSearchBox(
                          textEditingController: searchEditingController,
                          fillColor: AppColors.white,
                          filled: true,
                          isSuffix: false,
                          hintText: 'Search Product',
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: widget.isBestDeal
                          ? state.getAllProductModel.length
                          : 10,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: widget.isBestDeal ? 2 : 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.75),
                      itemBuilder: (BuildContext context, int index) {
                        double percentageValue = widget.isBestDeal
                            ? GernalFunction.calculatePercentage(
                                state.getAllProductModel[index].details!.single
                                    .salePrice!
                                    .toDouble(),
                                state.getAllProductModel[index].details!.single
                                    .price!
                                    .toDouble())
                            : 0.0;
                        return BestDealsItem(
                            isSeller: false,
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => CustomerProductCubit(
                                      customerProductRepository: getIt()),
                                  child: ProductDetails(
                                    customerId: userModel!.response!.roleId!,
                                    productId: state
                                        .getAllProductModel[index].productId!,
                                  ),
                                ),
                              ))
                                  .then((value) {
                                context
                                    .read<CustomerProductCubit>()
                                    .fetchAllProduct(
                                        userModel!.response!.roleId!);
                              });
                            },
                            productTitle: state.getAllProductModel[index].name,
                            productPrice: state.getAllProductModel[index]
                                .details?.single.price!
                                .toString(),
                            productSalePrice: state.getAllProductModel[index]
                                .details?.single.salePrice!
                                .toString(),
                            productSize: state
                                .getAllProductModel[index].details?.single.size!
                                .toString(),
                            productType: state.getAllProductModel[index].details
                                ?.single.type!,
                            productImage:
                                state.getAllProductModel[index].images![0],
                            percentageOff: percentageValue.toStringAsFixed(0),
                            isWishList:
                                state.getAllProductModel[index].isWishList,
                            onAddToWishlistClick: () {
                              if (state.getAllProductModel[index].isWishList ==
                                  false) {
                                Map<String, dynamic> params =
                                    <String, dynamic>{};
                                params = {
                                  "productId":
                                      state.getAllProductModel[index].productId,
                                  "customerId": userModel!.response!.roleId!,
                                  // "sellerId":
                                  //     state.getAllProductModel[index].sellerId,
                                };
                                context
                                    .read<CustomerProductCubit>()
                                    .addProductToWishlist(params);
                              } else {}
                            });
                      },
                    ),
                  ),
                )
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
