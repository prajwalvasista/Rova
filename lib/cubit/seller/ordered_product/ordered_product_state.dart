import 'package:al_rova/models/seller/product/get_ordered_product_count_model.dart';
import 'package:equatable/equatable.dart';

abstract class OrderedProductState extends Equatable {
  const OrderedProductState();

  @override
  List<Object> get props => [];
}

class OrderedProductInitialState extends OrderedProductState {}

class OrderedProductLoadingState extends OrderedProductState {}

class OrderedProductSuccessState extends OrderedProductState {
  final GetOrderProductsCountModel getOrderProductsCountModel;
  const OrderedProductSuccessState(this.getOrderProductsCountModel);

  @override
  List<Object> get props => [getOrderProductsCountModel];
}

class OrderedProductErrorState extends OrderedProductState {
  final String message;

  const OrderedProductErrorState(this.message);

  @override
  List<Object> get props => [message];
}
