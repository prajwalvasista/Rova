import 'package:al_rova/models/customer/product/get_all_product_model.dart';
import 'package:al_rova/models/customer/product/get_count_of_wishlist_cart_product_model.dart';
import 'package:equatable/equatable.dart';

abstract class CartWishlistSimilarState extends Equatable {
  const CartWishlistSimilarState();

  @override
  List<Object> get props => [];
}

class CartWishlistSimilarInitialState extends CartWishlistSimilarState {}

class CartWishlistSimilarLoadingState extends CartWishlistSimilarState {}

class CartWishlistSimilarErrorState extends CartWishlistSimilarState {
  final String message;

  const CartWishlistSimilarErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class GetSimilarProductSuccessState extends CartWishlistSimilarState {
  final List<GetAllProductModel> getAllProductModel;
  const GetSimilarProductSuccessState(this.getAllProductModel);

  @override
  List<Object> get props => [getAllProductModel];
}

class CountofWishlistAndCartProductSuccessState
    extends CartWishlistSimilarState {
  final GetCountofWishlistAndCartProducts getCountofWishlistAndCartProducts;
  const CountofWishlistAndCartProductSuccessState(
      this.getCountofWishlistAndCartProducts);

  @override
  List<Object> get props => [getCountofWishlistAndCartProducts];
}
