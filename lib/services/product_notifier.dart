import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_database/models/products.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductNotifier extends StateNotifier<List<Products>> {
  ProductNotifier() : super([]);

  final products = FirebaseFirestore.instance
      .collection('products')
      .withConverter(fromFirestore: (snapshot, _) {
    return Products.fromJson(snapshot.id, snapshot.data()!);
  }, toFirestore: (model, _) {
    return model.toJson();
  });

  void addProduct(Products product) {
    products.add(product);
  }

  void updateProduct(String id, Products product) {
    products.doc(id).update({'purchased': product.purchased!});
  }

  void deleteProduct(String id) {
    products.doc(id).delete();
  }
}
