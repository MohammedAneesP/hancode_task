import 'package:flutter_riverpod/legacy.dart';
import 'package:hancode_task/features/cart/data/cart_db.dart';
import 'package:hancode_task/features/cart/data/cart_model.dart';


final cartProvider =
    StateNotifierProvider<CartController, List<CartItem>>((ref) {
  return CartController();
});

class CartController extends StateNotifier<List<CartItem>> {
  CartController() : super([]) {
    loadCart();
  }

  Future<void> loadCart() async {
    final items = await CartDB.instance.getItems();
    state = items;
  }

  Future<void> addToCart(CartItem item) async {
    await CartDB.instance.addItem(item);
    await loadCart();
  }

  Future<void> updateQuantity(int id, int qty) async {
    await CartDB.instance.updateQuantity(id, qty);
    await loadCart();
  }

  Future<void> removeFromCart(int id) async {
    await CartDB.instance.removeItem(id);
    await loadCart();
  }

  int get totalItems =>
      state.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      state.fold(0, (sum, item) => sum + (item.price * item.quantity));
}
