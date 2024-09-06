import 'package:al_rova/cubit/seller/product_cubit/product_state.dart';
import 'package:al_rova/repositories/seller/product_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository productRepository;
  ProductCubit({required this.productRepository})
      : super(ProductInitialState());

// fetch all product cubit
  Future<dynamic> fetchAllProduct(String id) async {
    emit(ProductLoadingState());
    final result = await productRepository.getAllProducts();
    result.fold((failure) {
      emit(ProductErrorState(failure.message));
      // return [];
    }, (r) {
      return emit(GetProductSuccessState(r));
    });
  }

// add product cubit
  Future<dynamic> addProduct(FormData params) async {
    emit(ProductLoadingState());

    final result = await productRepository.addProduct(params);
    result.fold((failure) {
      emit(ProductErrorState(failure.message));
    }, (r) {
      return emit(ProductSuccessState(r));
    });
  }

// edit product cubit
  Future<dynamic> editProduct(FormData params, int productId, int id) async {
    emit(ProductLoadingState());

    final result = await productRepository.editProduct(params, productId, id);
    result.fold((failure) {
      emit(ProductErrorState(failure.message));
    }, (r) {
      return emit(SuccessState(r));
    });
  }

// delete product cubit
  Future<dynamic> deleteProduct(int productId, String sellerId) async {
    emit(ProductLoadingState());
    final result = await productRepository.deleteProduct(productId, sellerId);
    result.fold((failure) {
      emit(ProductErrorState(failure.message));
      // return [];
    }, (r) {
      return emit(SuccessState(r));
    });
  }

// get product by id cubit
  Future<dynamic> getProductById(int productId, String sellerId) async {
    emit(ProductLoadingState());
    final result = await productRepository.getProductById(productId, sellerId);
    result.fold((failure) {
      emit(ProductErrorState(failure.message));
      // return [];
    }, (r) {
      return emit(GetProductByIdSuccessState(r));
    });
  }

// get product by id cubit
  Future<dynamic> getProductBySellerId(String id) async {
    emit(ProductLoadingState());
    final result = await productRepository.getProductBySellerId(id);
    result.fold((failure) {
      emit(ProductErrorState(failure.message));
      // return [];
    }, (r) {
      return emit(GetProductSuccessState(r));
    });
  }

  // get seller detail cubit
  Future<dynamic> getSellerDetails(String phoneNumber, sellerId) async {
    emit(ProductLoadingState());
    final result = await productRepository.getSellerDetails(phoneNumber);
    result.fold((failure) {
      emit(ProductErrorState(failure.message));
      // return [];
    }, (r) {
      // if (r.response != null) {
      //   if (r.response!.isApproved!) {
      //     getProductById(sellerId);
      //   }
      // }
      return emit(SellerDetailSuccessState(r));
    });
  }

  // getAllOrderList cubit
  Future<dynamic> getAllOrderList(String sellerId) async {
    emit(ProductLoadingState());
    final result = await productRepository.getAllOrderList(sellerId);
    result.fold((failure) {
      emit(ProductErrorState(failure.message));
      // return [];
    }, (r) {
      return emit(OrderListSuccessState(r));
    });
  }

  // approveOrder cubit
  Future<dynamic> approveOrder(FormData params) async {
    emit(ProductLoadingState());
    final result = await productRepository.approveOrder(params);
    result.fold((failure) {
      emit(ProductErrorState(failure.message));
      // return [];
    }, (r) {
      return emit(SuccessState(r));
    });
  }
}
