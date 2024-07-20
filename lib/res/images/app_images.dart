import 'base_image.dart';

class AppImage implements BaseImages {
  static String theme = '';

  @override
  String get emptyCartImage {
    switch (theme) {
      case 'dark':
        return "assets/images/cart.png";

      case 'light':
        return "assets/images/cart_light.png";

      default:
        {
          return "assets/images/cart_light.png";
        }
    }
  }

  @override
  String get mustLoginImage {
    switch (theme) {
      case 'dark':
        return "assets/images/signIn.png";

      case 'light':
        return "assets/images/login_light.png";

      default:
        {
          return "assets/images/login_light.png";
        }
    }
  }

  @override
  String get offlineImage {
    switch (theme) {
      case 'dark':
        return "assets/images/offline.png";

      case 'light':
        return "assets/images/offline.png";

      default:
        {
          return "assets/images/offline.png";
        }
    }
  }

  @override
  String get noDataImage {
    switch (theme) {
      case 'dark':
        return "assets/images/no_data.png";

      case 'light':
        return "assets/images/no_data.png";

      default:
        {
          return "assets/images/no_data.png";
        }
    }
  }

  @override
  String get logoImage {
    switch (theme) {
      case 'dark':
        return "assets/images/lamisLogo.png";

      case 'light':
        return "assets/images/lamisLogo.png";

      default:
        {
          return "assets/images/lamisLogo.png";
        }
    }
  }

  String get familyImage {
    switch (theme) {
      case 'dark':
        return "assets/images/family.png";

      case 'light':
        return "assets/images/family.png";

      default:
        {
          return "assets/images/family.png";
        }
    }
  }

  String get cleaningImage {
    switch (theme) {
      case 'dark':
        return "assets/images/blue collecions.png";

      case 'light':
        return "assets/images/blue collecions.png";

      default:
        {
          return "assets/images/blue collecions.png";
        }
    }
  }

  @override
  String get firstWalk {
    switch (theme) {
      case 'dark':
        return "assets/images/touri.png";

      case 'light':
        return "assets/images/touri.png";

      default:
        {
          return "assets/images/touri.png";
        }
    }
  }

  @override
  String get secondWalk {
    switch (theme) {
      case 'dark':
        return "assets/images/group.png";

      case 'light':
        return "assets/images/group.png";

      default:
        {
          return "assets/images/group.png";
        }
    }
  }

  @override
  String get thirdWalk {
    switch (theme) {
      case 'dark':
        return "assets/images/buy.png";

      case 'light':
        return "assets/images/buy.png";

      default:
        {
          return "assets/images/buy.png";
        }
    }
  }

  @override
  String get verificationLogo {
    switch (theme) {
      case 'dark':
        return "assets/images/verificationLogo_light.png";

      case 'light':
        return "assets/images/verificationLogo_light.png";

      default:
        {
          return "assets/images/verificationLogo_light.png";
        }
    }
  }

  @override
  String get appleIcon {
    switch (theme) {
      case 'dark':
        return "assets/images/apple.png";

      case 'light':
        return "assets/images/apple.png";

      default:
        {
          return "assets/images/apple.png";
        }
    }
  }

  @override
  String get firstNameIcon {
    switch (theme) {
      case 'dark':
        return "assets/images/first name-1.png";

      case 'light':
        return "assets/images/first name-1.png";

      default:
        {
          return "assets/images/first name-1.png";
        }
    }
  }

  @override
  String get lastNameIcon {
    switch (theme) {
      case 'dark':
        return 'assets/images/last name.png';

      case 'light':
        return 'assets/images/last name.png';

      default:
        {
          return 'assets/images/last name.png';
        }
    }
  }

  @override
  String get editProfileIcon {
    switch (theme) {
      case 'dark':
        return 'assets/images/editPr.png';

      case 'light':
        return 'assets/images/editPr.png';

      default:
        {
          return 'assets/images/editPr.png';
        }
    }
  }

  @override
  String get wishlistIcon {
    switch (theme) {
      case 'dark':
        return 'assets/images/wishlist.png';

      case 'light':
        return 'assets/images/wishlist.png';

      default:
        {
          return 'assets/images/wishlist.png';
        }
    }
  }

  @override
  String get walletIcon {
    switch (theme) {
      case 'dark':
        return 'assets/images/wallet.png';

      case 'light':
        return 'assets/images/wallet.png';

      default:
        {
          return 'assets/images/wallet.png';
        }
    }
  }

  @override
  String get pointIcon {
    switch (theme) {
      case 'dark':
        return 'assets/images/points.png';

      case 'light':
        return 'assets/images/points.png';

      default:
        {
          return 'assets/images/points.png';
        }
    }
  }

  @override
  String get offers {
    switch (theme) {
      case 'dark':
        return 'assets/images/offers.png';

      case 'light':
        return 'assets/images/offers.png';

      default:
        {
          return 'assets/images/offers.png';
        }
    }
  }

  @override
  String get ordersIcon {
    switch (theme) {
      case 'dark':
        return 'assets/images/ordersIcon.png';

      case 'light':
        return 'assets/images/ordersIcon.png';

      default:
        {
          return 'assets/images/ordersIcon.png';
        }
    }
  }

  @override
  String get deleteIcon {
    switch (theme) {
      case 'dark':
        return 'assets/images/deleteIcon.png';

      case 'light':
        return 'assets/images/deleteIcon.png';

      default:
        {
          return 'assets/images/deleteIcon.png';
        }
    }
  }

  @override
  String get orderPlacedIcon {
    switch (theme) {
      case 'dark':
        return 'assets/images/orderPlaced.png';

      case 'light':
        return 'assets/images/orderPlaced.png';

      default:
        {
          return 'assets/images/orderPlaced.png';
        }
    }
  }

  @override
  String get confirmedIcon {
    switch (theme) {
      case 'dark':
        return 'assets/images/confirmed.png';

      case 'light':
        return 'assets/images/confirmed.png';

      default:
        {
          return 'assets/images/confirmed.png';
        }
    }
  }

  @override
  String get shippingIcon {
    switch (theme) {
      case 'dark':
        return 'assets/images/on_delivery.png';

      case 'light':
        return 'assets/images/on_delivery.png';

      default:
        {
          return 'assets/images/on_delivery.png';
        }
    }
  }

  @override
  String get moneyIcon {
    switch (theme) {
      case 'dark':
        return 'assets/images/moneyIcon.png';

      case 'light':
        return 'assets/images/moneyIcon.png';

      default:
        {
          return 'assets/images/moneyIcon.png';
        }
    }
  }

  @override
  String get filterIcon {
    switch (theme) {
      case 'dark':
        return 'assets/images/filterIcon.png';

      case 'light':
        return 'assets/images/filterIcon.png';

      default:
        {
          return 'assets/images/filterIcon.png';
        }
    }
  }

  @override
  String get noReviews {
    switch (theme) {
      case 'dark':
        return 'assets/images/no_reviews.png';

      case 'light':
        return 'assets/images/no_reviews.png';

      default:
        {
          return 'assets/images/no_reviews.png';
        }
    }
  }

  @override
  String get searchResult {
    switch (theme) {
      case 'dark':
        return 'assets/images/searchResult.png';

      case 'light':
        return 'assets/images/searchResult.png';

      default:
        {
          return 'assets/images/searchResult.png';
        }
    }
  }

  @override
  String get errorImage {
    switch (theme) {
      case 'dark':
        return 'assets/images/errorImage.png';

      case 'light':
        return 'assets/images/errorImage.png';

      default:
        {
          return 'assets/images/errorImage.png';
        }
    }
  }

  @override
  String get flashImage {
    switch (theme) {
      case 'dark':
        return 'assets/images/flash.png';

      case 'light':
        return 'assets/images/flash.png';

      default:
        {
          return 'assets/images/flash.png';
        }
    }
  }

  @override
  String get noProduct {
    switch (theme) {
      case 'dark':
        return 'assets/images/empty_product.png';

      case 'light':
        return 'assets/images/empty_product.png';

      default:
        {
          return 'assets/images/empty_product.png';
        }
    }
  }

  @override
  String get privacyImage {
    switch (theme) {
      case 'dark':
        return 'assets/images/privacy.png';

      case 'light':
        return 'assets/images/privacy.png';

      default:
        {
          return 'assets/images/privacy.png';
        }
    }
  }

  @override
  String get termImage {
    switch (theme) {
      case 'dark':
        return 'assets/images/term.png';

      case 'light':
        return 'assets/images/term.png';

      default:
        {
          return 'assets/images/term.png';
        }
    }
  }

  @override
  String get introBackGround {
    switch (theme) {
      case 'dark':
        return 'assets/images/Dark.png';

      case 'light':
        return 'assets/images/BACKGROUND.png';

      default:
        {
          return 'assets/images/BACKGROUND.png';
        }
    }
  }
}
