import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:al_rova/common/cubit/user_authentication_cubit.dart';
import 'package:al_rova/common/function/general_function.dart';
import 'package:al_rova/common/widget/empty_widget.dart';
import 'package:al_rova/common/widget/spinkit_indicator.dart';
import 'package:al_rova/cubit/seller/ordered_product/ordered_product_cubit.dart';
import 'package:al_rova/cubit/seller/ordered_product/ordered_product_state.dart';
import 'package:al_rova/cubit/seller/product_cubit/product_cubit.dart';
import 'package:al_rova/cubit/seller/product_cubit/product_state.dart';
import 'package:al_rova/cubit/seller/seller_commercial_details_cubit/seller_commercial_details_cubit.dart';
import 'package:al_rova/di.dart';
import 'package:al_rova/models/auth/verify_otp_model.dart';
import 'package:al_rova/utils/constants/app_style.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/fonts.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:al_rova/utils/constants/strings.dart';
import 'package:al_rova/utils/services/local_storage.dart';
import 'package:al_rova/utils/services/route_constant.dart';
import 'package:al_rova/utils/widgets/best_deals_item.dart';
import 'package:al_rova/utils/widgets/common_button.dart';
import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
import 'package:al_rova/views/notification/notification.dart';
import 'package:al_rova/views/seller/home/seller_complete_registration.dart';
import 'package:al_rova/views/seller/order/order_list.dart';
import 'package:al_rova/views/seller/product/add_product.dart';
import 'package:al_rova/views/seller/product/seller_product_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SellerHome extends StatefulWidget {
  const SellerHome({super.key});

  @override
  State<SellerHome> createState() => _SellerHomeState();
}

class _SellerHomeState extends State<SellerHome> {
  ValueNotifier<bool> isVerificationComplete = ValueNotifier(false);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  VerifyOtpModel? userModel;
  final localStorage = getIt<MySharedPref>();
  static const String baseUrl = String.fromEnvironment("base_url");

  @override
  void initState() {
    super.initState();

    var rawData = localStorage.getUserData();
    if (rawData != null && rawData != "") {
      var userData = jsonDecode(rawData);

      userModel = VerifyOtpModel.fromJson(userData);
    }

    context
        .read<ProductCubit>()
        .getSellerDetails(userModel!.response!.phoneNumber ?? "", "");
    context
        .read<OrderedProductCubit>()
        .getTotalOrderdProductsForSeller(userModel!.response!.roleId!);
  }

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  Future<void> _handleRefresh() async {
    if (userModel != null && userModel!.response != null) {
      context.read<ProductCubit>().getSellerDetails(
          userModel!.response!.phoneNumber!, userModel!.response!.roleId!);
    } else {
      print("");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        _onBackPressed();
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: BlocBuilder<OrderedProductCubit, OrderedProductState>(
            builder: (context, state) {
              if (state is OrderedProductSuccessState) {
                return AppBar(
                  backgroundColor: AppColors.primary,
                  leading: Center(
                    child: InkWell(
                        onTap: () {
                          _openDrawer();
                        },
                        child: Image.asset(
                          Images.menu,
                          height: 45,
                          width: 45,
                          fit: BoxFit.contain,
                          color: AppColors.white,
                        )),
                  ),
                  leadingWidth: 65,
                  actions: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BlocProvider(
                                  create: (context) =>
                                      ProductCubit(productRepository: getIt()),
                                  child: const OrderList(),
                                )));
                      },
                      child: Badge(
                        label: Text(
                          state.getOrderProductsCountModel.productsCount
                              .toString(),
                          style: const TextStyle(color: AppColors.black),
                        ),
                        backgroundColor: AppColors.white,
                        child: Image.asset(
                          Images.orderList,
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const NotificationScreen()));
                      },
                      child: const Badge(
                        label: Text(
                          '20',
                          style: TextStyle(color: AppColors.black),
                        ),
                        backgroundColor: AppColors.white,
                        child: Icon(
                          Icons.notifications_rounded,
                          color: AppColors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
        body: BlocConsumer<ProductCubit, ProductState>(
          listener: (context, state) {
            if (state is ProductErrorState) {
              showCustomToast(context, state.message, true);
            }
          },
          builder: (context, state) {
            if (state is ProductLoadingState) {
              return const SpinKitIndicator(
                type: SpinKitType.circle,
              );
            }

            if (state is GetProductSuccessState &&
                state.getAllProductModel.isEmpty) {
              return const EmptyWidget(message: "No product found.");
            }

            if (state is SellerDetailSuccessState) {
              print("success state");
              if (state.getSellerDetailsModel.response != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  isVerificationComplete.value =
                      state.getSellerDetailsModel.response!.single.isApproved!;
                });

                if (state.getSellerDetailsModel.response!.single.isApproved!) {
                  context
                      .read<ProductCubit>()
                      .getProductBySellerId(userModel!.response!.roleId ?? "");
                }
              }

              return SizedBox(
                child: Column(
                  children: [
                    if (state.getSellerDetailsModel.response == null)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 150,
                          ),
                          Center(
                              child: Image.asset(
                            Images.sellerHome,
                            width: 300,
                            height: 300,
                          )),
                          const SizedBox(
                            height: 50,
                          ),
                          CommonButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) =>
                                      SellerCommercialDetailsCubit(
                                          sellerRepository: getIt()),
                                  child: const SellerCompleteRegistration(),
                                ),
                              ))
                                  .then(((value) {
                                context.read<ProductCubit>().getSellerDetails(
                                      userModel!.response!.phoneNumber ?? "",
                                      "",
                                    );
                              }));
                            },
                            buttonText: 'Complete Registration',
                            buttonColor: AppColors.primary,
                            buttonTextColor: AppColors.white,
                            height: 48,
                            width: 300,
                          )
                        ],
                      ),
                    if (state.getSellerDetailsModel.response != null)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 150,
                          ),
                          Center(
                              child: Image.asset(
                            Images.inProgress,
                            width: 300,
                            height: 300,
                          )),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              state.getSellerDetailsModel.response!.single
                                      .isApproved!
                                  ? ""
                                  : 'Currently seller verifaction is inprogress. It will take some time.',
                              style: headLine3.copyWith(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CommonButton(
                              onPressed: () {
                                _handleRefresh();
                              },
                              buttonText: 'Refresh',
                              buttonColor: AppColors.primary,
                              buttonTextColor: AppColors.white)
                        ],
                      )
                  ],
                ),
              );
            }

            if (state is GetProductSuccessState) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: state.getAllProductModel.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 0.75),
                  itemBuilder: (context, index) {
                    //calcutate percentage
                    double percentageValue = GernalFunction.calculatePercentage(
                        state.getAllProductModel[index].details!.single
                            .salePrice!
                            .toDouble(),
                        state.getAllProductModel[index].details!.single.price!
                            .toDouble());

                    return BestDealsItem(
                      isSeller: true,
                      baseUrl: baseUrl,
                      onDeleteClick: () {
                        deleteProductDialogBuilder(context,
                                state.getAllProductModel[index].productId!)
                            .then(
                          (value) {
                            context.read<ProductCubit>().getProductBySellerId(
                                userModel!.response!.roleId ?? "");
                          },
                        );
                      },
                      onEditClick: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) =>
                                ProductCubit(productRepository: getIt()),
                            child: AddProduct(
                              isEdit: true,
                              data: state.getAllProductModel[index],
                            ),
                          ),
                        ))
                            .then(
                          (value) {
                            context.read<ProductCubit>().getProductBySellerId(
                                userModel!.response!.roleId ?? "");
                          },
                        );
                      },
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) =>
                                ProductCubit(productRepository: getIt()),
                            child: SellerProductDetails(
                              sellerId:
                                  state.getAllProductModel[index].sellerId ??
                                      "",
                              productId:
                                  state.getAllProductModel[index].productId!,
                            ),
                          ),
                        ))
                            .then((value) {
                          context.read<ProductCubit>().getProductBySellerId(
                              userModel!.response!.roleId ?? "");
                        });
                      },
                      productTitle: state.getAllProductModel[index].name,
                      productPrice: state
                          .getAllProductModel[index].details?.single.price!
                          .toString(),
                      productSalePrice: state
                          .getAllProductModel[index].details?.single.salePrice!
                          .toString(),
                      productSize: state
                          .getAllProductModel[index].details?.single.size!
                          .toString(),
                      productType:
                          state.getAllProductModel[index].details?.single.type!,
                      productImage: state.getAllProductModel[index].images![0],
                      percentageOff: percentageValue.toStringAsFixed(0),
                    );
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: ValueListenableBuilder(
          valueListenable: isVerificationComplete,
          builder: (BuildContext context, bool isVerificationComplete,
              Widget? child) {
            return FloatingActionButton(
              backgroundColor:
                  isVerificationComplete ? AppColors.primary : AppColors.white,
              elevation: isVerificationComplete ? 10 : 0,
              onPressed: isVerificationComplete
                  ? () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) =>
                              ProductCubit(productRepository: getIt()),
                          child: AddProduct(
                            isEdit: false,
                          ),
                        ),
                      ))
                          .then(
                        (value) {
                          context.read<ProductCubit>().getProductBySellerId(
                              userModel!.response!.roleId ?? "");
                        },
                      );
                    }
                  : () {},
              child: const Icon(
                Icons.add,
                color: AppColors.white,
              ),
            );
          },
        ),
        drawer: Drawer(
          elevation: 7,
          width: MediaQuery.of(context).size.width / 1.3,
          surfaceTintColor: AppColors.white,
          backgroundColor: AppColors.white,
          child: Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.lightGary,
                      child: Icon(
                        Icons.person_3_rounded,
                        size: 60,
                        color: Colors.green,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 45),
                          SizedBox(
                            width: 150,
                            child: Text(
                              userModel?.response?.name ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontFamily: Fonts.poppins,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            userModel?.response?.phoneNumber ?? "",
                            style: const TextStyle(
                                color: AppColors.gary,
                                fontSize: 15,
                                fontFamily: Fonts.dmSansSemiBold,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(
                Icons.logout,
                AppStrings.logout,
                onPressed: () {
                  _logoutDialogBuilder(context);
                },
              ),
              // _buildDrawerItem(
              //   Icons.delete,
              //   'Delete Account',
              //   onPressed: () {
              //     _deleteDialogBuilder(context);
              //   },
              // ),
              // const Divider(
              //   height: 1,
              //   color: AppColors.lightGary,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  /// back pressed modal
  Future<bool> _onBackPressed() async {
    return (await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  exit(0);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false; // Provide a default value of 'false' if null is returned
  }

  // build drawer item
  Widget _buildDrawerItem(IconData icon, String label,
      {VoidCallback? onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color.fromARGB(255, 95, 173, 43),
          ),
          const SizedBox(width: 10.0),
          InkWell(
            onTap: onPressed,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18.0,
                color: Color.fromARGB(255, 12, 11, 11),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // logout dialog
  Future<void> _logoutDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 270,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  Images.logout,
                  width: 200,
                  height: 200,
                ),
                const Text(
                  AppStrings.comebackSoon,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: Fonts.poppins,
                    fontSize: 20,
                  ),
                ),
                const Text(
                  AppStrings.logoutMsg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.gary,
                    fontFamily: Fonts.poppins,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
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
                AppStrings.cancel,
                style:
                    TextStyle(fontFamily: Fonts.poppins, color: AppColors.gary),
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
              child: const Text(AppStrings.yesLogout,
                  style: TextStyle(
                      fontFamily: Fonts.poppins, color: AppColors.white)),
              onPressed: () {
                context.read<UserAuthCubit>().logout();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
                _scaffoldKey.currentState!.closeEndDrawer();
              },
            ),
          ],
        );
      },
    );
  }

  // delete product dialog
  Future<void> deleteProductDialogBuilder(BuildContext context, int addressId) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => ProductCubit(productRepository: getIt()),
          child: BlocConsumer<ProductCubit, ProductState>(
            listener: (context, state) {
              if (state is SuccessState) {
                Navigator.of(context).pop();
                showCustomToast(context, state.successResponse.message!, false);
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
                            'Delete Product',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: Fonts.poppins,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Are you sure want to delete the product?",
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
                          context.read<ProductCubit>().deleteProduct(
                              addressId, userModel!.response!.roleId ?? "");
                          // setState(() {});
                        },
                      )
                    ],
                  ),
                  if (state is ProductLoadingState)
                    const Center(child: CircularProgressIndicator())
                ],
              );
            },
          ),
        );
      },
    );
  }
}
