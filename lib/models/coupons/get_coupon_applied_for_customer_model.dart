class GetCouponAppliedForCustomerModel {
  int? appliedCouponId;
  String? coupon;
  String? customerId;
  int? totalAmount;
  bool? isCouponApplied;

  GetCouponAppliedForCustomerModel(
      {this.appliedCouponId,
      this.coupon,
      this.customerId,
      this.totalAmount,
      this.isCouponApplied});

  GetCouponAppliedForCustomerModel.fromJson(Map<String, dynamic> json) {
    appliedCouponId = json['appliedCouponId'];
    coupon = json['coupon'];
    customerId = json['customerId'];
    totalAmount = json['totalAmount'];
    isCouponApplied = json['isCouponApplied'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appliedCouponId'] = appliedCouponId;
    data['coupon'] = coupon;
    data['customerId'] = customerId;
    data['totalAmount'] = totalAmount;
    data['isCouponApplied'] = isCouponApplied;
    return data;
  }
}
