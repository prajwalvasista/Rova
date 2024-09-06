import 'dart:io';

import 'package:al_rova/common/cubit/user_authentication_cubit.dart';
import 'package:al_rova/cubit/auth_cubit/auth_cubit.dart';
import 'package:al_rova/cubit/coupons/get_coupons_cubit.dart';
import 'package:al_rova/cubit/customer/cart_wishlist_similar/cart_wishlist_similar_cubit.dart';
import 'package:al_rova/cubit/customer/address_cubit/address_cubit.dart';
import 'package:al_rova/cubit/customer/category/category_cubit.dart';
import 'package:al_rova/cubit/customer/crop_cubit/crop_cubit.dart';
import 'package:al_rova/cubit/customer/edit_customer_cubit/edit_customer_cubit.dart';
import 'package:al_rova/cubit/customer/get_edited_customer_cubit/get_edited_customer_cubit.dart';
import 'package:al_rova/cubit/customer/product_cubit/product_cubit.dart';
import 'package:al_rova/cubit/customer/shop_store_cubit/shop_store_cubit.dart';
import 'package:al_rova/cubit/seller/ordered_product/ordered_product_cubit.dart';
import 'package:al_rova/cubit/seller/product_cubit/product_cubit.dart';
import 'package:al_rova/cubit/seller/seller_commercial_details_cubit/seller_commercial_details_cubit.dart';
import 'package:al_rova/di.dart';
import 'package:al_rova/utils/constants/fonts.dart';
import 'package:al_rova/utils/services/navigation_service.dart';
import 'package:al_rova/utils/services/route_constant.dart';
import 'package:al_rova/utils/services/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ShopStoreCubit>(
            create: (context) => getIt<ShopStoreCubit>()),
        BlocProvider<UserAuthCubit>(
            create: (context) => getIt<UserAuthCubit>()),
        BlocProvider<AuthCubit>(create: (context) => getIt<AuthCubit>()),
        BlocProvider<CropCubit>(
          create: (context) => getIt<CropCubit>(),
        ),
        BlocProvider<ProductCubit>(
          create: (context) => getIt<ProductCubit>(),
        ),
        BlocProvider<CustomerProductCubit>(
          create: (context) => getIt<CustomerProductCubit>(),
        ),
        BlocProvider<CartWishlistSimilarCubit>(
          create: (context) => getIt<CartWishlistSimilarCubit>(),
        ),
        BlocProvider<CategoryCubit>(
          create: (context) => getIt<CategoryCubit>(),
        ),
        BlocProvider<SellerCommercialDetailsCubit>(
          create: (context) => getIt<SellerCommercialDetailsCubit>(),
        ),
        BlocProvider<EditCustomerCubit>(
          create: (context) => getIt<EditCustomerCubit>(),
        ),
        BlocProvider<OrderedProductCubit>(
          create: (context) => getIt<OrderedProductCubit>(),
        ),
        BlocProvider<AddressCubit>(
          create: (context) => getIt<AddressCubit>(),
        ),
        BlocProvider<GetEditedCustomerCubit>(
          create: (context) => getIt<GetEditedCustomerCubit>(),
        ),
        BlocProvider<GetCouponsCubit>(
          create: (context) => getIt<GetCouponsCubit>(),
        ),
      ],
      child: MaterialApp(
        // home: const SplashScreen(),
        themeMode: ThemeMode.system,
        theme: ThemeData(
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,

          fontFamily: Fonts.dmSansRegular,
          appBarTheme: const AppBarTheme(
            color: Colors.transparent,
          ),
          //  colorScheme: ColorScheme.fromSwatch(accentColor: AppColors.primary),
        ),
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splashScreen,
        onGenerateRoute: generateRoute,
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
