import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hancode_task/features/cart/provider/cart_provider.dart';
import 'package:hancode_task/features/cart/data/cart_model.dart';

class CartViewScreen extends ConsumerWidget {
  const CartViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    if (cart.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Cart"),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          leading: const BackButton(color: Colors.black),
        ),
        body: const _EmptyCartView(),
      );
    }

    final cartNotifier = ref.read(cartProvider.notifier);

    final taxes = 50.0;
    final couponDiscount = 150.0;
    final total = cartNotifier.totalPrice;
    final grandTotal = (total + taxes - couponDiscount).clamp(
      0,
      double.infinity,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: const BackButton(color: Colors.black),
      ),

      /// ✅ FLOATING BOTTOM BUTTON
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------------- CART ITEMS ----------------
            ...cart.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final item = entry.value;

              return _CartItemTile(index: index, item: item);
            }),

            const SizedBox(height: 8),

            /// Add more services
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Add more Services",
                style: TextStyle(color: Colors.green),
              ),
            ),

            const SizedBox(height: 16),

            /// ---------------- FREQUENTLY ADDED ----------------
            const Text(
              "Frequently added services",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (_, i) => _FrequentlyAddedCard(),
              ),
            ),

            const SizedBox(height: 20),

            /// ---------------- COUPON ----------------
            _CouponSection(),

            const SizedBox(height: 16),

            /// Wallet info
            Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Your wallet balance is ₹125, you can redeem ₹10 in this order.",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ---------------- BILL DETAILS ----------------
            _BillDetails(
              cart: cart,
              taxes: taxes,
              coupon: couponDiscount,
              total: grandTotal.toDouble(),
            ),

            SizedBox(height: 12),

            // BOOK SLOT BUTTON (FULL WIDTH)
            _bookSlotButton(total),

            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  Widget _bookSlotButton(double total) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Grand Total  |  ₹${total.toStringAsFixed(0)}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                // fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            // margin: const EdgeInsets.all(16),
            // padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF6EDC88), // light green
                  Color(0xFF2FAE60), // dark green
                ],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// LEFT TEXT

                /// RIGHT ARROW
                SizedBox(
                  height: 50.h,

                  // width: 34,
                  child: Row(
                    children: [
                      SizedBox(width: 150.w),
                      Text(
                        "Book Slot",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 100.w),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemTile extends ConsumerWidget {
  final int index;
  final CartItem item;

  const _CartItemTile({required this.index, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartNotifier = ref.read(cartProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$index. ${item.name}",
              style: const TextStyle(fontSize: 15),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 16),
                  onPressed: () {
                    if (item.quantity == 1) {
                      cartNotifier.removeFromCart(item.id);
                    } else {
                      cartNotifier.updateQuantity(item.id, item.quantity - 1);
                    }
                  },
                ),
                Text(item.quantity.toString()),
                IconButton(
                  icon: const Icon(Icons.add, size: 16),
                  onPressed: () =>
                      cartNotifier.updateQuantity(item.id, item.quantity + 1),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),
          Text("₹${(item.price * item.quantity).toStringAsFixed(0)}"),
        ],
      ),
    );
  }
}

class _FrequentlyAddedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              "assets/images/bath_clean.jpg",
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Bathroom Cleaning", maxLines: 1),
                SizedBox(height: 4),
                Text("₹500", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CouponSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Enter Coupon Code",
                border: InputBorder.none,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Apply"),
          ),
        ],
      ),
    );
  }
}

class _BillDetails extends StatelessWidget {
  final List<CartItem> cart;
  final double taxes;
  final double coupon;
  final double total;

  const _BillDetails({
    required this.cart,
    required this.taxes,
    required this.coupon,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Bill Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          ...cart.map((e) => _row(e.name, "₹${e.price * e.quantity}")),

          _row("Taxes and Fees", "₹$taxes"),
          _row("Coupon Code", "-₹$coupon", isGreen: true),

          const Divider(),

          _row("Total", "₹${total.toStringAsFixed(0)}", bold: true),
        ],
      ),
    );
  }

  Widget _row(
    String label,
    String value, {
    bool bold = false,
    bool isGreen = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: isGreen ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              "Your cart is empty",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Looks like you haven't added\nany services yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              ),
              child: const Text(
                "Explore Services",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
