import 'package:al_rova/models/auth/verify_otp_model.dart';
import 'package:al_rova/models/seller/product/get_all_product_model.dart';
import 'package:al_rova/models/seller/product/get_product_by_id.dart';
import 'package:al_rova/models/seller/product/get_seller_details_model.dart';
import 'package:al_rova/models/seller/product/order_list_model.dart';
import 'package:al_rova/models/success/success_response_model.dart';
import 'package:equatable/equatable.dart';
import 'package:al_rova/models/seller/product/add_product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitialState extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductSuccessState extends ProductState {
  final AddProductModel addProductModel;
  const ProductSuccessState(this.addProductModel);

  @override
  List<Object> get props => [addProductModel];
}

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

class SuccessState extends ProductState {
  final SuccessResponse successResponse;

  const SuccessState(this.successResponse);

  @override
  List<Object> get props => [successResponse];
}

class GetProductByIdSuccessState extends ProductState {
  final GetAllProductModel getProductByIdModel;

  const GetProductByIdSuccessState(this.getProductByIdModel);

  @override
  List<Object> get props => [getProductByIdModel];
}

class SellerDetailSuccessState extends ProductState {
  final GetSellerDetailsModel getSellerDetailsModel;

  const SellerDetailSuccessState(this.getSellerDetailsModel);

  @override
  List<Object> get props => [getSellerDetailsModel];
}

// order list success list
class OrderListSuccessState extends ProductState {
  final List<OrderListModel> orderListModel;

  const OrderListSuccessState(this.orderListModel);

  @override
  List<Object> get props => [orderListModel];
}
