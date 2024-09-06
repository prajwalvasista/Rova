class CouponModel {
  int? couponId;
  String? coupon;
  int? price;
  String? startDate;
  String? expiryDate;
  bool? isCouponActive;

  CouponModel(
      {this.couponId,
      this.coupon,
      this.price,
      this.startDate,
      this.expiryDate,
      this.isCouponActive});

  CouponModel.fromJson(Map<String, dynamic> json) {
    couponId = json['couponId'];
    coupon = json['coupon'];
    price = json['price'];
    startDate = json['startDate'];
    expiryDate = json['expiryDate'];
    isCouponActive = json['isCouponActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['couponId'] = couponId;
    data['coupon'] = coupon;
    data['price'] = price;
    data['startDate'] = startDate;
    data['expiryDate'] = expiryDate;
    data['isCouponActive'] = isCouponActive;
    return data;
  }
}
