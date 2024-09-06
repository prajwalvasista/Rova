import 'dart:convert';
import 'dart:io';

import 'package:al_rova/common/function/general_function.dart';
import 'package:al_rova/common/widget/spinkit_indicator.dart';
import 'package:al_rova/cubit/customer/cart_wishlist_similar/cart_wishlist_similar_cubit.dart';
import 'package:al_rova/cubit/customer/cart_wishlist_similar/cart_wishlist_similar_state.dart';
import 'package:al_rova/cubit/customer/ecommerce_cubit/product_count_cubit.dart';
import 'package:al_rova/cubit/customer/product_cubit/product_cubit.dart';
import 'package:al_rova/cubit/customer/product_cubit/product_state.dart';
import 'package:al_rova/di.dart';
import 'package:al_rova/models/auth/verify_otp_model.dart';
import 'package:al_rova/utils/constants/app_style.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:al_rova/utils/services/local_storage.dart';
import 'package:al_rova/utils/widgets/best_deals_item.dart';
import 'package:al_rova/utils/widgets/common_button.dart';
import 'package:al_rova/utils/widgets/common_search_box.dart';
import 'package:al_rova/utils/widgets/custom_clipper.dart';
import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
import 'package:al_rova/views/customer/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetails extends StatefulWidget {
  String customerId;
  int productId;
  ProductDetails(
      {super.key, required this.customerId, required this.productId});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  TextEditingController searchEditingController = TextEditingController();
  final PageController _pageController = PageController(initialPage: 0);
  int salePrice = 0, productId = 0;
  double percentageValue = 0.0;
  bool isAddtoCart = true;
  VerifyOtpModel? userModel;
  final localStorage = getIt<MySharedPref>();

  @override
  void initState() {
    super.initState();
    productId = widget.productId;
    var rawData = localStorage.getUserData();
    if (rawData != null && rawData != "") {
      var userData = jsonDecode(rawData);

      userModel = VerifyOtpModel.fromJson(userData);
    }

    context.read<CustomerProductCubit>().getProductById(widget.productId);
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
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocConsumer<CustomerProductCubit, ProductState>(
              listener: (context, state) {
                if (state is ProductErrorState) {
                  showCustomToast(context, state.message, true);
                  // Navigator.of(context).
                }
                if (state is GetProductByIdSuccessState) {
                  salePrice =
                      state.getAllProductModel.details!.single.salePrice!;
                  percentageValue = GernalFunction.calculatePercentage(
                      state.getAllProductModel.details!.single.salePrice!
                          .toDouble(),
                      state.getAllProductModel.details!.single.price!
                          .toDouble());
                  if (state.getAllProductModel.category!.isNotEmpty) {
                    context
                        .read<CartWishlistSimilarCubit>()
                        .getAllSimilarProducts(
                            state.getAllProductModel.category!);
                  }
                  // isAddtoCart = true;
                  setState(() {});
                }
                if (state is AddEditDeleteProductToCartSuccessState) {
                  if (state.addEditDeleteProductToCartModel.success!) {
                    showCustomToast(context,
                        state.addEditDeleteProductToCartModel.response!, false);
                    isAddtoCart = false;
                    setState(() {});
                  } else {
                    showCustomToast(
                        context,
                        state.addEditDeleteProductToCartModel.errorMessage!,
                        true);
                    // Navigator.of(context).pop();
                  }
                }
              },
              builder: (context, state) {
                if (state is ProductLoadingState) {
                  return const Center(
                    child: SpinKitIndicator(
                      type: SpinKitType.circle,
                    ),
                  );
                }
                if (state is GetProductByIdSuccessState) {
                  return SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          color: AppColors.primary,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
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
                                child: SizedBox(
                                    width: 310,
                                    child: CommonSearchBox(
                                      textEditingController:
                                          searchEditingController,
                                      fillColor: AppColors.white,
                                      filled: true,
                                      isSuffix: false,
                                      hintText: 'Search Product',
                                    )),
                              )
                            ],
                          ),
                        ),
                        ClipPath(
                          clipper: Clipper(),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 2 - 40,
                            width: MediaQuery.of(context).size.width,
                            color: AppColors.primary,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: AppColors.white,
                                      child: IconButton(
                                        icon: Image.asset(
                                          Images.heart,
                                          width: 25,
                                          height: 25,
                                          fit: BoxFit.contain,
                                          color: state.getAllProductModel
                                                  .isWishList!
                                              ? Colors.red
                                              : const Color(0xffD9D9D9),
                                        ),
                                        onPressed: () {
                                          if (state.getAllProductModel
                                                  .isWishList! ==
                                              false) {
                                            Map<String, dynamic> params =
                                                <String, dynamic>{};
                                            params = {
                                              "productId": state
                                                  .getAllProductModel.productId,
                                              "customerId":
                                                  userModel!.response!.roleId!,
                                            };
                                            context
                                                .read<CustomerProductCubit>()
                                                .addProductToWishlist(params)
                                                .then((value) {
                                              context
                                                  .read<CustomerProductCubit>()
                                                  .getProductById(productId);
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 280,
                                    child: PageView.builder(
                                      controller: _pageController,
                                      itemCount: state
                                          .getAllProductModel.images!.length,
                                      itemBuilder: (context, index) {
                                        return Center(
                                          child: Image.network(
                                              'https://developement_rovo.acelucid.com${state.getAllProductModel.images![index]}',
                                              fit: BoxFit.contain,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 200, errorBuilder:
                                                  (context, error, stackTrace) {
                                            return Image.asset(
                                              Images.product,
                                              width: 300,
                                              height: 230,
                                            );
                                          }),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '₹ ${state.getAllProductModel.details!.single.salePrice}',
                                style: headLine2.copyWith(fontSize: 22),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 185,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: const Color(0xffE9F5FA),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                    child: Text(
                                  '${percentageValue.toStringAsFixed(0)} % OFF ends in 3 days',
                                  style: headLine5.copyWith(
                                      color: const Color(0xff2382AA),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                )),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            state.getAllProductModel.name!,
                            style: headLine3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Size: ',
                                style: headLine2.copyWith(
                                    fontSize: 14,
                                    color: const Color(0xff2382AA),
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                '${state.getAllProductModel.details!.single.size!} ${state.getAllProductModel.details!.single.type}',
                                style: headLine2.copyWith(
                                    fontSize: 16,
                                    color: const Color(0xff2382AA),
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Product Description : ',
                                style: headLine4.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                textAlign: TextAlign.justify,
                                state.getAllProductModel.description!,
                                style: headLine4.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Sold by ${state.getAllProductModel.storeName!}',
                            style: headLine2.copyWith(
                                fontSize: 15,
                                color: const Color(0xff2382AA),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            const SizedBox(
              height: 10,
            ),
            BlocBuilder<CartWishlistSimilarCubit, CartWishlistSimilarState>(
              builder: (context, state) {
                if (state is CartWishlistSimilarLoadingState) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ));
                }
                if (state is GetSimilarProductSuccessState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCommonItem(
                        'Similar Products',
                        '',
                        onPressed: () {},
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, bottom: 8.0),
                        child: SizedBox(
                          height: 235,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                double percentageValue =
                                    GernalFunction.calculatePercentage(
                                        state.getAllProductModel[index].details!
                                            .single.salePrice!
                                            .toDouble(),
                                        state.getAllProductModel[index].details!
                                            .single.price!
                                            .toDouble());
                                return BestDealsItem(
                                  isSeller: false,
                                  onTap: () {
                                    setState(() {
                                      productId = state
                                          .getAllProductModel[index].productId!;
                                    });

                                    context
                                        .read<CustomerProductCubit>()
                                        .getProductById(state
                                            .getAllProductModel[index]
                                            .productId!);
                                    isAddtoCart = true;
                                  },
                                  productTitle:
                                      state.getAllProductModel[index].name,
                                  productPrice: state.getAllProductModel[index]
                                      .details?.single.price!
                                      .toString(),
                                  productSalePrice: state
                                      .getAllProductModel[index]
                                      .details
                                      ?.single
                                      .salePrice!
                                      .toString(),
                                  productSize: state.getAllProductModel[index]
                                      .details?.single.size!
                                      .toString(),
                                  productType: state.getAllProductModel[index]
                                      .details?.single.type!,
                                  productImage: state
                                      .getAllProductModel[index].images![0],
                                  percentageOff:
                                      percentageValue.toStringAsFixed(0),
                                  onAddToWishlistClick: () {
                                    if (state.getAllProductModel[index]
                                            .isWishList ==
                                        false) {
                                      Map<String, dynamic> params =
                                          <String, dynamic>{};
                                      params = {
                                        "productId": state
                                            .getAllProductModel[index]
                                            .productId,
                                        "customerId":
                                            userModel!.response!.roleId!,
                                      };
                                      context
                                          .read<CustomerProductCubit>()
                                          .addProductToWishlist(params)
                                          .then((value) {
                                        context
                                            .read<CustomerProductCubit>()
                                            .getProductById(state
                                                .getAllProductModel[index]
                                                .productId!);
                                      });
                                    } else {}
                                  },
                                  isWishList: state
                                      .getAllProductModel[index].isWishList,
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(
                                  width: 10,
                                );
                              },
                              itemCount: state.getAllProductModel.length ?? 0),
                        ),
                      ),
                    ],
                  );
                }
                return const Text('');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Price',
                    style: headLine5,
                  ),
                  Text(
                    '₹ ${salePrice.toString()}',
                    style: headLine3,
                  )
                ],
              ),
            ),
            SizedBox(
                child: Row(
              children: [
                CommonButton(
                  onPressed: isAddtoCart
                      ? () {
                          Map<String, dynamic> params = <String, dynamic>{};
                          params = {
                            "productId": productId,
                            "customerId": userModel!.response!.roleId!,
                            "quantity": 1,
                          };
                          context
                              .read<CustomerProductCubit>()
                              .addProductToCart(params)
                              .then((value) {
                            context
                                .read<CustomerProductCubit>()
                                .getProductById(widget.productId);
                          });
                        }
                      : () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => ProductCountCubit(),
                              child: Cart(
                                //addressId: state.addressResponse,
                                isBack: false,
                              ),
                            ),
                          ))
                              .then((value) {
                            context
                                .read<CustomerProductCubit>()
                                .getProductById(widget.productId);
                          });
                        },
                  buttonText: isAddtoCart ? 'Add to Cart' : 'Go to Cart',
                  buttonColor: AppColors.primary,
                  buttonTextColor: AppColors.white,
                  fontSize: 12,
                ),
                const SizedBox(
                  width: 8,
                ),
                isAddtoCart
                    ? CommonButton(
                        onPressed: () {
                          Map<String, dynamic> params = <String, dynamic>{};
                          params = {
                            "productId": productId,
                            "customerId": userModel!.response!.roleId!,
                            "quantity": 1,
                          };
                          context
                              .read<CustomerProductCubit>()
                              .addProductToCart(params)
                              .then((value) {
                            context
                                .read<CustomerProductCubit>()
                                .getProductById(widget.productId);
                          });
                        },
                        buttonText: 'Buy Now',
                        buttonColor: const Color(0xffBCAA04),
                        buttonTextColor: AppColors.white,
                        fontSize: 12,
                      )
                    : const SizedBox(),
              ],
            )),
          ],
        ),
      ),
    );
  }

  // common widget for product headline
  Widget _buildCommonItem(String prefix, String suffix,
      {VoidCallback? onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            prefix,
            style: headLine5,
          ),
          InkWell(
            onTap: onPressed,
            child: Text(
              suffix,
              style: headLine5.copyWith(
                  color: const Color(0xff2382AA), fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
