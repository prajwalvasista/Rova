import 'package:al_rova/cubit/customer/cart_wishlist_similar/cart_wishlist_similar_state.dart';
import 'package:al_rova/cubit/customer/product_cubit/product_state.dart';
import 'package:al_rova/repositories/customer/customer_product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartWishlistSimilarCubit extends Cubit<CartWishlistSimilarState> {
  final CustomerProductRepository customerProductRepository;
  CartWishlistSimilarCubit({required this.customerProductRepository})
      : super(CartWishlistSimilarInitialState());

  //getCountOfWishlistAndCartProduct cubit
  Future<dynamic> getCountOfWishlistAndCartProduct(String customerId) async {
    emit(CartWishlistSimilarLoadingState());
    final res = await customerProductRepository
        .getCountOfWishlistAndCartProduct(customerId);
    res.fold((failure) {
      emit(CartWishlistSimilarErrorState(failure.message));
    }, (r) {
      return emit(CountofWishlistAndCartProductSuccessState(r));
    });
  }

  // getAllSimilarProducts cubit
  Future<dynamic> getAllSimilarProducts(String category) async {
    emit(CartWishlistSimilarLoadingState());
    final result =
        await customerProductRepository.getAllSimilarProducts(category);
    result.fold((failure) {
      emit(CartWishlistSimilarErrorState(failure.message));
      // return [];
    }, (r) {
      return emit(GetSimilarProductSuccessState(r));
    });
  }
}
