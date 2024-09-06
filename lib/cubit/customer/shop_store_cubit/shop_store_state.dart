import 'package:al_rova/models/customer/store/shop_store_model.dart';
import 'package:equatable/equatable.dart';

abstract class ShopStoreState extends Equatable {
  const ShopStoreState();

  @override
  List<Object> get props => [];
}

class ShopStoreInitial extends ShopStoreState {}

class ShopStoreLoding extends ShopStoreState {}

class ShopStoreSuccess extends ShopStoreState {
  final List<StoreShopModel> storeShopList;

  const ShopStoreSuccess(this.storeShopList);

  @override
  List<Object> get props => [storeShopList];
}

class ShopStoreError extends ShopStoreState {
  final String message;

  const ShopStoreError(this.message);

  @override
  List<Object> get props => [message];
}
