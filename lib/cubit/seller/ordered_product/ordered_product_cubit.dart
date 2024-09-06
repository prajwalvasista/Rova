import 'package:al_rova/cubit/seller/ordered_product/ordered_product_state.dart';
import 'package:al_rova/repositories/seller/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderedProductCubit extends Cubit<OrderedProductState> {
  final ProductRepository productRepository;
  OrderedProductCubit({required this.productRepository})
      : super(OrderedProductInitialState());

// add product cubit
  Future<dynamic> getTotalOrderdProductsForSeller(String sellerId) async {
    emit(OrderedProductLoadingState());

    final result =
        await productRepository.getTotalOrderdProductsForSeller(sellerId);
    result.fold((failure) {
      emit(OrderedProductErrorState(failure.message));
    }, (r) {
      return emit(OrderedProductSuccessState(r));
    });
  }
}
