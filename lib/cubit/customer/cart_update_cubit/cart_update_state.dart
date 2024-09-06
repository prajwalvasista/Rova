import 'package:al_rova/models/customer/product/add_update_delete_product_to_cart_model.dart';
import 'package:equatable/equatable.dart';

abstract class CartProductUpdateState extends Equatable {
  const CartProductUpdateState();

  @override
  List<Object> get props => [];
}

class CartUpdateInitialState extends CartProductUpdateState {}

class CartUpdateLoadingState extends CartProductUpdateState {}

class CartUpdateErrorState extends CartProductUpdateState {
  final String message;

  const CartUpdateErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class UpdateCartProductSuccessState extends CartProductUpdateState {
  final AddEditDeleteProductToCartModel addEditDeleteProductToCartModel;

  const UpdateCartProductSuccessState(this.addEditDeleteProductToCartModel);

  @override
  List<Object> get props => [addEditDeleteProductToCartModel];
}

class CartDeleteSuccessState extends CartProductUpdateState {
  final AddEditDeleteProductToCartModel addEditDeleteProductToCartModel;

  const CartDeleteSuccessState(this.addEditDeleteProductToCartModel);

  @override
  List<Object> get props => [addEditDeleteProductToCartModel];
}

