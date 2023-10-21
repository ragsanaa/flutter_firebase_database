import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_database/models/products.dart';
import 'package:flutter_firebase_database/services/product_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsProvider = StreamProvider.autoDispose<List<Products>>(
  (ref) {
    final stream =
        FirebaseFirestore.instance.collection('products').snapshots();

    return stream.map((event) {
      return event.docs.map((e) {
        return Products.fromJson(e.id, e.data());
      }).toList();
    });
  },
);

final productServiceProvider =
    StateNotifierProvider<ProductNotifier, List<Products>>(
  (ref) => ProductNotifier(),
);

final imagePathProvider = StateProvider<String>((ref) => '');
final imageNameProvider = StateProvider<String>((ref) => '');
