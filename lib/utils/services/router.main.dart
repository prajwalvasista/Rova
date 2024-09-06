part of 'router.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return _pageBuilder((_) => const SplashScreen(), settings: settings);
    case AppRoutes.selectCrop:
      return _pageBuilder((_) => const SelectCrop(), settings: settings);
    case AppRoutes.login:
      return _pageBuilder(
        (_) => const Login(),
        settings: settings,
      );

    case AppRoutes.register:
      return _pageBuilder((_) => const Register(), settings: settings);

    case AppRoutes.otp:
      String phoneNumber = "";
      if (settings.arguments != null) {
        phoneNumber = settings.arguments as String;
      }

      return _pageBuilder(
          (_) => Otp(
                phoneNumber: phoneNumber,
                roleId: 0,
              ),
          settings: settings);

    case AppRoutes.customerHome:
      return _pageBuilder(
          (_) => MultiBlocProvider(
                providers: [
                  BlocProvider<CustomerProductCubit>(
                    create: (context) => getIt<CustomerProductCubit>(),
                  ),
                  BlocProvider<CartWishlistSimilarCubit>(
                    create: (context) => getIt<CartWishlistSimilarCubit>(),
                  ),
                  BlocProvider<CategoryCubit>(
                    create: (context) => getIt<CategoryCubit>(),
                  ),
                ],
                child: const CustomerHome(),
              ),
          settings: settings);

    case AppRoutes.sellerHome:
      return _pageBuilder(
          (_) => MultiBlocProvider(
                providers: [
                  BlocProvider<ProductCubit>(
                    create: (context) => getIt<ProductCubit>(),
                  ),
                  BlocProvider<OrderedProductCubit>(
                    create: (context) => getIt<OrderedProductCubit>(),
                  ),
                ],
                child: const SellerHome(),
              ),
          settings: settings);

    default:
      return _pageBuilder(
        (_) => const SplashScreen(),
        settings: settings,
      );
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder: (_, animation, __, child) => FadeTransition(
      opacity: animation,
      child: child,
    ),
    pageBuilder: (context, _, __) => page(context),
  );
}
