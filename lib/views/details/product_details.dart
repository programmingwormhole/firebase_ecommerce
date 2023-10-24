import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> data;

  const Details({super.key, required this.data});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Center(
        child: Column(
          children: [
            Image.network(widget.data['image']),
            Text(widget.data['name']),
            Text(widget.data['price']),
            Card(
              child: TextButton(
                onPressed: () async {
                  // Get cart
                  final data = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.email)
                      .collection('cart')
                      .where('name', isEqualTo: widget.data['name']).get();
                  if(data.docs.isEmpty) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.email)
                        .collection('cart')
                        .add({
                      'name': widget.data['name'],
                      'price': widget.data['price'],
                      'image': widget.data['image'],
                      'cat_id': widget.data['cat_id'],
                      'quantity': 1
                    });
                  } else {
                    print('Already in cart');
                  }

                },
                child: const Text('Add To Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
