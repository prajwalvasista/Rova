import 'package:al_rova/cubit/customer/cart_update_cubit/cart_update_state.dart';
import 'package:al_rova/repositories/customer/update_cart_product_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartProductUpdateCubit extends Cubit<CartProductUpdateState> {
  final UpdateCartProductRepository updateCartProductRepository;

  CartProductUpdateCubit({required this.updateCartProductRepository})
      : super(CartUpdateInitialState());

  //increase the product count

  Future<dynamic> updateProductInCart(Map<String, dynamic> params) async {
    emit(CartUpdateLoadingState());
    final response =
        await updateCartProductRepository.updateProductInCart(params);

    response.fold((failure) {
      emit(CartUpdateErrorState(failure.message));
    }, (r) {
      return emit(UpdateCartProductSuccessState(r));
    });
  }

  // // delete the product in cart

  // Future<dynamic> deleteProductFromCart(
  //     String customerId, int productId) async {
  //   //emit(ProductLoadingState());
  //   final result = await customerProductRepository.deleteProductFromCart(
  //       customerId, productId);
  //   result.fold((failure) {
  //     emit(CartUpdateErrorState(failure.message));
  //     // return [];
  //   }, (r) {
  //     return emit(CartDeleteSuccessState(r));
  //   });
  // }
}
