class GetCountofWishlistAndCartProducts {
  String? status;
  int? wishListCount;
  int? cartCount;

  GetCountofWishlistAndCartProducts(
      {this.status, this.wishListCount, this.cartCount});

  GetCountofWishlistAndCartProducts.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    wishListCount = json['wishListCount'];
    cartCount = json['cartCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['wishListCount'] = wishListCount;
    data['cartCount'] = cartCount;
    return data;
  }
}
