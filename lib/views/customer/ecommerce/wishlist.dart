import 'dart:convert';
import 'package:al_rova/common/function/general_function.dart';
import 'package:al_rova/common/widget/empty_widget.dart';
import 'package:al_rova/common/widget/spinkit_indicator.dart';
import 'package:al_rova/cubit/customer/product_cubit/product_cubit.dart';
import 'package:al_rova/cubit/customer/product_cubit/product_state.dart';
import 'package:al_rova/di.dart';
import 'package:al_rova/models/auth/verify_otp_model.dart';
import 'package:al_rova/utils/constants/app_style.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/services/local_storage.dart';
import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
import 'package:al_rova/utils/widgets/wishlist_card.dart';
import 'package:al_rova/views/customer/ecommerce/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
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
    context
        .read<CustomerProductCubit>()
        .getAllWishlistProduct(userModel!.response!.roleId!);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('BuildContext===> $context');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: Text(
          'Wishlist',
          style: headLine2.copyWith(color: AppColors.white, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<CustomerProductCubit, ProductState>(
        listener: (context, state) {
          if (state is SuccessState) {
            showCustomToast(context, state.successResponse.message!, false);
            context
                .read<CustomerProductCubit>()
                .getAllWishlistProduct(userModel!.response!.roleId!);
          }
          if (state is AddEditDeleteProductToCartSuccessState) {
            if (state.addEditDeleteProductToCartModel.success!) {
              showCustomToast(context,
                  state.addEditDeleteProductToCartModel.response!, false);
              context
                  .read<CustomerProductCubit>()
                  .getAllWishlistProduct(userModel!.response!.roleId!);
            } else {
              showCustomToast(context,
                  state.addEditDeleteProductToCartModel.errorMessage!, true);
              context
                  .read<CustomerProductCubit>()
                  .getAllWishlistProduct(userModel!.response!.roleId!);
            }
          }
        },
        builder: (context, state) {
          if (state is ProductLoadingState) {
            return const SpinKitIndicator(
              type: SpinKitType.circle,
            );
          }
          if (state is GetWishlistProductSuccessState &&
              state.getAllWishlistProductModel.isEmpty) {
            return const EmptyWidget(message: "Your wishlist is empty.");
          }

          if (state is GetWishlistProductSuccessState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: state.getAllWishlistProductModel.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.75),
                itemBuilder: (BuildContext context, int index) {
                  double percentageValue = GernalFunction.calculatePercentage(
                      state.getAllWishlistProductModel[index].details!.single
                          .salePrice!
                          .toDouble(),
                      state.getAllWishlistProductModel[index].details!.single
                          .price!
                          .toDouble());
                  return WishListCard(
                    productTitle: state.getAllWishlistProductModel[index].name,
                    productPrice: state.getAllWishlistProductModel[index]
                        .details?.single.price!
                        .toString(),
                    productSalePrice: state.getAllWishlistProductModel[index]
                        .details?.single.salePrice!
                        .toString(),
                    productSize: state
                        .getAllWishlistProductModel[index].details?.single.size!
                        .toString(),
                    productType: state.getAllWishlistProductModel[index].details
                        ?.single.type!,
                    productImage:
                        state.getAllWishlistProductModel[index].images![0],
                    percentageOff: percentageValue.toStringAsFixed(0),
                    onAddtoCartClick: () {
                      Map<String, dynamic> params = <String, dynamic>{};
                      params = {
                        "productId":
                            state.getAllWishlistProductModel[index].productId,
                        "customerId": userModel!.response!.roleId!,
                        "quantity": 1,
                      };
                      context
                          .read<CustomerProductCubit>()
                          .addProductToCart(params);
                    },
                    onRemovetoWishlist: () {
                      context
                          .read<CustomerProductCubit>()
                          .deleteProductFromWishlist(
                              userModel!.response!.roleId!,
                              state.getAllWishlistProductModel[index]
                                  .productId!);
                    },
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => CustomerProductCubit(
                            customerProductRepository: getIt(),
                          ),
                          child: ProductDetails(
                            customerId: userModel!.response!.roleId!,
                            productId: state
                                .getAllWishlistProductModel[index].productId!,
                          ),
                        ),
                      ))
                          .then((value) {
                        context
                            .read<CustomerProductCubit>()
                            .getAllWishlistProduct(
                                userModel!.response!.roleId!);
                      });
                    },
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
