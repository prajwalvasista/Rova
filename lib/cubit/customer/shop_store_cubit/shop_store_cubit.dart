import 'package:al_rova/cubit/customer/shop_store_cubit/shop_store_state.dart';
import 'package:al_rova/repositories/customer/shop_store_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopStoreCubit extends Cubit<ShopStoreState> {
  final ShopStoreRepository shopStoreRepository;
  ShopStoreCubit({required this.shopStoreRepository})
      : super(ShopStoreInitial());

  Future<dynamic> fetchShopStore(String cityName) async {
    emit(ShopStoreLoding());

    final result = await shopStoreRepository.getShopStore(cityName);
    result.fold(
      (failure) {
        emit(ShopStoreError(failure.message));
        // return [];
      },
      (r) {
        emit(ShopStoreSuccess(r));
        //  return r;
      },
    );
  }
}
