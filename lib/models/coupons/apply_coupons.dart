class ApplyCouponModel {
  String? status;
  Data? data;
  String? message;

  ApplyCouponModel({this.status, this.data, this.message});

  ApplyCouponModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  int? appliedCouponId;
  String? coupon;
  String? customerId;
  int? totalAmount;
  bool? isCouponApplied;

  Data(
      {this.appliedCouponId,
      this.coupon,
      this.customerId,
      this.totalAmount,
      this.isCouponApplied});

  Data.fromJson(Map<String, dynamic> json) {
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
