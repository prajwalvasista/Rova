import 'dart:convert';
import 'dart:io';
import 'package:al_rova/common/function/general_function.dart';
import 'package:al_rova/common/widget/empty_widget.dart';
import 'package:al_rova/common/widget/spinkit_indicator.dart';
import 'package:al_rova/cubit/coupons/get_coupons_cubit.dart';
import 'package:al_rova/cubit/coupons/get_coupons_state.dart';
import 'package:al_rova/cubit/customer/address_cubit/address_cubit.dart';
import 'package:al_rova/cubit/customer/address_cubit/address_state.dart';
import 'package:al_rova/cubit/customer/product_cubit/product_cubit.dart';
import 'package:al_rova/cubit/customer/product_cubit/product_state.dart';
import 'package:al_rova/di.dart';
import 'package:al_rova/models/auth/verify_otp_model.dart';
import 'package:al_rova/models/customer/address/address_response_model.dart';
import 'package:al_rova/utils/constants/app_style.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/fonts.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:al_rova/utils/services/local_storage.dart';
import 'package:al_rova/utils/widgets/common_button.dart';
import 'package:al_rova/utils/widgets/common_dotted_line.dart';
import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
import 'package:al_rova/views/customer/address/choose_address.dart';
import 'package:al_rova/views/customer/cart/coupons.dart';
import 'package:al_rova/views/customer/cart/procced_to_checkout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Cart extends StatefulWidget {
  int? couponId;
  int? appliedCouponId;
  bool isBack;
  Cart({super.key, this.couponId, this.appliedCouponId, required this.isBack});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool isCouponApplied = false;
  int appliedCouponAmount = 0;
  VerifyOtpModel? userModel;
  AddressResponseModel? addressModel;
  final localStorage = getIt<MySharedPref>();

  double totalSaleAmount = 0.0, totalAmount = 0.0;
  int productCount = 0;

  @override
  void initState() {
    // for user data
    var rawData = localStorage.getUserData();
    if (rawData != null && rawData != "") {
      var userData = jsonDecode(rawData);

      userModel = VerifyOtpModel.fromJson(userData);
    }

    context
        .read<CustomerProductCubit>()
        .viewProductInCart(userModel!.response!.roleId!);

    context
        .read<AddressCubit>()
        .getChoosedAddressByCustomer(userModel!.response!.roleId!);

    if (widget.isBack) {
      context.read<GetCouponsCubit>().getAppliedCouponsForCustomer(
          userModel!.response!.roleId!, widget.appliedCouponId!);
    }

    super.initState();
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
            )),
        title: Text(
          'Cart',
          style: headLine2.copyWith(color: AppColors.white, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<AddressCubit, AddressState>(
                builder: (context, state) {
                  if (state is AddressLoadingState) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ));
                  }
                  if (state is AddressSuccessState &&
                      state.addressResponseModel.isEmpty) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) =>
                                AddressCubit(addressRepository: getIt()),
                            child: const ChooseAddress(),
                          ),
                        ))
                            .then((value) {
                          context
                              .read<AddressCubit>()
                              .getChoosedAddressByCustomer(
                                  userModel!.response!.roleId!);
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            border: Border.all(
                                width: 1, color: AppColors.lightGary),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.add_location_rounded),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Choose Address',
                                  style: headLine2.copyWith(
                                      color: AppColors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (state is AddressSuccessState &&
                      state.addressResponseModel.isNotEmpty) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color(0xffC9C9C9), width: 1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Deliver to:',
                                style: headLine2.copyWith(fontSize: 18),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (context) => AddressCubit(
                                          addressRepository: getIt(),
                                        ),
                                        child: const ChooseAddress(),
                                      ),
                                    ))
                                        .then((value) {
                                      context
                                          .read<AddressCubit>()
                                          .getChoosedAddressByCustomer(
                                              userModel!.response!.roleId!);
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xff98FF8F),
                                  ),
                                  child: Text(
                                    'Change',
                                    style: headLine5.copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                state.addressResponseModel.first.name!,
                                style: headLine2.copyWith(
                                    fontFamily: Fonts.dmSansSemiBold),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    color: AppColors.lightGary,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                    child: Text(
                                  '${state.addressResponseModel.single.saveAddressAs}' ==
                                          '1'
                                      ? 'HOME'
                                      : 'WORK',
                                  style: headLine6.copyWith(
                                      color: AppColors.black),
                                )),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${state.addressResponseModel.single.areaColony}, ${state.addressResponseModel.single.buildingName} , ${state.addressResponseModel.single.city}, ${state.addressResponseModel.single.state}, ${state.addressResponseModel.single.state}, ${state.addressResponseModel.single.zipcode}, ${state.addressResponseModel.single.country}',
                            style: headLine5.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            state.addressResponseModel.first.phoneNumber!,
                            style: headLine4.copyWith(color: AppColors.gary),
                          )
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            BlocConsumer<CustomerProductCubit, ProductState>(
              listener: (context, state) {
                if (state is ViewProductInCartSuccessState) {
                  totalSaleAmount = state.getAllCartProduct
                      .fold(0, (p, c) => p + ((c.salePrice!) * (c.quantity!)));
                  totalAmount = state.getAllCartProduct
                      .fold(0, (p, c) => p + ((c.price!) * (c.quantity!)));

                  setState(() {});
                }
                if (state is AddEditDeleteProductToCartSuccessState) {
                  context
                      .read<CustomerProductCubit>()
                      .viewProductInCart(userModel!.response!.roleId!);
                }
              },
              builder: (context, state) {
                if (state is ProductLoadingState) {
                  return const SpinKitIndicator(
                    type: SpinKitType.circle,
                  );
                }

                if (state is ViewProductInCartSuccessState &&
                    state.getAllCartProduct.isEmpty) {
                  return const EmptyWidget(message: "Your cart is empty.");
                }

                if (state is ViewProductInCartSuccessState) {
                  return Column(
                    children: [
                      // cart list ui builder
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.getAllCartProduct.length,
                        itemBuilder: (context, index) {
                          double percentageValue =
                              GernalFunction.calculatePercentage(
                                  state.getAllCartProduct[index].salePrice!
                                      .toDouble(),
                                  state.getAllCartProduct[index].price!
                                      .toDouble());

                          //                WidgetsBinding.instance.addPostFrameCallback((_) {
                          //   setState(() {
                          //     productCount =
                          //                   state.getAllCartProduct[index].quantity!;
                          //   });
                          // });
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: const Color(0xffC9C9C9),
                                      width: 1)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 90,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: const Color(0xffC9C9C9),
                                                width: 1)),
                                        child: Image.network(
                                          'https://developement_rovo.acelucid.com/${state.getAllCartProduct[index].images![0]}',
                                          width: 48,
                                          height: 85,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              Images.product,
                                              width: 48,
                                              height: 85,
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.getAllCartProduct[index]
                                                  .name!,
                                              style: headLine5.copyWith(
                                                color: const Color(0xff1B1C1E),
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: '',
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text:
                                                          '₹ ${state.getAllCartProduct[index].price!.toStringAsFixed(0)}',
                                                      style: headLine6.copyWith(
                                                          color: const Color(
                                                              0xff1B1C1E),
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          fontSize: 16)),
                                                  const TextSpan(
                                                      text: '  ',
                                                      style: headLine4),
                                                  TextSpan(
                                                      text:
                                                          '${percentageValue.toStringAsFixed(0)}% Off',
                                                      style: headLine4.copyWith(
                                                          color: const Color(
                                                              0xff2382AA),
                                                          fontSize: 13)),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              '₹ ${state.getAllCartProduct[index].salePrice!.toStringAsFixed(0)}',
                                              style: headLine5.copyWith(
                                                color: const Color(0xff1B1C1E),
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              'Size ${state.getAllCartProduct[index].size}ml',
                                              style: headLine5.copyWith(
                                                color: const Color(0xff1B1C1E),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        width: 100,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              width: 1,
                                              color: AppColors.primary),
                                        ),
                                        child: Row(
                                          children: [
                                            state.getAllCartProduct[index]
                                                        .quantity! ==
                                                    1
                                                ? InkWell(
                                                    onTap: () {
                                                      context
                                                          .read<
                                                              CustomerProductCubit>()
                                                          .deleteProductFromCart(
                                                              userModel!
                                                                      .response!
                                                                      .roleId ??
                                                                  "",
                                                              state
                                                                  .getAllCartProduct[
                                                                      index]
                                                                  .productId!);
                                                    },
                                                    child: const Icon(
                                                      Icons.delete_rounded,
                                                      color: Colors.red,
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      Map<String, dynamic>
                                                          params =
                                                          <String, dynamic>{};
                                                      params = {
                                                        "productId": state
                                                            .getAllCartProduct[
                                                                index]
                                                            .productId,
                                                        "customerId": userModel!
                                                            .response!.roleId!,
                                                        "quantity": state
                                                                .getAllCartProduct[
                                                                    index]
                                                                .quantity! -
                                                            1,
                                                      };
                                                      context
                                                          .read<
                                                              CustomerProductCubit>()
                                                          .updateProductInCart(
                                                              params);
                                                    },
                                                    child: const Icon(
                                                      Icons.remove,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Center(
                                              child: Container(
                                                width: 30,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                color: AppColors.primary,
                                                child: Center(
                                                  child: Text(
                                                    state
                                                        .getAllCartProduct[
                                                            index]
                                                        .quantity!
                                                        .toString(),
                                                    style: headLine4.copyWith(
                                                        color: AppColors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Map<String, dynamic> params =
                                                    <String, dynamic>{};
                                                params = {
                                                  "productId": state
                                                      .getAllCartProduct[index]
                                                      .productId,
                                                  "customerId": userModel!
                                                      .response!.roleId!,
                                                  "quantity": state
                                                          .getAllCartProduct[
                                                              index]
                                                          .quantity! +
                                                      1,
                                                };
                                                context
                                                    .read<
                                                        CustomerProductCubit>()
                                                    .updateProductInCart(
                                                        params);
                                              },
                                              child: const Icon(
                                                Icons.add_rounded,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Delivery by',
                                        style: headLine5,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: '30 Mar 2024',
                                            style: headLine2.copyWith(
                                                fontSize: 16,
                                                color: AppColors.primary),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => GetCouponsCubit(
                                  getCouponsRepo: getIt(),
                                ),
                                child: Coupons(
                                  totalAmount: totalAmount,
                                ),
                              ),
                            ));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: const Color(0xffC9C9C9), width: 1)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Offers',
                                  style: headLine2.copyWith(fontSize: 22),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      Images.discount,
                                      width: 42,
                                      height: 42,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Apply Coupons',
                                            style: headLine2.copyWith(
                                                fontSize: 18),
                                          ),
                                          Text(
                                            'Checkout Offers and coupons',
                                            style: headLine2.copyWith(
                                                fontSize: 16,
                                                color: const Color(0xff3D3D3D),
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Text('no cart data');
                }
              },
            ),

            // amount summary ui
            totalAmount > 0.0
                ? BlocConsumer<GetCouponsCubit, GetCouponsState>(
                    listener: (context, state) {
                      if (state is GetCouponAppliedForCustomer) {
                        isCouponApplied = true;
                        appliedCouponAmount =
                            state.getCouponAppliedForCustomerModel.totalAmount!;
                        setState(() {});
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
                          return showCustomToast(context, state.message, true);
                        });
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CommonDottedLine(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Bill Details',
                              style: headLine2.copyWith(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Price',
                                  style: headLine2.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff1B1C1E)),
                                ),
                                Text(
                                  isCouponApplied
                                      ? '₹ ${(appliedCouponAmount).toStringAsFixed(2)}'
                                      : totalSaleAmount.toStringAsFixed(2),
                                  //'₹ ${totalSaleAmount.toStringAsFixed(2)}',
                                  style: headLine2.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff1B1C1E)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Shipping Charges',
                                  style: headLine2.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff1B1C1E)),
                                ),
                                Text(
                                  '₹ 70.00',
                                  style: headLine2.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff1B1C1E)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const CommonDottedLine(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Net Price',
                                  style: headLine2.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  isCouponApplied
                                      ? '₹ ${(appliedCouponAmount + 70).toStringAsFixed(2)}'
                                      : '₹ ${(totalSaleAmount + 70).toStringAsFixed(2)}',
                                  style: headLine2.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const CommonDottedLine(),
                        ],
                      );
                    },
                  )
                : const SizedBox(),
          ],
        ),
      ),
      bottomNavigationBar: totalAmount > 0.0
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '₹ ${totalAmount.toStringAsFixed(2)}',
                        style: headLine2.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.gary),
                      ),
                      Text(
                        isCouponApplied
                            ? '₹ ${(appliedCouponAmount + 70).toStringAsFixed(2)}'
                            : '₹ ${(totalSaleAmount + 70)..toStringAsFixed(2)}',
                        //'₹ ${(totalSaleAmount + 70).toStringAsFixed(2)}',
                        style: headLine2.copyWith(),
                      ),
                    ],
                  ),
                  CommonButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ProccedToCheckOut()));
                    },
                    buttonText: 'Proceed to checkout',
                    buttonColor: AppColors.primary,
                    buttonTextColor: AppColors.white,
                    height: 52,
                    width: 200,
                  ),
                ],
              ),
            )
          : const SizedBox(),
    );
  }

  // delete product dialog
  Future<void> deleteProductDialogBuilder(BuildContext context, int productId) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) =>
              CustomerProductCubit(customerProductRepository: getIt()),
          child: BlocConsumer<CustomerProductCubit, ProductState>(
            listener: (context, state) {
              if (state is AddEditDeleteProductToCartSuccessState) {
                Navigator.of(context).pop();
                showCustomToast(context,
                    state.addEditDeleteProductToCartModel.response!, false);
              }
              if (state is ProductErrorState) {
                Navigator.of(context).pop();
                showCustomToast(context, state.message, false);
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  AlertDialog(
                    content: SizedBox(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Remove Product',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: Fonts.poppins,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Are you sure want to remove the product from cart?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.gary,
                              fontFamily: Fonts.poppins,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text(
                          'No',
                          style: TextStyle(
                              fontFamily: Fonts.poppins, color: AppColors.gary),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.primary,
                        ),
                        child: const Text('Yes',
                            style: TextStyle(
                                fontFamily: Fonts.poppins,
                                color: AppColors.white)),
                        onPressed: () {
                          context
                              .read<CustomerProductCubit>()
                              .deleteProductFromCart(
                                  userModel!.response!.roleId ?? "", productId);
                          // setState(() {});
                        },
                      )
                    ],
                  ),
                  if (state is ProductLoadingState)
                    const Center(
                        child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ))
                ],
              );
            },
          ),
        );
      },
    );
  }
}
