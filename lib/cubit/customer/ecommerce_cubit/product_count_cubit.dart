import 'package:al_rova/cubit/customer/ecommerce_cubit/product_count_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCountCubit extends Cubit<ProductCountState> {
  ProductCountCubit() : super(const ProductCountState(productCount: 1));

  void incrementProductCount(int index) {
    emit(state.copyWith(productCount: state.productCount + 1));
  }

  void decreaseProductCount() {
    if (state.productCount > 1) {
      emit(state.copyWith(productCount: state.productCount - 1));
    }
  }
}
