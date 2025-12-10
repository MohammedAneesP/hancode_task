import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hancode_task/features/cart/data/cart_model.dart';
import 'package:hancode_task/features/cart/provider/cart_provider.dart';
import 'package:hancode_task/features/cart/provider/category_provider.dart';
import 'package:hancode_task/routes/route_constants.dart';

class CleaningServicesScreen extends ConsumerStatefulWidget {
  const CleaningServicesScreen({super.key});

  @override
  ConsumerState<CleaningServicesScreen> createState() =>
      _CleaningServicesScreenState();
}

class _CleaningServicesScreenState
    extends ConsumerState<CleaningServicesScreen> {
  final categories = ["Deep cleaning", "Maid Services", "Car Cleaning"];

  final Map<int, List<Map<String, dynamic>>> servicesByCategory = {
    0: [
      {
        "id": 1,
        "name": "Deep Bathroom Cleaning",
        "price": 799.0,
        "time": "90 Minutes",
        "rating": 4.5,
        "orders": 30,
        "image": "assets/images/bath_clean.jpg",
      },
    ],
    1: [
      {
        "id": 2,
        "name": "Bathroom Cleaning",
        "price": 499.0,
        "time": "60 Minutes",
        "rating": 4.2,
        "orders": 23,
        "image": "assets/images/bath_clean.jpg",
      },
      {
        "id": 3,
        "name": "Kitchen Cleaning",
        "price": 699.0,
        "time": "90 Minutes",
        "rating": 4.5,
        "orders": 40,
        "image": "assets/images/bath_clean.jpg",
      },
    ],
    2: [
      {
        "id": 4,
        "name": "Car Interior Cleaning",
        "price": 999.0,
        "time": "120 Minutes",
        "rating": 4.7,
        "orders": 18,
        "image": "assets/images/bath_clean.jpg",
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    final categories = ["Deep cleaning", "Maid Services", "Car Cleaning"];
    final services = servicesByCategory[selectedCategory] ?? [];
    // final cart = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Cleaning Services"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: const Icon(Icons.arrow_back),
      ),

      body: Column(
        children: [
          /// -------- CATEGORY TABS --------
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(categories.length, (index) {
                final isSelected = index == selectedCategory;

                return GestureDetector(
                  onTap: () {
                    ref.read(selectedCategoryProvider.notifier).state = index;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.green.shade100
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: isSelected ? Colors.green : Colors.black,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          /// -------- SERVICES LIST --------
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final s = services[index];

                final itemInCart = cart.firstWhere(
                  (e) => e.id == s["id"],
                  orElse: () =>
                      CartItem(id: -1, name: '', quantity: 0, price: 0),
                );

                return _ServiceCard(service: s, itemInCart: itemInCart);
              },
            ),
          ),
        ],
      ),

      /// -------- CART PANEL --------
      bottomNavigationBar: cart.isNotEmpty ? CartBottomBar(cart: cart) : null,
    );
  }
}

class _ServiceCard extends ConsumerWidget {
  final Map service;
  final CartItem itemInCart;

  const _ServiceCard({required this.service, required this.itemInCart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
        color: Colors.white,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              service["image"],
              height: 70,
              width: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(
                      " (${service['rating']}/5) ${service['orders']} Orders",
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  service["name"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  service["time"],
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  "₹ ${service["price"]}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          itemInCart.quantity == 0
              ? _AddButton(service: service)
              : _QtyController(item: itemInCart),
        ],
      ),
    );
  }
}

class _AddButton extends ConsumerWidget {
  final Map service;

  const _AddButton({required this.service});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref
            .read(cartProvider.notifier)
            .addToCart(
              CartItem(
                id: service["id"],
                name: service["name"],
                quantity: 1,
                price: service["price"],
              ),
            );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Row(
          children: [
            Text("Add", style: TextStyle(color: Colors.white)),
            SizedBox(width: 4),
            Icon(Icons.add, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _QtyController extends ConsumerWidget {
  final CartItem item;

  const _QtyController({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          /// Decrease Button
          GestureDetector(
            onTap: () {
              if (item.quantity == 1) {
                ref.read(cartProvider.notifier).removeFromCart(item.id);
              } else {
                ref
                    .read(cartProvider.notifier)
                    .updateQuantity(item.id, item.quantity - 1);
              }
            },
            child: const Icon(Icons.remove, color: Colors.green),
          ),

          const SizedBox(width: 12),

          /// Quantity
          Text(
            item.quantity.toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(width: 12),

          /// Increase Button
          GestureDetector(
            onTap: () {
              ref
                  .read(cartProvider.notifier)
                  .updateQuantity(item.id, item.quantity + 1);
            },
            child: const Icon(Icons.add, color: Colors.green),
          ),
        ],
      ),
    );
  }
}

class CartBottomBar extends ConsumerWidget {
  final List<CartItem> cart;

  const CartBottomBar({super.key, required this.cart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalPrice = ref
        .read(cartProvider.notifier)
        .totalPrice
        .toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// ITEM COUNT + TOTAL PRICE
          Text(
            "${cart.length} items  |  ₹$totalPrice",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 10),

          /// VIEW CART BUTTON
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
              Navigator.pushNamed(context, RouteConstants.cart);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6F4E), // orange
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "VIEW CART",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
