// import 'dart:async';
// import 'dart:convert';

// import 'package:al_rova/common/cubit/user_authentication_cubit.dart';
// import 'package:al_rova/common/function/general_function.dart';
// import 'package:al_rova/common/widget/spinkit_indicator.dart';
// import 'package:al_rova/cubit/auth_cubit/auth_cubit.dart';
// import 'package:al_rova/cubit/customer/cart_update_cubit/cart_update_cubit.dart';
// import 'package:al_rova/cubit/customer/cart_wishlist_similar/cart_wishlist_similar_cubit.dart';
// import 'package:al_rova/cubit/customer/cart_wishlist_similar/cart_wishlist_similar_state.dart';
// import 'package:al_rova/cubit/customer/address_cubit/address_cubit.dart';
// import 'package:al_rova/cubit/customer/category/category_cubit.dart';
// import 'package:al_rova/cubit/customer/category/category_state.dart';
// import 'package:al_rova/cubit/customer/get_edited_customer_cubit/get_edited_customer_cubit.dart';
// import 'package:al_rova/cubit/customer/get_edited_customer_cubit/get_edited_customer_state.dart';
// import 'package:al_rova/cubit/customer/product_cubit/product_cubit.dart';
// import 'package:al_rova/cubit/customer/product_cubit/product_state.dart';
// import 'package:al_rova/di.dart';
// import 'package:al_rova/models/auth/verify_otp_model.dart';
// import 'package:al_rova/models/customer/edited_customer/get_edited_customer_model.dart';
// import 'package:al_rova/repositories/customer/address_repository.dart';
// import 'package:al_rova/repositories/customer/customer_product_repository.dart';
// import 'package:al_rova/repositories/customer/update_cart_product_repo.dart';
// import 'package:al_rova/utils/constants/colors.dart';
// import 'package:al_rova/utils/constants/fonts.dart';
// import 'package:al_rova/utils/constants/images.dart';
// import 'package:al_rova/utils/constants/strings.dart';
// import 'package:al_rova/utils/services/local_storage.dart';
// import 'package:al_rova/utils/widgets/best_deals_item.dart';
// import 'package:al_rova/utils/widgets/categories_item.dart';
// import 'package:al_rova/utils/widgets/common_search_box.dart';
// import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
// import 'package:al_rova/views/auth/select_crop.dart';
// import 'package:al_rova/views/customer/address/add_new_address.dart';
// import 'package:al_rova/views/customer/cart/cart.dart';
// import 'package:al_rova/views/customer/ecommerce/help_guide.dart';
// import 'package:al_rova/views/customer/ecommerce/product_details.dart';
// import 'package:al_rova/views/customer/ecommerce/product_list.dart';
// import 'package:al_rova/views/customer/ecommerce/wishlist.dart';
// import 'package:al_rova/views/customer/profile/contact_us.dart';
// import 'package:al_rova/views/notification/notification.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';

// class EcommerceHome extends StatefulWidget {
//   const EcommerceHome({super.key});

//   @override
//   State<EcommerceHome> createState() => _EcommerceHomeState();
// }

// class _EcommerceHomeState extends State<EcommerceHome> {
//   TextEditingController searchEditingController = TextEditingController();
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   GetEditedCustomerModel? getEditedCustomerModel;
//   VerifyOtpModel? userModel;
//   final localStorage = getIt<MySharedPref>();
//   String wishlistCount = "0", cartCount = "0";

//   @override
//   void initState() {
//     var rawData = localStorage.getUserData();

//     if (rawData != null && rawData != "") {
//       var userData = jsonDecode(rawData);

//       userModel = VerifyOtpModel.fromJson(userData);
//     }
//     callAllApis();

//     super.initState();
//   }

// // call api
//   void callAllApis() {
//     context
//         .read<CustomerProductCubit>()
//         .fetchAllProduct(userModel!.response!.roleId!);

//     context
//         .read<CartWishlistSimilarCubit>()
//         .getCountOfWishlistAndCartProduct(userModel!.response!.roleId!);

//     context.read<CategoryCubit>().getAllCategory();
//     context
//         .read<GetEditedCustomerCubit>()
//         .getEditedCustomer(userModel!.response!.roleId!);
//   }

//   void _openDrawer() {
//     _scaffoldKey.currentState!.openDrawer();
//   }

// // open terms & condition url
//   // _launchURLBrowser() async {
//   //   var url = Uri.parse("https://rova.acelucid.com/terms_condition.html");
//   //   await launchUrl(url);
//   // }

// // open terms & condition url
//   _launchRateUsURLBrowser() async {
//     var url = Uri.parse(
//         "https://play.google.com/store/apps/details?id=com.acelucid.al_rova");
//     await launchUrl(url);
//   }

//   @override
//   void dispose() {
//     searchEditingController.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(56),
//           child:
//               BlocConsumer<CartWishlistSimilarCubit, CartWishlistSimilarState>(
//             listener: (context, state) {
//               if (state is CountofWishlistAndCartProductSuccessState) {
//                 if (state.getCountofWishlistAndCartProducts.status ==
//                     "success") {
//                   wishlistCount = state
//                       .getCountofWishlistAndCartProducts.wishListCount
//                       .toString();
//                   cartCount = state.getCountofWishlistAndCartProducts.cartCount
//                       .toString();
//                   setState(() {});
//                 }
//               }
//             },
//             builder: (context, state) {
//               return AppBar(
//                 backgroundColor: AppColors.primary,
//                 leading: InkWell(
//                   onTap: () {
//                     _openDrawer();
//                   },
//                   child: Center(
//                       child: Image.asset(
//                     Images.menu,
//                     color: AppColors.white,
//                     height: 45,
//                     width: 45,
//                     fit: BoxFit.contain,
//                   )),
//                 ),
//                 leadingWidth: 65,
//                 actions: [
//                   InkWell(
//                     onTap: () {
//                       Navigator.of(context).push(MaterialPageRoute(
//                           builder: (context) => const NotificationScreen()));
//                     },
//                     child: const Badge(
//                       label: Text(
//                         '2',
//                         style: TextStyle(color: AppColors.white),
//                       ),
//                       backgroundColor: Colors.red,
//                       child: Icon(
//                         Icons.notifications_rounded,
//                         color: AppColors.white,
//                         size: 40,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 20,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       Navigator.of(context)
//                           .push(MaterialPageRoute(
//                               builder: (context) => const Wishlist()))
//                           .then((value) {
//                         context
//                             .read<CustomerProductCubit>()
//                             .fetchAllProduct(userModel!.response!.roleId!);
//                         context
//                             .read<CartWishlistSimilarCubit>()
//                             .getCountOfWishlistAndCartProduct(
//                                 userModel!.response!.roleId!);
//                         context.read<CategoryCubit>().getAllCategory();
//                       });
//                     },
//                     child: Badge(
//                       label: Text(
//                         wishlistCount,
//                         style: const TextStyle(color: AppColors.white),
//                       ),
//                       backgroundColor: Colors.red,
//                       child: const Icon(
//                         Icons.favorite_rounded,
//                         color: AppColors.white,
//                         size: 40,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 20,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       Navigator.of(context)
//                           .push(MaterialPageRoute(
//                         builder: (context) => MultiBlocProvider(
//                           providers: [
//                             BlocProvider(
//                                 create: (context) => CustomerProductCubit(
//                                     customerProductRepository:
//                                         getIt<CustomerProductRepository>())),
//                             BlocProvider(
//                               create: (context) => AddressCubit(
//                                 addressRepository: getIt<AddressRepository>(),
//                               ),
//                             ),
//                             BlocProvider(
//                               create: (context) => CartProductUpdateCubit(
//                                 updateCartProductRepository:
//                                     getIt<UpdateCartProductRepository>(),
//                               ),
//                             ),
//                           ],
//                           child: Cart(),
//                         ),
//                       ))
//                           .then((value) {
//                         context
//                             .read<CustomerProductCubit>()
//                             .fetchAllProduct(userModel!.response!.roleId!);
//                         context
//                             .read<CartWishlistSimilarCubit>()
//                             .getCountOfWishlistAndCartProduct(
//                                 userModel!.response!.roleId!);
//                         context.read<CategoryCubit>().getAllCategory();
//                       });
//                     },
//                     child: Badge(
//                       label: Text(
//                         cartCount,
//                         style: const TextStyle(color: AppColors.white),
//                       ),
//                       backgroundColor: Colors.red,
//                       child: const Icon(
//                         Icons.shopping_cart_rounded,
//                         color: AppColors.white,
//                         size: 40,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 20,
//                   ),
//                 ],
//               );
//             },
//           )),
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         padding: const EdgeInsets.all(8.0),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.only(bottom: 70),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(
//                 height: 10,
//               ),
//               CommonSearchBox(
//                 textEditingController: searchEditingController,
//                 fillColor: AppColors.white,
//                 filled: false,
//                 isSuffix: true,
//                 hintText: AppStrings.whatAreYouLookingFor,
//                 onPressed: () {},
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 height: 160,
//                 width: MediaQuery.of(context).size.width,
//                 child: ListView.separated(
//                   shrinkWrap: true,
//                   itemCount: 3,
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (context, index) {
//                     return InkWell(
//                       onTap: () {},
//                       child: Center(
//                         child: Image.asset(
//                           Images.offerFrame,
//                           width: 335,
//                           height: 155,
//                         ),
//                       ),
//                     );
//                   },
//                   separatorBuilder: (BuildContext context, int index) {
//                     return const SizedBox(
//                       width: 10,
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),

//               // category list ui

//               BlocBuilder<CategoryCubit, CategoryState>(
//                 builder: (context, state) {
//                   // if (state is CategoryLoadingState) {
//                   //   return const Center(
//                   //       child: SpinKitIndicator(
//                   //     type: SpinKitType.circle,
//                   //   ));
//                   // }
//                   if (state is GetAllCategorySuccessState) {
//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildCommonItem(
//                           'Categories',
//                           'See all',
//                           onPressed: () {},
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         GridView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: 3,
//                           gridDelegate:
//                               const SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: 3,
//                                   crossAxisSpacing: 2,
//                                   mainAxisSpacing: 5),
//                           itemBuilder: (BuildContext context, int index) {
//                             return CategoriesItem(
//                               onTap: () {
//                                 // Navigator.of(context).push(
//                                 //   MaterialPageRoute(
//                                 //     builder: (context) =>
//                                 //         const CategoriesInfo(categoryName: ,),
//                                 //   ),
//                                 // );
//                               },
//                               title: state.getAllCategory.response![index]
//                                   .productCategoryName!,
//                               image:
//                                   state.getAllCategory.response![index].image!,
//                             );
//                           },
//                         ),
//                       ],
//                     );
//                   } else {
//                     return const Text('');
//                   }
//                 },
//               ),

//               const SizedBox(
//                 height: 10,
//               ),

//               // product list ui

//               BlocBuilder<CustomerProductCubit, ProductState>(
//                 builder: (context, state) {
//                   if (state is ProductLoadingState) {
//                     return const Center(
//                         child: SpinKitIndicator(
//                       type: SpinKitType.circle,
//                     ));
//                   }
//                   if (state is SuccessState) {
//                     WidgetsBinding.instance.addPostFrameCallback((_) {
//                       showCustomToast(
//                           context, state.successResponse.message!, false);
//                     });
//                   }
//                   if (state is GetProductSuccessState) {
//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildCommonItem(
//                           'Best deals 🔥',
//                           'See all',
//                           onPressed: () {
//                             Navigator.of(context)
//                                 .push(MaterialPageRoute(
//                               builder: (context) => BlocProvider(
//                                 create: (context) => CustomerProductCubit(
//                                   customerProductRepository: getIt(),
//                                 ),
//                                 child: ProductList(
//                                   isBestDeal: true,
//                                 ),
//                               ),
//                             ))
//                                 .then((value) {
//                               context
//                                   .read<CustomerProductCubit>()
//                                   .fetchAllProduct(
//                                       userModel!.response!.roleId!);
//                               context
//                                   .read<CartWishlistSimilarCubit>()
//                                   .getCountOfWishlistAndCartProduct(
//                                       userModel!.response!.roleId!);
//                               context.read<CategoryCubit>().getAllCategory();
//                             });
//                           },
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         SizedBox(
//                           height: 235,
//                           child: ListView.separated(
//                               scrollDirection: Axis.horizontal,
//                               shrinkWrap: true,
//                               itemBuilder: (context, index) {
//                                 double percentageValue =
//                                     GernalFunction.calculatePercentage(
//                                         state.getAllProductModel[index].details!
//                                             .single.salePrice!
//                                             .toDouble(),
//                                         state.getAllProductModel[index].details!
//                                             .single.price!
//                                             .toDouble());
//                                 return BestDealsItem(
//                                   isSeller: false,
//                                   onTap: () {
//                                     Navigator.of(context)
//                                         .push(MaterialPageRoute(
//                                       builder: (context) => ProductDetails(
//                                         customerId:
//                                             userModel!.response!.roleId!,
//                                         productId: state
//                                             .getAllProductModel[index]
//                                             .productId!,
//                                       ),
//                                     ))
//                                         .then((value) {
//                                       context
//                                           .read<CustomerProductCubit>()
//                                           .fetchAllProduct(
//                                               userModel!.response!.roleId!);
//                                       context
//                                           .read<CartWishlistSimilarCubit>()
//                                           .getCountOfWishlistAndCartProduct(
//                                               userModel!.response!.roleId!);
//                                       context
//                                           .read<CategoryCubit>()
//                                           .getAllCategory();
//                                     });
//                                   },
//                                   productTitle:
//                                       state.getAllProductModel[index].name,
//                                   productPrice: state.getAllProductModel[index]
//                                       .details?.single.price!
//                                       .toString(),
//                                   productSalePrice: state
//                                       .getAllProductModel[index]
//                                       .details
//                                       ?.single
//                                       .salePrice!
//                                       .toString(),
//                                   productSize: state.getAllProductModel[index]
//                                       .details?.single.size!
//                                       .toString(),
//                                   productType: state.getAllProductModel[index]
//                                       .details?.single.type!,
//                                   productImage: state
//                                       .getAllProductModel[index].images![0],
//                                   percentageOff:
//                                       percentageValue.toStringAsFixed(0),
//                                   onAddToWishlistClick: () {
//                                     if (state.getAllProductModel[index]
//                                             .isWishList ==
//                                         false) {
//                                       Map<String, dynamic> params =
//                                           <String, dynamic>{};
//                                       params = {
//                                         "productId": state
//                                             .getAllProductModel[index]
//                                             .productId,
//                                         "customerId":
//                                             userModel!.response!.roleId!,
//                                         // "sellerId": state
//                                         //     .getAllProductModel[index].sellerId,
//                                       };
//                                       context
//                                           .read<CustomerProductCubit>()
//                                           .addProductToWishlist(params)
//                                           .then((value) {
//                                         context
//                                             .read<CustomerProductCubit>()
//                                             .fetchAllProduct(
//                                                 userModel!.response!.roleId!);
//                                         context
//                                             .read<CartWishlistSimilarCubit>()
//                                             .getCountOfWishlistAndCartProduct(
//                                                 userModel!.response!.roleId!);
//                                       });
//                                     } else {
//                                       // context
//                                       //     .read<CustomerProductCubit>()
//                                       //     .deleteProductFromWishlist(
//                                       //         userModel!.response!.roleId!,
//                                       //         state.getAllProductModel[index]
//                                       //             .productId!)
//                                       //     .then((value) {
//                                       //   context
//                                       //       .read<CustomerProductCubit>()
//                                       //       .fetchAllProduct(
//                                       //           userModel!.response!.roleId!);
//                                       //   context
//                                       //       .read<CartWishlistSimilarCubit>()
//                                       //       .getCountOfWishlistAndCartProduct(
//                                       //           userModel!.response!.roleId!);
//                                       // });
//                                     }
//                                   },
//                                   isWishList: state
//                                       .getAllProductModel[index].isWishList,
//                                 );
//                               },
//                               separatorBuilder:
//                                   (BuildContext context, int index) {
//                                 return const SizedBox(
//                                   width: 10,
//                                 );
//                               },
//                               itemCount: state.getAllProductModel.length),
//                         ),
//                       ],
//                     );
//                   } else {
//                     return const SizedBox();
//                   }
//                 },
//               ),
//               // const SizedBox(
//               //   height: 10,
//               // ),

//               const SizedBox(
//                 height: 40,
//               ),
//             ],
//           ),
//         ),
//       ),
//       drawer: Drawer(
//         elevation: 7,
//         width: MediaQuery.of(context).size.width / 1.3,
//         surfaceTintColor: AppColors.white,
//         backgroundColor: AppColors.white,
//         child: Column(
//           children: [
//             DrawerHeader(
//               decoration: const BoxDecoration(
//                 color: AppColors.white,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const CircleAvatar(
//                     radius: 40,
//                     backgroundColor: AppColors.lightGary,
//                     child: Icon(
//                       Icons.person_3_rounded,
//                       size: 60,
//                       color: Colors.green,
//                     ),
//                   ),
//                   SingleChildScrollView(
//                     child: Container(
//                       margin: const EdgeInsets.only(left: 10),
//                       child: BlocBuilder<GetEditedCustomerCubit,
//                           GetEditedCustomerState>(
//                         builder: (context, state) {
//                           if (state is GetEditedCustomerSuccess) {
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(
//                                   width: 150,
//                                   child: Text(
//                                     state.getEditedCustomerModel.name ?? "",
//                                     maxLines: 1,
//                                     overflow: TextOverflow.visible,
//                                     style: const TextStyle(
//                                         color: AppColors.black,
//                                         fontSize: 16,
//                                         fontFamily: Fonts.poppins,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                                 Text(
//                                   state.getEditedCustomerModel.phoneNumber ??
//                                       "",
//                                   style: const TextStyle(
//                                       color: AppColors.gary,
//                                       fontSize: 15,
//                                       fontFamily: Fonts.dmSansSemiBold,
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                               ],
//                             );
//                           }
//                           return const SizedBox();
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             _buildLowerDrawerItems(AppStrings.agriBook, onPressed: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => const SelectCrop(),
//                 ),
//               );
//             }),
//             _buildLowerDrawerItems(
//               AppStrings.rateUs,
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _launchRateUsURLBrowser();
//               },
//             ),
//             _buildLowerDrawerItems(
//               AppStrings.addNewAddress,
//               onPressed: () {
//                 Navigator.of(context)
//                     .push(MaterialPageRoute(
//                       builder: (context) => BlocProvider(
//                         create: (context) =>
//                             AddressCubit(addressRepository: getIt()),
//                         child: AddNewAddress(
//                           isEdit: false,
//                         ),
//                       ),
//                     ))
//                     .then((value) => context
//                         .read<AddressCubit>()
//                         .fetchAllAddress(userModel!.response!.roleId!));
//               },
//             ),
//             // _buildLowerDrawerItems(
//             //   AppStrings.termsCondition,
//             //   onPressed: () {
//             //     Navigator.of(context).pop();
//             //     _launchURLBrowser();
//             //   },
//             // ),
//             _buildLowerDrawerItems(
//               AppStrings.helpGuide,
//               onPressed: () {
//                 Navigator.of(context).push(
//                     MaterialPageRoute(builder: (context) => const HelpGuide()));
//               },
//             ),
//             _buildLowerDrawerItems(
//               AppStrings.shareApp,
//               onPressed: () {
//                 shareAppLink();
//               },
//             ),
//             _buildLowerDrawerItems(
//               AppStrings.contactUs,
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const ContactUs(),
//                     ));
//               },
//             ),
//             const Divider(
//               height: 1,
//               color: AppColors.lightGary,
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             _buildDrawerItem(
//               Icons.logout,
//               AppStrings.logout,
//               onPressed: () {
//                 _logoutDialogBuilder(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// // common widget for product headline
//   Widget _buildCommonItem(String prefix, String suffix,
//       {VoidCallback? onPressed}) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             prefix,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//           ),
//           InkWell(
//             onTap: onPressed,
//             child: Text(
//               suffix,
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // build drawer item
//   Widget _buildDrawerItem(IconData icon, String label,
//       {VoidCallback? onPressed}) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             color: const Color.fromARGB(255, 95, 173, 43),
//           ),
//           const SizedBox(width: 10.0),
//           InkWell(
//             onTap: onPressed,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 18.0,
//                 color: Color.fromARGB(255, 12, 11, 11),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   //
//   Widget _buildLowerDrawerItems(String label,
//       {required void Function() onPressed}) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Align(
//         alignment: Alignment.centerLeft,
//         child: InkWell(
//           onTap: onPressed,
//           child: Text(
//             label,
//             style: const TextStyle(
//               color: AppColors.primary,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               letterSpacing: 0.3,
//               fontFamily: Fonts.poppins,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // logout dialog
//   Future<void> _logoutDialogBuilder(BuildContext context) {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: SizedBox(
//             height: 270,
//             width: MediaQuery.of(context).size.width,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   Images.logout,
//                   width: 200,
//                   height: 200,
//                 ),
//                 const Text(
//                   AppStrings.comebackSoon,
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontFamily: Fonts.poppins,
//                     fontSize: 20,
//                   ),
//                 ),
//                 const Text(
//                   AppStrings.logoutMsg,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: AppColors.gary,
//                     fontFamily: Fonts.poppins,
//                     fontSize: 15,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 )
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               style: TextButton.styleFrom(
//                 textStyle: Theme.of(context).textTheme.labelLarge,
//               ),
//               child: const Text(
//                 AppStrings.cancel,
//                 style:
//                     TextStyle(fontFamily: Fonts.poppins, color: AppColors.gary),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               style: TextButton.styleFrom(
//                 textStyle: Theme.of(context).textTheme.labelLarge,
//                 backgroundColor: AppColors.primary,
//                 foregroundColor: AppColors.primary,
//               ),
//               child: const Text(
//                 AppStrings.yesLogout,
//                 style: TextStyle(
//                     fontFamily: Fonts.poppins, color: AppColors.white),
//               ),
//               onPressed: () {
//                 context.read<UserAuthCubit>().logout();
//                 Navigator.of(context).pop();
//                 _scaffoldKey.currentState!.closeEndDrawer();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // delete account dialog
//   Future<void> _deleteDialogBuilder(BuildContext context) {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: SizedBox(
//             height: 320,
//             width: MediaQuery.of(context).size.width,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   Images.delete,
//                   width: 200,
//                   height: 200,
//                 ),
//                 const Text(
//                   AppStrings.deleteAccount,
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontFamily: Fonts.poppins,
//                     fontSize: 20,
//                   ),
//                 ),
//                 const Text(
//                   AppStrings.accountDeleteMsg,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: AppColors.gary,
//                     fontFamily: Fonts.poppins,
//                     fontSize: 15,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 )
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               style: TextButton.styleFrom(
//                 textStyle: Theme.of(context).textTheme.labelLarge,
//               ),
//               child: const Text(
//                 'No',
//                 style:
//                     TextStyle(fontFamily: Fonts.poppins, color: AppColors.gary),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               style: TextButton.styleFrom(
//                 textStyle: Theme.of(context).textTheme.labelLarge,
//                 backgroundColor: AppColors.primary,
//                 foregroundColor: AppColors.primary,
//               ),
//               child: const Text('Yes',
//                   style: TextStyle(
//                       fontFamily: Fonts.poppins, color: AppColors.white)),
//               onPressed: () async {
//                 context.read<AuthCubit>().deleteUserAccount("9110951615");
//                 Navigator.of(context).pop();
//                 _scaffoldKey.currentState!.closeEndDrawer();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void shareAppLink() {
//     String appLink =
//         "https://play.google.com/store/apps/details?id=com.acelucid.al_rova";
//     Share.share(
//       'Check out our amazing app, ROVA! Find the best deals on all your farming needs. Start shopping today: $appLink',
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';

import 'package:al_rova/common/cubit/user_authentication_cubit.dart';
import 'package:al_rova/common/function/general_function.dart';
import 'package:al_rova/common/widget/spinkit_indicator.dart';
import 'package:al_rova/cubit/auth_cubit/auth_cubit.dart';
import 'package:al_rova/cubit/customer/cart_update_cubit/cart_update_cubit.dart';
import 'package:al_rova/cubit/customer/cart_wishlist_similar/cart_wishlist_similar_cubit.dart';
import 'package:al_rova/cubit/customer/cart_wishlist_similar/cart_wishlist_similar_state.dart';
import 'package:al_rova/cubit/customer/address_cubit/address_cubit.dart';
import 'package:al_rova/cubit/customer/category/category_cubit.dart';
import 'package:al_rova/cubit/customer/category/category_state.dart';
import 'package:al_rova/cubit/customer/get_edited_customer_cubit/get_edited_customer_cubit.dart';
import 'package:al_rova/cubit/customer/get_edited_customer_cubit/get_edited_customer_state.dart';
import 'package:al_rova/cubit/customer/product_cubit/product_cubit.dart';
import 'package:al_rova/cubit/customer/product_cubit/product_state.dart';
import 'package:al_rova/di.dart';
import 'package:al_rova/models/auth/verify_otp_model.dart';
import 'package:al_rova/models/customer/edited_customer/get_edited_customer_model.dart';
import 'package:al_rova/repositories/customer/address_repository.dart';
import 'package:al_rova/repositories/customer/customer_product_repository.dart';
import 'package:al_rova/repositories/customer/update_cart_product_repo.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/fonts.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:al_rova/utils/constants/strings.dart';
import 'package:al_rova/utils/services/local_storage.dart';
import 'package:al_rova/utils/widgets/best_deals_item.dart';
import 'package:al_rova/utils/widgets/categories_item.dart';
import 'package:al_rova/utils/widgets/common_search_box.dart';
import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
import 'package:al_rova/views/auth/select_crop.dart';
import 'package:al_rova/views/customer/address/add_new_address.dart';
import 'package:al_rova/views/customer/cart/cart.dart';
import 'package:al_rova/views/customer/ecommerce/help_guide.dart';
import 'package:al_rova/views/customer/ecommerce/product_details.dart';
import 'package:al_rova/views/customer/ecommerce/product_list.dart';
import 'package:al_rova/views/customer/ecommerce/wishlist.dart';
import 'package:al_rova/views/customer/profile/contact_us.dart';
import 'package:al_rova/views/notification/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class EcommerceHome extends StatefulWidget {
  const EcommerceHome({super.key});

  @override
  State<EcommerceHome> createState() => _EcommerceHomeState();
}

class _EcommerceHomeState extends State<EcommerceHome> {
  TextEditingController searchEditingController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GetEditedCustomerModel? getEditedCustomerModel;
  VerifyOtpModel? userModel;
  final localStorage = getIt<MySharedPref>();
  String wishlistCount = "0", cartCount = "0";

  @override
  void initState() {
    var rawData = localStorage.getUserData();

    if (rawData != null && rawData != "") {
      var userData = jsonDecode(rawData);

      userModel = VerifyOtpModel.fromJson(userData);
    }
    callAllApis();

    super.initState();
  }

// call api
  void callAllApis() {
    context
        .read<CustomerProductCubit>()
        .fetchAllProduct(userModel!.response!.roleId!);

    context
        .read<CartWishlistSimilarCubit>()
        .getCountOfWishlistAndCartProduct(userModel!.response!.roleId!);

    context.read<CategoryCubit>().getAllCategory();
    context
        .read<GetEditedCustomerCubit>()
        .getEditedCustomer(userModel!.response!.roleId!);
  }

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

// open terms & condition url
  // _launchURLBrowser() async {
  //   var url = Uri.parse("https://rova.acelucid.com/terms_condition.html");
  //   await launchUrl(url);
  // }

// open terms & condition url
  _launchRateUsURLBrowser() async {
    var url = Uri.parse(
        "https://play.google.com/store/apps/details?id=com.acelucid.al_rova");
    await launchUrl(url);
  }

  @override
  void dispose() {
    searchEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child:
              BlocConsumer<CartWishlistSimilarCubit, CartWishlistSimilarState>(
            listener: (context, state) {
              if (state is CountofWishlistAndCartProductSuccessState) {
                if (state.getCountofWishlistAndCartProducts.status ==
                    "success") {
                  wishlistCount = state
                      .getCountofWishlistAndCartProducts.wishListCount
                      .toString();
                  cartCount = state.getCountofWishlistAndCartProducts.cartCount
                      .toString();
                  setState(() {});
                }
              }
            },
            builder: (context, state) {
              return AppBar(
                backgroundColor: AppColors.primary,
                leading: InkWell(
                  onTap: () {
                    _openDrawer();
                  },
                  child: Center(
                      child: Image.asset(
                    Images.menu,
                    color: AppColors.white,
                    height: 45,
                    width: 45,
                    fit: BoxFit.contain,
                  )),
                ),
                leadingWidth: 65,
                actions: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const NotificationScreen()));
                    },
                    child: const Badge(
                      label: Text(
                        '2',
                        style: TextStyle(color: AppColors.white),
                      ),
                      backgroundColor: Colors.red,
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
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => const Wishlist()))
                          .then((value) {
                        context
                            .read<CustomerProductCubit>()
                            .fetchAllProduct(userModel!.response!.roleId!);
                        context
                            .read<CartWishlistSimilarCubit>()
                            .getCountOfWishlistAndCartProduct(
                                userModel!.response!.roleId!);
                        context.read<CategoryCubit>().getAllCategory();
                      });
                    },
                    child: Badge(
                      label: Text(
                        wishlistCount,
                        style: const TextStyle(color: AppColors.white),
                      ),
                      backgroundColor: Colors.red,
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: AppColors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                                create: (context) => CustomerProductCubit(
                                    customerProductRepository:
                                        getIt<CustomerProductRepository>())),
                            BlocProvider(
                              create: (context) => AddressCubit(
                                addressRepository: getIt<AddressRepository>(),
                              ),
                            ),
                            BlocProvider(
                              create: (context) => CartProductUpdateCubit(
                                updateCartProductRepository:
                                    getIt<UpdateCartProductRepository>(),
                              ),
                            ),
                          ],
                          child: Cart(
                            isBack: false,
                          ),
                        ),
                      ))
                          .then((value) {
                        context
                            .read<CustomerProductCubit>()
                            .fetchAllProduct(userModel!.response!.roleId!);
                        context
                            .read<CartWishlistSimilarCubit>()
                            .getCountOfWishlistAndCartProduct(
                                userModel!.response!.roleId!);
                        context.read<CategoryCubit>().getAllCategory();
                      });
                    },
                    child: Badge(
                      label: Text(
                        cartCount,
                        style: const TextStyle(color: AppColors.white),
                      ),
                      backgroundColor: Colors.red,
                      child: const Icon(
                        Icons.shopping_cart_rounded,
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
            },
          )),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 70),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              CommonSearchBox(
                textEditingController: searchEditingController,
                fillColor: AppColors.white,
                filled: false,
                isSuffix: true,
                hintText: AppStrings.whatAreYouLookingFor,
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 160,
                width: MediaQuery.of(context).size.width,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: 3,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {},
                      child: Center(
                        child: Image.asset(
                          Images.offerFrame,
                          width: 335,
                          height: 155,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      width: 10,
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              // category list ui

              BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  // if (state is CategoryLoadingState) {
                  //   return const Center(
                  //       child: SpinKitIndicator(
                  //     type: SpinKitType.circle,
                  //   ));
                  // }
                  if (state is GetAllCategorySuccessState) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCommonItem(
                          'Categories',
                          'See all',
                          onPressed: () {},
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 2,
                                  mainAxisSpacing: 5),
                          itemBuilder: (BuildContext context, int index) {
                            return CategoriesItem(
                              onTap: () {
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         const CategoriesInfo(categoryName: ,),
                                //   ),
                                // );
                              },
                              title: state.getAllCategory.response![index]
                                  .productCategoryName!,
                              image:
                                  state.getAllCategory.response![index].image!,
                            );
                          },
                        ),
                      ],
                    );
                  } else {
                    return const Text('');
                  }
                },
              ),

              const SizedBox(
                height: 10,
              ),

              // product list ui

              BlocBuilder<CustomerProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoadingState) {
                    return const Center(
                        child: SpinKitIndicator(
                      type: SpinKitType.circle,
                    ));
                  }
                  if (state is SuccessState) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showCustomToast(
                          context, state.successResponse.message!, false);
                    });
                  }
                  if (state is GetProductSuccessState) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCommonItem(
                          'Best deals 🔥',
                          'See all',
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => CustomerProductCubit(
                                  customerProductRepository: getIt(),
                                ),
                                child: ProductList(
                                  isBestDeal: true,
                                ),
                              ),
                            ))
                                .then((value) {
                              context
                                  .read<CustomerProductCubit>()
                                  .fetchAllProduct(
                                      userModel!.response!.roleId!);
                              context
                                  .read<CartWishlistSimilarCubit>()
                                  .getCountOfWishlistAndCartProduct(
                                      userModel!.response!.roleId!);
                              context.read<CategoryCubit>().getAllCategory();
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
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
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => ProductDetails(
                                        customerId:
                                            userModel!.response!.roleId!,
                                        productId: state
                                            .getAllProductModel[index]
                                            .productId!,
                                      ),
                                    ))
                                        .then((value) {
                                      context
                                          .read<CustomerProductCubit>()
                                          .fetchAllProduct(
                                              userModel!.response!.roleId!);
                                      context
                                          .read<CartWishlistSimilarCubit>()
                                          .getCountOfWishlistAndCartProduct(
                                              userModel!.response!.roleId!);
                                      context
                                          .read<CategoryCubit>()
                                          .getAllCategory();
                                    });
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
                                        // "sellerId": state
                                        //     .getAllProductModel[index].sellerId,
                                      };
                                      context
                                          .read<CustomerProductCubit>()
                                          .addProductToWishlist(params)
                                          .then((value) {
                                        context
                                            .read<CustomerProductCubit>()
                                            .fetchAllProduct(
                                                userModel!.response!.roleId!);
                                        context
                                            .read<CartWishlistSimilarCubit>()
                                            .getCountOfWishlistAndCartProduct(
                                                userModel!.response!.roleId!);
                                      });
                                    } else {
                                      // context
                                      //     .read<CustomerProductCubit>()
                                      //     .deleteProductFromWishlist(
                                      //         userModel!.response!.roleId!,
                                      //         state.getAllProductModel[index]
                                      //             .productId!)
                                      //     .then((value) {
                                      //   context
                                      //       .read<CustomerProductCubit>()
                                      //       .fetchAllProduct(
                                      //           userModel!.response!.roleId!);
                                      //   context
                                      //       .read<CartWishlistSimilarCubit>()
                                      //       .getCountOfWishlistAndCartProduct(
                                      //           userModel!.response!.roleId!);
                                      // });
                                    }
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
                              itemCount: state.getAllProductModel.length),
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              // const SizedBox(
              //   height: 10,
              // ),

              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
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
                  SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: BlocBuilder<GetEditedCustomerCubit,
                          GetEditedCustomerState>(
                        builder: (context, state) {
                          if (state is GetEditedCustomerSuccess) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    state.getEditedCustomerModel.name ?? "",
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
                                  state.getEditedCustomerModel.phoneNumber ??
                                      "",
                                  style: const TextStyle(
                                      color: AppColors.gary,
                                      fontSize: 15,
                                      fontFamily: Fonts.dmSansSemiBold,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildLowerDrawerItems(AppStrings.agriBook, onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SelectCrop(),
                ),
              );
            }),
            _buildLowerDrawerItems(
              AppStrings.rateUs,
              onPressed: () {
                Navigator.of(context).pop();
                _launchRateUsURLBrowser();
              },
            ),
            _buildLowerDrawerItems(
              AppStrings.addNewAddress,
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) =>
                            AddressCubit(addressRepository: getIt()),
                        child: AddNewAddress(
                          isEdit: false,
                        ),
                      ),
                    ))
                    .then((value) => context
                        .read<AddressCubit>()
                        .fetchAllAddress(userModel!.response!.roleId!));
              },
            ),
            // _buildLowerDrawerItems(
            //   AppStrings.termsCondition,
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //     _launchURLBrowser();
            //   },
            // ),
            _buildLowerDrawerItems(
              AppStrings.helpGuide,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HelpGuide()));
              },
            ),
            _buildLowerDrawerItems(
              AppStrings.shareApp,
              onPressed: () {
                shareAppLink();
              },
            ),
            _buildLowerDrawerItems(
              AppStrings.contactUs,
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactUs(),
                    ));
              },
            ),
            const Divider(
              height: 1,
              color: AppColors.lightGary,
            ),
            const SizedBox(
              height: 20,
            ),
            _buildDrawerItem(
              Icons.logout,
              AppStrings.logout,
              onPressed: () {
                _logoutDialogBuilder(context);
              },
            ),
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          InkWell(
            onTap: onPressed,
            child: Text(
              suffix,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ],
      ),
    );
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

  //
  Widget _buildLowerDrawerItems(String label,
      {required void Function() onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: onPressed,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
              fontFamily: Fonts.poppins,
            ),
          ),
        ),
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
              child: const Text(
                AppStrings.yesLogout,
                style: TextStyle(
                    fontFamily: Fonts.poppins, color: AppColors.white),
              ),
              onPressed: () {
                context.read<UserAuthCubit>().logout();
                Navigator.of(context).pop();
                _scaffoldKey.currentState!.closeEndDrawer();
              },
            ),
          ],
        );
      },
    );
  }

  // delete account dialog
  Future<void> _deleteDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 320,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  Images.delete,
                  width: 200,
                  height: 200,
                ),
                const Text(
                  AppStrings.deleteAccount,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: Fonts.poppins,
                    fontSize: 20,
                  ),
                ),
                const Text(
                  AppStrings.accountDeleteMsg,
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
                'No',
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
              child: const Text('Yes',
                  style: TextStyle(
                      fontFamily: Fonts.poppins, color: AppColors.white)),
              onPressed: () async {
                context.read<AuthCubit>().deleteUserAccount("9110951615");
                Navigator.of(context).pop();
                _scaffoldKey.currentState!.closeEndDrawer();
              },
            ),
          ],
        );
      },
    );
  }

  void shareAppLink() {
    String appLink =
        "https://play.google.com/store/apps/details?id=com.acelucid.al_rova";
    Share.share(
      'Check out our amazing app, ROVA! Find the best deals on all your farming needs. Start shopping today: $appLink',
    );
  }
}
