import 'package:flutter/material.dart';
import 'package:flutter_firebase_database/models/products.dart';
import 'package:flutter_firebase_database/services/cloud_service.dart';

class ProductScreen extends StatelessWidget {
  final Products product;
  const ProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    CloudService cloudService = CloudService();
    String imageName = (product.imgPath == null || product.imgPath == '')
        ? 'Screen Shot 2022-10-17 at 11.06.26.png'
        : product.imgPath.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name.toString()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: cloudService.getFile(imageName),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                return Image.network(snapshot.data.toString());
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                product.purchased! ? 'Purchased' : 'Not Purchased',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
