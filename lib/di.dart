import 'package:al_rova/common/cubit/user_authentication_cubit.dart';
import 'package:al_rova/core/network/api_service.dart';
import 'package:al_rova/core/network/dio_factory.dart';
import 'package:al_rova/core/network/network_info.dart';
import 'package:al_rova/cubit/coupons/get_coupons_cubit.dart';
import 'package:al_rova/cubit/customer/cart_update_cubit/cart_update_cubit.dart';
import 'package:al_rova/cubit/customer/cart_wishlist_similar/cart_wishlist_similar_cubit.dart';
import 'package:al_rova/cubit/customer/address_cubit/address_cubit.dart';
import 'package:al_rova/cubit/auth_cubit/auth_cubit.dart';
import 'package:al_rova/cubit/customer/category/category_cubit.dart';
import 'package:al_rova/cubit/customer/crop_cubit/crop_cubit.dart';
import 'package:al_rova/cubit/customer/edit_customer_cubit/edit_customer_cubit.dart';
import 'package:al_rova/cubit/customer/get_edited_customer_cubit/get_edited_customer_cubit.dart';
import 'package:al_rova/cubit/customer/product_cubit/product_cubit.dart';
import 'package:al_rova/cubit/customer/shop_store_cubit/shop_store_cubit.dart';
import 'package:al_rova/cubit/seller/ordered_product/ordered_product_cubit.dart';
import 'package:al_rova/cubit/seller/product_cubit/product_cubit.dart';
import 'package:al_rova/repositories/coupons/get_coupons_repo.dart';
import 'package:al_rova/repositories/customer/address_repository.dart';
import 'package:al_rova/repositories/auth/auth_repo.dart';
import 'package:al_rova/repositories/customer/crop_repository.dart';
import 'package:al_rova/repositories/customer/customer_product_repository.dart';
import 'package:al_rova/repositories/customer/edit_customer_repository.dart';
import 'package:al_rova/repositories/customer/get_edited_customer_repository.dart';
import 'package:al_rova/repositories/customer/shop_store_repository.dart';
import 'package:al_rova/repositories/customer/update_cart_product_repo.dart';
import 'package:al_rova/repositories/seller/product_repository.dart';
import 'package:al_rova/repositories/seller/seller_repository.dart';
import 'package:al_rova/utils/services/local_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => prefs);
  getIt.registerLazySingleton<MySharedPref>(() => MySharedPref(getIt()));

  getIt.registerLazySingleton<DioFactory>(() => DioFactory());
  final dio = await getIt<DioFactory>().getDio();

  getIt.registerLazySingleton(() => ApiService(
        dio,
        getIt(),
      ));
  //Dio
  // getIt.registerLazySingleton<Dio>(() => Dio());
  // getIt.registerLazySingleton<DioClient>(() => DioClient(getIt<Dio>()));

  // Shop api
  // getIt.registerLazySingleton<StoreShopApi>(
  //     () => StoreShopApi(dioClient: getIt<DioClient>()));

  //  repository
  getIt.registerLazySingleton<ShopStoreRepository>(
    () => ShopStoreRepository(apiService: getIt(), networkInfo: getIt()),
  );

  getIt.registerLazySingleton<GetCouponsRepo>(
    () => GetCouponsRepo(apiService: getIt(), networkInfo: getIt()),
  );

  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(
      apiServcie: getIt(), networkInfo: getIt(), mySharedPref: getIt()));

  getIt.registerLazySingleton<CropRepository>(
      () => CropRepository(networkInfo: getIt(), apiService: getIt()));

  getIt.registerLazySingleton<AddressRepository>(
      () => AddressRepository(apiService: getIt(), networkInfo: getIt()));

  getIt.registerLazySingleton<EditCustomerRepository>(
      () => EditCustomerRepository(apiService: getIt(), networkInfo: getIt()));

  getIt.registerLazySingleton<GetEditedCustomerRepository>(() =>
      GetEditedCustomerRepository(apiService: getIt(), networkInfo: getIt()));

  //
  // getIt.registerLazySingleton<DioFactory>(() => DioFactory());
  getIt.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));

  //Shop Store Bloc
  getIt.registerFactory(
      () => ShopStoreCubit(shopStoreRepository: getIt<ShopStoreRepository>()));

  getIt.registerFactory(
      () => AuthCubit(authRepository: getIt<AuthRepository>()));

  getIt.registerFactory(
      () => GetCouponsCubit(getCouponsRepo: getIt<GetCouponsRepo>()));

  getIt.registerFactory(() => UserAuthCubit(localDataSource: getIt()));

  // crop
  getIt.registerFactory(
      () => CropCubit(cropRepository: getIt<CropRepository>()));

  // address
  getIt.registerFactory(
      () => AddressCubit(addressRepository: getIt<AddressRepository>()));

  // category
  getIt.registerFactory(() => CategoryCubit(
      customerProductRepository: getIt<CustomerProductRepository>()));

  // customer
  getIt.registerFactory(() => CustomerProductCubit(
      customerProductRepository: getIt<CustomerProductRepository>()));

  getIt.registerFactory(() => CartWishlistSimilarCubit(
      customerProductRepository: getIt<CustomerProductRepository>()));

  getIt.registerFactory(() => EditCustomerCubit(
      editCustomerRepository: getIt<EditCustomerRepository>()));
  getIt.registerFactory(() => GetEditedCustomerCubit(
      getEditedCustomerRepository: getIt<GetEditedCustomerRepository>()));

  // seller
  getIt.registerFactory(
      () => ProductCubit(productRepository: getIt<ProductRepository>()));

  getIt.registerFactory(
      () => OrderedProductCubit(productRepository: getIt<ProductRepository>()));

  getIt.registerLazySingleton<SellerRepository>(
      () => SellerRepository(apiService: getIt(), networkInfo: getIt()));

  getIt.registerLazySingleton<ProductRepository>(
      () => ProductRepository(apiService: getIt(), networkInfo: getIt()));

// customer repository
  getIt.registerLazySingleton<CustomerProductRepository>(() =>
      CustomerProductRepository(
          apiService: getIt(), networkInfo: getIt(), mySharedPref: getIt()));

  // update product
  getIt.registerLazySingleton<UpdateCartProductRepository>(() =>
      UpdateCartProductRepository(
          apiService: getIt(), networkInfo: getIt(), mySharedPref: getIt()));

  getIt.registerFactory(() => CartProductUpdateCubit(
      updateCartProductRepository: getIt<UpdateCartProductRepository>()));
}
