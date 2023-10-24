import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PBCScreen extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> data;

  const PBCScreen({super.key, required this.data});

  @override
  State<PBCScreen> createState() => _PBCScreenState();
}

class _PBCScreenState extends State<PBCScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data['name']),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('cat_id', isEqualTo: widget.data['id'])
            .snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return snapshot.data!.docs.isEmpty ? const Center(
            child: Text('No products available'),
          ) : ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
            final data = snapshot.data!.docs[index];
            return Card(
              child: ListTile(
                title: Text(data['name']),
              ),
            );
          },);
        },
      ),
    );
  }
}
