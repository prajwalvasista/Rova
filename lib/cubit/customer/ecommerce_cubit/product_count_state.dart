import 'package:equatable/equatable.dart';

class ProductCountState extends Equatable {
  final int productCount;

  const ProductCountState({required this.productCount});

  @override
  List<Object?> get props => [productCount];

  ProductCountState copyWith({int? productCount}) {
    return ProductCountState(productCount: productCount ?? this.productCount);
  }
}
