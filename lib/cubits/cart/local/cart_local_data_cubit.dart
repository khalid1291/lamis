import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/local/cart_service.dart';
import '../../../repos/repos.dart';
import '../../../models/models.dart';

part 'cart_local_data_state.dart';

class CartLocalDataCubit extends Cubit<CartLocalDataState> {
  final _myRepo = CartRepo();
  CartLocalDataCubit() : super(CartLocalDataInitial());

  Future<void> fetchRemoteData() async {
    emit(CartLocalDataLoading());

    try {
      List val = await _myRepo.fetchCartItems();
      List<CartItem> carts = [];
      for (var element in val) {
        List<CartItem> cart = element.cartItems!;
        for (var h in cart) {
          carts.add(h);
        }
      }
      emit(CartLocalDataDone(carts));
    } catch (e) {
      emit(CartLocalDataError(e.toString()));
    }
  }

  Future<void> fetchRemoteDataForUpdate() async {
    try {
      List val = await _myRepo.fetchCartItems();
      List<CartItem> carts = [];
      for (var element in val) {
        List<CartItem> cart = element.cartItems!;
        for (var h in cart) {
          carts.add(h);
        }
      }
      emit(CartLocalDataDone(carts));
    } catch (e) {
      emit(CartLocalDataError(e.toString()));
    }
  }

  Future<void> getCartData() async {
    emit(CartLocalDataLoading());
    // await Future.delayed(Duration(seconds: 2));
    try {
      List<CartItem> carts = [];
      List<Map<String, dynamic>> items = await CartService.getItems();
      for (var element in items) {
        CartItem ite = CartItem(
            id: element['id'],
            ownerId: 0,
            userId: element['user_id'],
            productId: element['product_id'],
            productName: element['product_name'],
            variation: element['variation'],
            price: element['price'],
            productThumbnailImage: element['product_thumbnail_image'],
            shippingCost: 0,
            lowerLimit: 0,
            upperLimit: element['upper_limit'],
            currencySymbol: '\$',
            tax: 0,
            quantity: element['quantity'],
            isFavourite: false);
        carts.add(ite);
      }
      emit(CartLocalDataDone(carts));
    } catch (e) {
      emit(CartLocalDataError(e.toString()));
    }
  }

  Future<void> deleteRemoteItem(int itemId, int userId) async {
    try {
      await _myRepo.deleteCartItem(itemId).then((value) async {
        if (value?.result == true) {
          List val = await _myRepo.fetchCartItems();
          List<CartItem> carts = [];
          for (var element in val) {
            List<CartItem> cart = element.cartItems!;
            for (var h in cart) {
              carts.add(h);
            }
          }
          emit(CartLocalDataDone(carts));
        } else {
          emit(CartLocalDataError(value?.message ?? ""));
        }
      });
    } catch (e) {
      emit(CartLocalDataError(e.toString()));
    }
  }

  Future<void> updateRemoteObject(
      int cartItemId, int quantity, int userId) async {
    try {
      await _myRepo.updateCartItem(cartItemId, quantity).then((value) async {
        if (value?.result == true) {
          List val = await _myRepo.fetchCartItems();
          List<CartItem> carts = [];
          for (var element in val) {
            List<CartItem> cart = element.cartItems!;
            for (var h in cart) {
              carts.add(h);
            }
          }
          emit(CartLocalDataDone(carts));
        } else {
          List val = await _myRepo.fetchCartItems();
          List<CartItem> carts = [];
          for (var element in val) {
            List<CartItem> cart = element.cartItems!;
            for (var h in cart) {
              carts.add(h);
            }
          }
          emit(CartLocalDataDone(carts, message: value?.message));
        }
      });
    } catch (e) {
      emit(CartLocalDataError(e.toString()));
    }
  }

  Future<void> deleteCartItem(int id) async {
    try {
      CartService.deleteItem(id);
      List<CartItem> carts = [];
      List<Map<String, dynamic>> items = await CartService.getItems();
      for (var element in items) {
        CartItem ite = CartItem(
            id: element['id'],
            ownerId: 0,
            userId: element['user_id'],
            productId: element['product_id'],
            productName: element['product_name'],
            variation: element['variation'],
            price: element['price'],
            productThumbnailImage: element['product_thumbnail_image'],
            shippingCost: 0,
            lowerLimit: 0,
            upperLimit: 0,
            currencySymbol: '\$',
            tax: 0,
            quantity: element['quantity'],
            isFavourite: false);
        carts.add(ite);
      }
      emit(CartLocalDataDone(carts));
    } catch (e) {
      emit(CartLocalDataError(e.toString()));
    }
  }

  Future<void> updateCartItem(
      int id, int quantity, CartItem item, int userId, String variant) async {
    try {
      CartService.updateItem(id, quantity, item, userId, variant);
      List<CartItem> carts = [];
      List<Map<String, dynamic>> items = await CartService.getItems();
      for (var element in items) {
        CartItem ite = CartItem(
            isFavourite: false,
            id: element['id'],
            ownerId: 0,
            userId: element['user_id'],
            productId: element['product_id'],
            productName: element['product_name'],
            variation: element['variation'],
            price: element['price'],
            productThumbnailImage: element['product_thumbnail_image'],
            shippingCost: 0,
            lowerLimit: 0,
            upperLimit: 0,
            currencySymbol: '\$',
            tax: 0,
            quantity: element['quantity']);
        carts.add(ite);
      }
      emit(CartLocalDataDone(carts));
    } catch (e) {
      emit(CartLocalDataError(e.toString()));
    }
  }
}
