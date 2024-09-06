import 'package:al_rova/common/widget/spinkit_indicator.dart';
import 'package:al_rova/cubit/customer/ecommerce_cubit/product_count_cubit.dart';
import 'package:al_rova/cubit/seller/product_cubit/product_cubit.dart';
import 'package:al_rova/cubit/seller/product_cubit/product_state.dart';
import 'package:al_rova/utils/constants/app_style.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:al_rova/utils/widgets/common_button.dart';
import 'package:al_rova/utils/widgets/custom_clipper.dart';
import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SellerProductDetails extends StatefulWidget {
  String sellerId;
  int productId;
  SellerProductDetails(
      {super.key, required this.sellerId, required this.productId});

  @override
  State<SellerProductDetails> createState() => _SellerProductDetailsState();
}

class _SellerProductDetailsState extends State<SellerProductDetails> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    context
        .read<ProductCubit>()
        .getProductById(widget.productId, widget.sellerId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: Text(
          'Product Details',
          style: headLine2.copyWith(color: AppColors.white, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          // TODO: implement listener
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
          if (state is GetProductByIdSuccessState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipPath(
                    clipper: Clipper(),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2 - 70,
                      width: MediaQuery.of(context).size.width,
                      color: AppColors.primary,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 0,
                            ),
                            // Align(
                            //   alignment: Alignment.centerRight,
                            //   child: CircleAvatar(
                            //     radius: 25,
                            //     backgroundColor: AppColors.white,
                            //     child: IconButton(
                            //       icon: Image.asset(
                            //         Images.heart,
                            //         width: 25,
                            //         height: 25,
                            //         fit: BoxFit.cover,
                            //         color: const Color(0xffD9D9D9),
                            //       ),
                            //       onPressed: () {},
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              height: 280,
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount:
                                    state.getProductByIdModel.images!.length,
                                itemBuilder: (context, index) {
                                  return Center(
                                    child: Image.network(
                                        'https://developement_rovo.acelucid.com${state.getProductByIdModel.images![index]}',
                                        fit: BoxFit.contain,
                                        width: 300,
                                        height: 230, errorBuilder:
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
                            ),
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
                          '₹ ${state.getProductByIdModel.details!.single.salePrice}',
                          style: headLine2.copyWith(fontSize: 22),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        // Container(
                        //   width: 185,
                        //   height: 30,
                        //   decoration: BoxDecoration(
                        //       color: const Color(0xffE9F5FA),
                        //       borderRadius: BorderRadius.circular(20)),
                        //   child: Center(
                        //       child: Text(
                        //     '50% OFF ends in 3 days',
                        //     style: headLine5.copyWith(
                        //         color: const Color(0xff2382AA),
                        //         fontSize: 12,
                        //         fontWeight: FontWeight.w700),
                        //   )),
                        // )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${state.getProductByIdModel.name}',
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
                          '${state.getProductByIdModel.details!.single.size} ${state.getProductByIdModel.details!.single.type}',
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
                          'Product Description',
                          style: headLine4.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff979899)),
                        ),
                        Text(
                          '${state.getProductByIdModel.description}',
                          style: headLine4.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff979899)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Sold by ${state.getProductByIdModel.storeName ?? ""}',
                      style: headLine2.copyWith(
                          fontSize: 15,
                          color: const Color(0xff2382AA),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       // const SizedBox(
      //       //   child: Column(
      //       //     mainAxisSize: MainAxisSize.min,
      //       //     mainAxisAlignment: MainAxisAlignment.start,
      //       //     crossAxisAlignment: CrossAxisAlignment.start,
      //       //     children: [
      //       //       Text(
      //       //         'Total Price',
      //       //         style: headLine5,
      //       //       ),
      //       //       Text(
      //       //         '₹100',
      //       //         style: headLine3,
      //       //       )
      //       //     ],
      //       //   ),
      //       // ),
      //       SizedBox(
      //         width: MediaQuery.of(context).size.width / 2 - 10,
      //         child: CommonButton(
      //           onPressed: () {},
      //           buttonText: 'Add to Cart',
      //           buttonColor: AppColors.primary,
      //           buttonTextColor: AppColors.white,
      //           fontSize: 12,
      //         ),
      //       ),
      //       const SizedBox(
      //         width: 8,
      //       ),
      //       SizedBox(
      //         width: MediaQuery.of(context).size.width / 2 - 20,
      //         child: CommonButton(
      //           onPressed: () {},
      //           buttonText: 'Buy Now',
      //           buttonColor: const Color(0xffBCAA04),
      //           buttonTextColor: AppColors.white,
      //           fontSize: 12,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
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
