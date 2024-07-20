class ApiEndPoints {
  static const String getMovies = "movies_list";

  static const String getCategoryProducts = "/products/category/";

  static const String getProductDetails = "/products/";

  static const String getFeaturedProducts = "/products/featured";

  static const String getFeaturedCategories = "/categories/featured";

  static const String getCategories = "/categories?parent_id=";

  static const String getCarouselSlider = "/sliders";

  static const String getTodayDeal = "/products/todays-deal";

  static const String getOffers = "/products/offers";

  static const String getSubCategories = "/sub-categories/";

  static const String getProductVariant = "/products/variant/price?id=";

  static const String getProductVariantPost = "/products/variant/new-price";

  static const String brandProducts = "/products/brand";

  static const String buyAgainProducts = "/purchase-products";

  static const String flashDealProducts = "/flash-deal-products/";

  static const String login = "/auth/login_attempt";

  static const String logout = "/auth/logout";

  static const String walletBalance = "/wallet/balance";

  static const String walletHistory = "/wallet/history";

  static const String forgetPassword = "/auth/password/forget_request";

  static const String confirmLogin = "/auth/login";

  static const String confirmRegister = "/auth/confirm_code";

  static const String sendFcm = "/profile/update-device-token";

  static const String getUserData = "/get-user-by-access_token";

  static const String getUserCounters = "/profile/counters";

  static const String deleteImage = "/profile/delete-image";

  static const String getUserOrders = "/purchase-history";

  static const String getOrderHistoryDetails = "/purchase-history-details/";

  static const String getOrderHistoryItem = "/purchase-history-items/";

  static const String editProfile = "/profile/update";

  static const String editProfileImage = "/profile/update-image";

  static const String signup = "/auth/signup";

  static const String addToCart = "/carts/add";

  static const String orderCreate = "/order/store";

  static const String carts = "/carts";

  static const String deleteCarts = "/carts/";

  static const String paymentsTypes = "/payment-types";

  static const String updateCartItem = "/carts/process";

  static const String socialLogin = "/auth/social-login";

  static const String addAddress = "/user/shipping/create";

  static const String countries = "/countries";

  static const String cities = "/cities";

  static const String getUserAddresses = "/user/shipping/address";

  static const String sendNewAddress = "/update-address-in-cart";

  static const String stateByCountry = "/states-by-country/";

  static const String citiesByState = "/cities-by-state/";

  static const String cartProcess = '/carts/process';

  static const String cartSummary = "/cart-summary";

  static const String deliveryMethod = "/delivery-methods/get-list";

  static const String saveDeliveryMethod = "/delivery/store-user-delivery";

  static const String couponApply = "/coupon-apply";

  static const String couponRemove = "/coupon-remove";

  static const String cashOnDelivery = "/payments/pay/cod";

  static const String walletCash = "/payments/pay/wallet";

  static const String addToWishList = "/wishlists-add-product?product_id=";

  static const String wishlist = "/wishlists";

  static const String submitReview = "/reviews/submit";

  static const String getProductReviews = "/reviews/product/";

  static const String removeWishList = "/wishlists-remove-product?product_id=";

  static const String checkIfInWishlist =
      "/wishlists-check-product?product_id=";

  static const String searchReq = "/products/search";

  static const String getBrands = "/brands";

  static const String getShops = "/shops";

  static const String filterCategories = "/filter/categories";

  static const String flashDeals = "/flash-deals";

  static const String clubPoint = "/clubpoint/get-list";

  static const String convertPoint = "/clubpoint/convert-into-wallet";

  static const String myPoints = "/clubpoint/get-details";

  static const String convertAllPoints = "/clubpoint/convert-all-into-wallet";

  static const String updateAddress = "/user/shipping/update";

  static const String deleteAddress = "/user/shipping/delete/";

  static const String generalSettings = "/getMobileSettings";

  static const String privacyPolicy = "/privacy-policy";

  static const String termAndCondition = "/terms";

  static const String socialLinks = "/socialMediaLinks";

  static const String shippingAddressMap = "/user/shipping/update-location";

  static const String changeCountry = "/change-country";

  static const String updateLang = "/update-language";

  static const String notification = "/notification";

  static const String deleteAccount = "/delete-account";
}
