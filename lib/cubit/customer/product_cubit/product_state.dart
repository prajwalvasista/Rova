import 'package:al_rova/models/customer/product/add_update_delete_product_to_cart_model.dart';
import 'package:al_rova/models/customer/product/get_all_category.dart';
import 'package:al_rova/models/customer/product/get_all_product_model.dart';
import 'package:al_rova/models/customer/product/get_all_wishlist_product.dart';
import 'package:al_rova/models/customer/product/get_count_of_wishlist_cart_product_model.dart';
import 'package:al_rova/models/customer/product/view_product_in_cart_model.dart';
import 'package:al_rova/models/customer/order/get_ordered_product_for_customer_model.dart';
import 'package:al_rova/models/success/success_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitialState extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductErrorState extends ProductState {
  final String message;

  const ProductErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class GetProductSuccessState extends ProductState {
  final List<GetAllProductModel> getAllProductModel;
  const GetProductSuccessState(this.getAllProductModel);

  @override
  List<Object> get props => [getAllProductModel];
}

class GetWishlistProductSuccessState extends ProductState {
  final List<GetAllWishlistProductModel> getAllWishlistProductModel;
  const GetWishlistProductSuccessState(this.getAllWishlistProductModel);

  @override
  List<Object> get props => [getAllWishlistProductModel];
}

class SuccessState extends ProductState {
  final SuccessResponse successResponse;

  const SuccessState(this.successResponse);

  @override
  List<Object> get props => [successResponse];
}

class GetProductByIdSuccessState extends ProductState {
  final GetAllProductModel getAllProductModel;

  const GetProductByIdSuccessState(this.getAllProductModel);

  @override
  List<Object> get props => [getAllProductModel];
}

class AddEditDeleteProductToCartSuccessState extends ProductState {
  final AddEditDeleteProductToCartModel addEditDeleteProductToCartModel;

  const AddEditDeleteProductToCartSuccessState(
      this.addEditDeleteProductToCartModel);

  @override
  List<Object> get props => [addEditDeleteProductToCartModel];
}

class ViewProductInCartSuccessState extends ProductState {
  final List<ViewProductInCartModel> getAllCartProduct;
  const ViewProductInCartSuccessState(this.getAllCartProduct);

  @override
  List<Object> get props => [getAllCartProduct];
}

class GetOrderedProductForCustomerSuccess extends ProductState {
  final List<GetOrderedProductForCustomerModel>
      getOrderedProductForCustomerModel;

  const GetOrderedProductForCustomerSuccess(
      this.getOrderedProductForCustomerModel);

  @override
  List<Object> get props => [getOrderedProductForCustomerModel];
}

class GetCountofWishlistAndCartProductSuccessState extends ProductState {
  final GetCountofWishlistAndCartProducts getCountofWishlistAndCartProducts;
  const GetCountofWishlistAndCartProductSuccessState(
      this.getCountofWishlistAndCartProducts);

  @override
  List<Object> get props => [getCountofWishlistAndCartProducts];
}

class GetOrderByOrderIdAndCustomerIdSuccess extends ProductState {
  final GetOrderedProductForCustomerModel getOrderedProductForCustomerModel;

  const GetOrderByOrderIdAndCustomerIdSuccess(
      this.getOrderedProductForCustomerModel);

  @override
  List<Object> get props => [getOrderedProductForCustomerModel];
}
