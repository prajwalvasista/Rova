class APIEndPoints {
  APIEndPoints._();

  static const String register = "UsersService/Registration";
  static const String baseUrl = String.fromEnvironment(
      "base_url"); //"https://rova_solutions.acelucid.com/api/";
  static const String baseUrlModel = "https://rova_model.acelucid.com/";
  static const String verifyOtpLogin = "Users/verifyLogin";
  static const String verifyOtpRegister = "UsersService/VerifyOtp";

  static const String users = "/api/users";
  static const String logout = "user/logout";
  static const String login = "UsersService/Login";
  static const String deleteAccount = "Users/DeleteUserByPhoneNumber";

  static const String user = "/user";
  static const String shopStore =
      "NearbyShopDetailsService/getShopDetailsByCity?City=";
  static const tomatoEndPoints = "tomatoModel";
  static const String cropDetails = "CropInfoService/getCropDetails?modelName=";

  //address
  static const allAddress = "AddressService/getAddressByCustomerId?customerId=";
  static const editAddress = "AddressService/";
  static const addAddress = "AddressService/AddAddress";
  static const getAddressById =
      "AddressService/getAddressByCustomerId?customerId=";
  static const deleteAddress = "AddressService/DeleteAddress?addressId=";
  static const getChoosedAddressByCustomer =
      "AddressService/getChoosedAddressByCustomer?customerId=";
  static const chooseAddressOfCustomer =
      "AddressService/ChooseAddressOfCustomer?customerId=";

  // selller endpoints
  static const addSellerCommercialDetails =
      "SellerService/addSellerCommercialDetails";
  static const getTotalOrderdProductsForSeller =
      "OrderServices/getTotalOrderdProductsForSeller?sellerId=";

  // product
  static const addProduct = "ProductServices/addProducts";
  static const editProduct = "ProductServices/updateProducts?ProductId=";
  static const deleteProduct = "ProductServices/DeleteProducts?productId=";
  static const getAllProduct =
      "ProductServices/getAllProductsByCustomerId?customerid=";
  static const getProductById =
      "ProductServices/getProductsByProductId?ProductId=";
  static const getProductBySellerId =
      "ProductServices/getProductsBySellerId?sellerId=";
  static const getProductCountInWishlistAndCart =
      "CustomerService/getProductsInWishListAndCart?customerId=";
  static const getSimilarProducts =
      "ProductServices/getSimilarProducts?category=";
  static const getAllProductCategory = "ProductServices/GetAllProductCategory";

  // admin
  static const getSellerDetailsByEmail =
      "AdminService/GetSellerDetailsByPhoneNo?phone_no=";

  // cart
  static const addProductToCart = "CartService/AddProductToCart";
  static const viewProductInCart = "CartService/ViewProductInCart?CustomerId=";
  static const updateProductInCart = "CartService/UpdateProductInCart";
  static const deleteProductFromCart =
      "CartService/DeleteProductFromCart?customerId=";

  // wishlist
  static const addToWishList = "WishListService/AddToWishList";
  static const getWishListByCustomerId =
      "WishListService/getWishListByCustomerId?customerId=";
  static const deleteProductsFromWishList =
      "WishListService/deleteProductsFromWishList?customerId=";

  //  order
  static const getOrderdProducts =
      "OrderServices/getOrderdProductsForSeller?sellerId=";
  static const orderApproval = "OrderServices/OrderApproval";
  static const placeOrder = "OrderServices/PlaceOrder?productId=";
  static const getOrderedProductForCustomer =
      "OrderServices/getOrderedProductsForCustomer?customerId=";
  static const getOrdersByOrderIdAndCustomerId =
      "OrderServices/getOrdersByOrderIdAndCustomerId?customerId=";

  //edit customer
  static const editCustomer = "CustomerService/EditCustomers?customerId=";
  static const getEditedCustomer =
      "CustomerService/getEditedCustomer?customerId=";

//coupon
  static const getAllCoupons = "Coupons/getAllCouponsGenerated?customerId=";
  static const applyCoupons = "Coupons/ApplyCoupons?couponId=";
  static const getCouponAppliedForCustomer =
      "Coupons/GetCouponsAppliedForCustomer?customerId=";
}
