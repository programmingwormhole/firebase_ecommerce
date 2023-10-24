import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_firebase/global_widgets/custom_button.dart';
import 'package:ecommerce_firebase/global_widgets/custom_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final user = FirebaseAuth.instance.currentUser;

  double calculateTotalAmount(List<QueryDocumentSnapshot> cartData) {
    double totalAmount = 0.0;
    for (var data in cartData) {
      double price = double.parse(data['price']);
      int quantity = data['quantity'];
      totalAmount += price * quantity;
    }
    return totalAmount;
  }

  List<QueryDocumentSnapshot> cartItems = [];

  double totalPrice = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user!.email)
          .collection('cart')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          cartItems = snapshot.data!.docs;
          List<QueryDocumentSnapshot> cartData = snapshot.data!.docs;
          double totalAmount = calculateTotalAmount(cartData);
          totalPrice = totalAmount;
          return Scaffold(
            appBar: customAppBar(context: context, title: 'Cart'),
            body: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                return Card(
                  child: ListTile(
                    title: Text(data['name']),
                    subtitle: Text(
                      '\$${data['price']}',
                      style: TextStyle(
                        color: Colors.black.withOpacity(.5),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user!.email)
                                  .collection('cart')
                                  .doc(data.id)
                                  .update(
                                {
                                  'quantity': data['quantity'] + 1,
                                },
                              );
                            },
                            child: const Icon(Icons.add_circle_outline)),
                        Text(
                          data['quantity'].toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        TextButton(
                            onPressed: () {
                              if (data['quantity'] > 1) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user!.email)
                                    .collection('cart')
                                    .doc(data.id)
                                    .update(
                                  {
                                    'quantity': data['quantity'] - 1,
                                  },
                                );
                              }
                            },
                            child: const Icon(Icons.remove_circle_outline)),
                      ],
                    ),
                  ),
                );
              },
            ),
            bottomNavigationBar: Container(
              height: 130,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.1),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total'),
                        Text(
                          '\$$totalPrice',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomButton(
                      buttonTitle: 'Checkout',
                      onTap: () async {
                        List<Map<String, dynamic>> cardData = cartItems.map((item) => item.data() as Map<String, dynamic>).toList();
                        try {
                          FirebaseFirestore.instance.collection('order').add({
                            'uid': user!.uid,
                            'email': user!.email,
                            'time': Timestamp.now(),
                            'items': cardData
                          }).then((value) async {
                            // get data
                            final cart = await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user!.email)
                                .collection('cart')
                                .get();
                            for (var item in cart.docs) {
                              await item.reference.delete();
                            }
                          });
                        } catch (e) {
                          print('Error $e');
                        }

                      },
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
