import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquor_purchase_app/Widgets/text_widget.dart';
import 'package:liquor_purchase_app/const/firebase_consts.dart';
import 'package:liquor_purchase_app/providers/orders_provider.dart';
import 'package:liquor_purchase_app/screens/cart/cart_widget.dart';
import 'package:liquor_purchase_app/Widgets/empty_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemsList =
        cartProvider.getCartItems.values.toList().reversed.toList();

    return cartItemsList.isEmpty
        ? const EmptyScreen(
            title: 'Your Cart is Empty',
            subtitle: 'Add something and make me Happy :)',
            buttonText: 'Shop Now',
            imagePath: 'assets/images/cart.png',
          )
        : Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: TextWidget(
                  text: 'Cart (${cartItemsList.length})',
                  color: color,
                  isTitle: true,
                  textSize: 22,
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      GlobalMethods.warningDialog(
                          title: 'Empty Your Cart',
                          subtitle: 'Are you Sure?',
                          fct: () async {
                            await cartProvider.clearOnlineCart();
                            cartProvider.clearLocalCart();
                          },
                          context: context);
                    },
                    icon: Icon(
                      IconlyBroken.delete,
                      color: color,
                    ),
                  ),
                ]),
            body: Column(
              children: [
                _checkout(ctx: context),
                Expanded(
                  child: ListView.builder(
                      itemCount: cartItemsList.length,
                      itemBuilder: (ctx, index) {
                        return ChangeNotifierProvider.value(
                            value: cartItemsList[index],
                            child: CartWidget(
                              q: cartItemsList[index].quantity,
                            ));
                      }),
                ),
              ],
            ),
          );
  }

  Widget _checkout({required BuildContext ctx}) {
    final Color color = Utils(ctx).color;
    Size size = Utils(ctx).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(ctx);
    final productProvider = Provider.of<ProductsProvider>(ctx);
    final ordersProvider = Provider.of<OrdersProvider>(ctx);

    double total = 0.0;
    cartProvider.getCartItems.forEach((key, value) {
      final getcurrProduct = productProvider.findProdById(value.productId);
      total += (getcurrProduct.isOnSale
              ? getcurrProduct.salePrice
              : getcurrProduct.price) *
          value.quantity;
    });
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.1,
      // color: ,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(children: [
          Material(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () async {
                User? user = authInstance.currentUser;
                final orderId = const Uuid().v4();
                final productProvider =
                    Provider.of<ProductsProvider>(ctx, listen: false);
                cartProvider.getCartItems.forEach((key, value) async {
                  final getcurrProduct = productProvider.findProdById(
                    value.productId,
                  );
                  try {
                    await FirebaseFirestore.instance
                        .collection('orders')
                        .doc(orderId)
                        .set({
                      'orderId': orderId,
                      'userId': user!.uid,
                      'productId': value.productId,
                      'price': (getcurrProduct.isOnSale
                              ? getcurrProduct.salePrice
                              : getcurrProduct.price) *
                          value.quantity,
                      'totalPrice': total,
                      'quantity': value.quantity,
                      'imageUrl': getcurrProduct.imageUrl,
                      'userName': user.displayName,
                      'orderDate': Timestamp.now(),
                    });
                    await cartProvider.clearOnlineCart();
                    cartProvider.clearLocalCart();
                    ordersProvider.fetchOrders();
                    await Fluttertoast.showToast(
                      msg: "Your order has been placed",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                    );
                  } catch (error) {
                    GlobalMethods.errorDialog(
                        subtitle: error.toString(), context: ctx);
                  } finally {}
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextWidget(
                  text: 'Order Now',
                  textSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Spacer(),
          FittedBox(
            child: TextWidget(
              text: 'Total: Rs.${total.toStringAsFixed(2)}',
              color: color,
              textSize: 18,
              isTitle: true,
            ),
          ),
        ]),
      ),
    );
  }
}
